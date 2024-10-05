import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itoju_mobile/core/helpers/biometric_helper.dart';
import 'package:itoju_mobile/core/helpers/response_helper/api_response.dart';
import 'package:itoju_mobile/features/auth/notifiers/signup_notifier.dart';
import 'package:itoju_mobile/features/widgets/constants.dart';
import 'package:itoju_mobile/services/app_exception.dart';
import 'package:itoju_mobile/services/dio_provider.dart';
import 'package:itoju_mobile/core/Storage/storage_class.dart';

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier(this.ref, this.dio) : super(LoginState.initial(ref));

  final Ref ref;
  final Dio dio;

  Future<ApiResponse> login(String email, String password) async {
    state = state.copyWith(loadStatus: Loader.loading);
    try {
      final formData = {
        'email': email,
        'password': password,
      };
      final response = await dio.post('login', data: formData);
      var body = response.data;
      if (response.statusCode == 200) {
        await HiveStorage.delete(HiveKeys.token);
        await HiveStorage.put(HiveKeys.token, body['data']['token']);
        await HiveStorage.put(HiveKeys.userName, email);
        await HiveStorage.put(HiveKeys.password, password);
        state = state.copyWith(
          loadStatus: Loader.loaded,
        );
        return ApiResponse(successMessage: body['message']);
      } else {
        state = state.copyWith(loadStatus: Loader.error);
        return ApiResponse(
            errorMessage: body['error'], statusCode: response.statusCode);
      }
    } on DioException catch (e) {
      state = state.copyWith(loadStatus: Loader.error);

      return AppException.handleError(e);
    } catch (e) {
      state = state.copyWith(loadStatus: Loader.error);
      return ApiResponse(errorMessage: 'An error occurred');
    }
  }

  Future<ApiResponse> loginWithBioMetric(String email, String password) async {
    final isAuthenticated = await LocalAuthApi.authenticate();
    if (isAuthenticated) {
      final response = await login(email, password);
      return response;
    } else {
      return ApiResponse(errorMessage: 'Couldn\'t authenticate with Biometric');
    }
  }

  Future<ApiResponse> signInWithGoogle() async {
    final bool ok;
    final String? email;
    (ok, email) = await ref.read(oAuthProvider).signInWithGoogle();
    if (!ok || email == null || email.isEmpty) {
      return ApiResponse(errorMessage: 'Couldn\'t authenticate with Google');
    }
    final password = 'OAuthedUser-${email.split('@').first}';
    print(password);
    return await login(email, password);
  }

  Future<ApiResponse> signInWithFB() async {
    final bool ok;
    final String? email;
    (ok, email) = await ref.read(oAuthProvider).signInWithFacebook();
    if (!ok || email == null || email.isEmpty) {
      return ApiResponse(errorMessage: 'Couldn\'t authenticate with FaceBook');
    }
    final password = 'OAuthedUser-${email.split('@').first}';
    print(password);
    return await login(email, password);
  }

  Future<ApiResponse> signInWithApple() async {
    final bool ok;
    final String? email;
    (ok, email) = await ref.read(oAuthProvider).signInWithApple();
    if (!ok || email == null || email.isEmpty) {
      return ApiResponse(errorMessage: 'Couldn\'t authenticate with Apple');
    }
    final password = 'OAuthedUser-${email.split('@').first}';
    print(password);
    return await login(email, password);
  }
}

class LoginState {
  LoginState({
    this.loadStatus,
  });

  Loader? loadStatus;

  factory LoginState.initial(Ref ref) {
    return LoginState();
  }

  LoginState copyWith({
    Loader? loadStatus,
  }) {
    return LoginState(loadStatus: loadStatus ?? this.loadStatus);
  }
}

final loginNotifier = StateNotifierProvider<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(ref, ref.read(dioProvider)),
);
