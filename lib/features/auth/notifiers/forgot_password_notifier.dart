import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itoju_mobile/core/helpers/response_helper/api_response.dart';
import 'package:itoju_mobile/features/widgets/constants.dart';
import 'package:itoju_mobile/services/app_exception.dart';
import 'package:itoju_mobile/services/dio_provider.dart';

final forgotPasswordNotifier =
    StateNotifierProvider<ForgotPasswordNotifier, ForgotPassword>((ref) {
  return ForgotPasswordNotifier(ref, ref.read(dioProvider));
});

class ForgotPasswordNotifier extends StateNotifier<ForgotPassword> {
  ForgotPasswordNotifier(this.ref, this.dio) : super(ForgotPassword.initial());

  Ref ref;
  Dio dio;

  Future<ApiResponse> forgotPassword(
    String email,
  ) async {
    state = state.copyWith(loadStatus: Loader.loading);
    final Response response;
    try {
      response = await dio.post('password-reset', data: {
        "email": email,
      });

      var body = response.data;
      if (response.statusCode == 200) {
        state = state.copyWith(loadStatus: Loader.loaded, token: body["token"]);
        return ApiResponse(
          successMessage: body["message"],
        );
      } else {
        state = state.copyWith(loadStatus: Loader.error);
        return ApiResponse(
          errorMessage: body["error"],
        );
      }
    } on DioException catch (e) {
      state = state.copyWith(loadStatus: Loader.error);
      return AppException.handleError(e);
    } catch (e) {
      state = state.copyWith(loadStatus: Loader.error);
      return ApiResponse(errorMessage: 'An unexpected error occurred');
    }
  }

  Future<ApiResponse> resetPassword(String password) async {
    state = state.copyWith(loadStatus: Loader.loading);
    final Response response;
    try {
      response = await dio.put('users/password',
          data: {"password": password, "token": state.token});

      var body = response.data;
      if (response.statusCode == 200) {
        state = state.copyWith(loadStatus: Loader.loaded);
        return ApiResponse(
          successMessage: body["message"],
        );
      } else {
        state = state.copyWith(loadStatus: Loader.error);
        return ApiResponse(
          errorMessage: body["error"],
        );
      }
    } on DioException catch (e) {
      state = state.copyWith(loadStatus: Loader.error);
      return AppException.handleError(e);
    } catch (e) {
      state = state.copyWith(loadStatus: Loader.error);
      return ApiResponse(errorMessage: 'An unexpected error occurred');
    }
  }

  ApiResponse verifyOtp(
    String otp,
  ) {
    if (otp == state.token) {
      return ApiResponse(
        successMessage: "Succeessfully verified OTP",
      );
    }
    return ApiResponse(
      errorMessage: 'OTP isn\'t correct',
    );
  }
}

class ForgotPassword {
  ForgotPassword({this.loadStatus, this.token});

  Loader? loadStatus;
  String? token;

  factory ForgotPassword.initial() {
    return ForgotPassword();
  }

  ForgotPassword copyWith({
    Loader? loadStatus,
    String? token,
  }) {
    return ForgotPassword(
        loadStatus: loadStatus ?? this.loadStatus, token: token ?? this.token);
  }
}
