// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:itoju_mobile/core/helpers/response_helper/api_response.dart';
import 'package:itoju_mobile/features/widgets/constants.dart';
import 'package:itoju_mobile/services/app_exception.dart';
import 'package:itoju_mobile/services/dio_provider.dart';

final medicationProvider =
    StateNotifierProvider<MedicationNotifier, MedicationState>((ref) {
  return MedicationNotifier(ref, ref.read(dioProvider));
});

class MedicationNotifier extends StateNotifier<MedicationState> {
  MedicationNotifier(this.ref, this.dio) : super(MedicationState.initial());
  Ref ref;
  Dio dio;

  Future<void> getMedicationList(String date) async {
    state = state.copyWith(status: Loader.loading);
    final Response response;
    try {
      response = await dio.get('user/medication_metrics/$date');

      var body = response.data;
      if (response.statusCode == 200) {
        List<MedicationModel> medicationModels = List<MedicationModel>.from(
            body['medicationMetrics'].map((e) => MedicationModel.fromMap(e)));
        state = state.copyWith(
            status: Loader.loaded, medicationModels: medicationModels);
      } else {
        state = state.copyWith(status: Loader.error, error: body["error"]);
      }
    } on DioException catch (e) {
      state = state.copyWith(status: Loader.error, error: e.message);
    } catch (e) {
      state = state.copyWith(
          status: Loader.error, error: 'An unexpected error occurred');
    }
  }

  Future<ApiResponse> createMedicationMetric(
      String date, MedicationModel model) async {
    state = state.copyWith(postStatus: Loader.loading);
    final Response response;
    try {
      response = await dio.post('user/medication_metrics/$date', data: {
        'metric': model.metric,
        'name': model.name,
        'dosage': model.dosage,
        'time': model.time,
        'quantity': model.quantity,
      });

      var body = response.data;
      if (response.statusCode == 200) {
        state = state.copyWith(postStatus: Loader.loaded);
        return ApiResponse(successMessage: body['message']);
      } else {
        state = state.copyWith(postStatus: Loader.error, error: body["error"]);
        return ApiResponse(
            errorMessage: body['error'], statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      state = state.copyWith(postStatus: Loader.error, error: e.message);
      return AppException.handleError(e);
    } catch (e) {
      state = state.copyWith(
          postStatus: Loader.error, error: 'An unexpected error occurred');
      return ApiResponse(errorMessage: 'An error occurred');
    }
  }

  Future<ApiResponse> updateMedicationMetric(MedicationModel model) async {
    state = state.copyWith(updateStatus: Loader.loading);
    final Response response;

    try {
      response = await dio.put('user/medication_metrics/${model.id}', data: {
        "time": model.time,
        'metric': model.metric,
        'name': model.name,
        'dosage': model.dosage,
        'quantity': model.quantity,
      });

      var body = response.data;
      if (response.statusCode == 200) {
        state = state.copyWith(updateStatus: Loader.loaded);
        return ApiResponse(successMessage: body['message']);
      } else {
        state =
            state.copyWith(updateStatus: Loader.error, error: body["error"]);
        return ApiResponse(
            errorMessage: body['error'], statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      state = state.copyWith(updateStatus: Loader.error, error: e.message);
      return AppException.handleError(e);
    } catch (e) {
      state = state.copyWith(
          updateStatus: Loader.error, error: 'An unexpected error occurred');
      return ApiResponse(errorMessage: 'An error occurred');
    }
  }

  Future<ApiResponse> deleteSymsMetric(int id) async {
    state = state.copyWith(delStatus: Loader.loading);
    final Response response;
    try {
      response = await dio.delete(
        'user/medication_metrics/${id}',
      );

      var body = response.data;
      if (response.statusCode == 200) {
        state = state.copyWith(delStatus: Loader.loaded);
        return ApiResponse(successMessage: body['message']);
      } else {
        state = state.copyWith(delStatus: Loader.error, error: body["error"]);
        return ApiResponse(
            errorMessage: body['error'], statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      state = state.copyWith(delStatus: Loader.error, error: e.message);
      return AppException.handleError(e);
    } catch (e) {
      state = state.copyWith(
          delStatus: Loader.error, error: 'An unexpected error occurred');
      return ApiResponse(errorMessage: 'An error occurred');
    }
  }
}

class MedicationState {
  List<MedicationModel>? medicationModels;
  Loader? status;
  Loader? delStatus;
  Loader? updateStatus;
  Loader? postStatus;

  MedicationState({
    this.medicationModels,
    this.status = Loader.loading,
    this.delStatus = Loader.loaded,
    this.updateStatus = Loader.loaded,
    this.postStatus = Loader.loaded,
  });
  factory MedicationState.initial() {
    return MedicationState();
  }

  MedicationState copyWith(
      {List<MedicationModel>? medicationModels,
      Loader? status,
      Loader? delStatus,
      Loader? updateStatus,
      Loader? postStatus,
      String? error}) {
    return MedicationState(
        medicationModels: medicationModels ?? this.medicationModels,
        status: status ?? this.status,
        delStatus: delStatus ?? this.delStatus,
        updateStatus: updateStatus ?? this.updateStatus,
        postStatus: postStatus ?? this.postStatus);
  }
}

class MedicationModel {
  final int? id;
  final String time;
  final String metric;
  final String name;
  final int dosage;
  final int quantity;
  MedicationModel({
    required this.id,
    required this.time,
    required this.metric,
    required this.name,
    required this.dosage,
    required this.quantity,
  });

  factory MedicationModel.fromMap(Map<String, dynamic> data) {
    return MedicationModel(
      id: data['id'] ?? 0,
      time: data['time'] ?? '',
      metric: data['metric'] ?? '',
      name: data['name'] ?? '',
      dosage: data['dosage'] ?? 0,
      quantity: data['quantity'] ?? 0,
    );
  }
}
