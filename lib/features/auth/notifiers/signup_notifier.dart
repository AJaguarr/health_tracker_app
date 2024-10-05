import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:itoju_mobile/core/helpers/response_helper/api_response.dart';
import 'package:itoju_mobile/features/widgets/constants.dart';
import 'package:itoju_mobile/services/app_exception.dart';
import 'package:itoju_mobile/services/dio_provider.dart';

final registerProvider =
    StateNotifierProvider<RegisterNotifier, RegisterState>((ref) {
  return RegisterNotifier(ref, ref.read(dioProvider));
});

class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier(this.ref, this.dio) : super(RegisterState.initial());

  Ref ref;
  Dio dio;

  Future<ApiResponse> register(
    String fname,
    String lname,
    String email,
    DateTime dob,
    String password,
  ) async {
    state = state.copyWith(loadStatus: Loader.loading);
    final Response response;
    try {
      print(dob.toIso8601String()); //"2004-02-14T08:00:00Z"
      response = await dio.post('register', data: {
        "first_name": fname,
        "last_name": lname,
        "dob": "${dob.toIso8601String()}Z",
        "email": email,
        "password": password
      });

      var body = response.data;
      print(response.statusCode);
      if (response.statusCode == 201) {
        state = state.copyWith(loadStatus: Loader.loaded);
        return ApiResponse(
            successMessage: body['message'],
            data: '${body['user']['first_name']}'
                ' ${body['user']['last_name']}');
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

  Future<ApiResponse> registerUpWithGoogle(
    String fname,
    String lname,
    DateTime dob,
  ) async {
    final bool ok;
    final String? email;
    (ok, email) = await ref.read(oAuthProvider).signInWithGoogle();
    if (!ok || email == null || email.isEmpty) {
      return ApiResponse(errorMessage: 'Couldn\'t sign up user with Google');
    }
    final password = 'OAuthedUser-${email.split('@').first}';
    print(password);
    return await register(fname, lname, email, dob, password);
  }

  Future<ApiResponse> registerUpWithFB(
    String fname,
    String lname,
    DateTime dob,
  ) async {
    final bool ok;
    final String? email;
    (ok, email) = await ref.read(oAuthProvider).signInWithFacebook();
    if (!ok || email == null || email.isEmpty) {
      return ApiResponse(errorMessage: 'Couldn\'t sign up user with FaceBook');
    }
    final password = 'OAuthedUser-${email.split('@').first}';
    print(password);
    return await register(fname, lname, email, dob, password);
  }

  Future<ApiResponse> registerUpWithApple(
    String fname,
    String lname,
    DateTime dob,
  ) async {
    final bool ok;
    final String? email;
    (ok, email) = await ref.read(oAuthProvider).signInWithGoogle();
    if (!ok || email == null || email.isEmpty) {
      return ApiResponse(errorMessage: 'Couldn\'t sign up user with Google');
    }
    final password = 'OAuthedUser-${email.split('@').first}';
    print(password);
    return await register(fname, lname, email, dob, password);
  }
}

class RegisterState {
  RegisterState({
    this.loadStatus,
  });

  Loader? loadStatus;

  factory RegisterState.initial() {
    return RegisterState();
  }

  RegisterState copyWith({
    Loader? loadStatus,
  }) {
    return RegisterState(
      loadStatus: loadStatus ?? this.loadStatus,
    );
  }
}

final oAuthProvider = Provider<OAuthService>((ref) {
  return OAuthService();
});

class OAuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  Future<(bool, String?)> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication?.idToken,
          accessToken: googleSignInAuthentication?.accessToken);

      UserCredential result =
          await firebaseAuth.signInWithCredential(credential);

      User? userDetails = result.user;

      return (true, userDetails!.email);
    } catch (e) {
      print(e.toString());
      return (false, null);
    }
  }

  Future<(bool, String?)> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      UserCredential result =
          await firebaseAuth.signInWithCredential(facebookAuthCredential);
      User? userDetails = result.user;

      return (true, userDetails!.email);
    } catch (e) {
      print(e.toString());
      return (false, null);
    }
  }

  Future<(bool, String?)> signInWithApple() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      UserCredential result =
          await firebaseAuth.signInWithCredential(facebookAuthCredential);
      User? userDetails = result.user;

      return (true, userDetails!.email);
    } catch (e) {
      print(e.toString());
      return (false, null);
    }
  }
}
