import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/domain/auth/api/auth_api.dart';
import 'package:beatit_front_app/src/domain/auth/model/signup/signup_request.dart';
import 'package:beatit_front_app/src/domain/auth/provider/auth_api_provider.dart';

final signupProvider =
    NotifierProvider.autoDispose<SignupNotifier, SignupState>(
      SignupNotifier.new,
    );

class SignupState {
  const SignupState({
    this.isCheckingIdentifier = false,
    this.isIdentifierChecked = false,
    this.isSendingCode = false,
    this.isCodeSent = false,
    this.isVerifyingCode = false,
    this.isVerified = false,
    this.isSubmitting = false,
    this.identifierError,
    this.emailError,
    this.codeError,
    this.signupError,
  });

  final bool isCheckingIdentifier;
  final bool isIdentifierChecked;

  final bool isSendingCode;
  final bool isCodeSent;

  final bool isVerifyingCode;
  final bool isVerified;

  final bool isSubmitting;

  final String? identifierError;
  final String? emailError;
  final String? codeError;
  final String? signupError;

  bool get isLoading =>
      isCheckingIdentifier || isSendingCode || isVerifyingCode || isSubmitting;

  SignupState copyWith({
    bool? isCheckingIdentifier,
    bool? isIdentifierChecked,
    bool? isSendingCode,
    bool? isCodeSent,
    bool? isVerifyingCode,
    bool? isVerified,
    bool? isSubmitting,
    String? identifierError,
    String? emailError,
    String? codeError,
    String? signupError,
    bool clearIdentifierError = false,
    bool clearEmailError = false,
    bool clearCodeError = false,
    bool clearSignupError = false,
  }) {
    return SignupState(
      isCheckingIdentifier: isCheckingIdentifier ?? this.isCheckingIdentifier,
      isIdentifierChecked: isIdentifierChecked ?? this.isIdentifierChecked,
      isSendingCode: isSendingCode ?? this.isSendingCode,
      isCodeSent: isCodeSent ?? this.isCodeSent,
      isVerifyingCode: isVerifyingCode ?? this.isVerifyingCode,
      isVerified: isVerified ?? this.isVerified,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      identifierError: clearIdentifierError
          ? null
          : identifierError ?? this.identifierError,
      emailError: clearEmailError ? null : emailError ?? this.emailError,
      codeError: clearCodeError ? null : codeError ?? this.codeError,
      signupError: clearSignupError ? null : signupError ?? this.signupError,
    );
  }
}

class SignupNotifier extends Notifier<SignupState> {
  @override
  SignupState build() {
    return const SignupState();
  }

  Future<bool> checkIdentifier({required String identifier}) async {
    state = state.copyWith(
      isCheckingIdentifier: true,
      isIdentifierChecked: false,
      clearIdentifierError: true,
      clearSignupError: true,
    );

    try {
      final authApi = ref.read(authApiProvider);

      await authApi.checkIdentifier(identifier: identifier);

      state = state.copyWith(
        isCheckingIdentifier: false,
        isIdentifierChecked: true,
      );

      return true;
    } catch (error) {
      state = state.copyWith(
        isCheckingIdentifier: false,
        isIdentifierChecked: false,
        identifierError: _getErrorMessage(error),
      );

      return false;
    }
  }

  Future<bool> sendEmailCode({required String email}) async {
    state = state.copyWith(
      isSendingCode: true,
      isCodeSent: false,
      isVerified: false,
      clearEmailError: true,
      clearCodeError: true,
      clearSignupError: true,
    );

    try {
      final authApi = ref.read(authApiProvider);

      await authApi.sendEmailCode(email: email);

      state = state.copyWith(isSendingCode: false, isCodeSent: true);

      return true;
    } catch (error) {
      state = state.copyWith(
        isSendingCode: false,
        isCodeSent: false,
        emailError: _getErrorMessage(error),
      );

      return false;
    }
  }

  Future<bool> verifyEmailCode({
    required String email,
    required String code,
  }) async {
    if (!state.isCodeSent) {
      return false;
    }

    state = state.copyWith(
      isVerifyingCode: true,
      isVerified: false,
      clearCodeError: true,
    );

    try {
      final authApi = ref.read(authApiProvider);

      await authApi.verifyEmailCode(email: email, code: code);

      state = state.copyWith(isVerifyingCode: false, isVerified: true);

      return true;
    } catch (error) {
      state = state.copyWith(
        isVerifyingCode: false,
        isVerified: false,
        codeError: _getErrorMessage(error),
      );

      return false;
    }
  }

  Future<bool> signup({
    required String identifier,
    required String password,
    required String email,
  }) async {
    if (!state.isIdentifierChecked || !state.isVerified) {
      return false;
    }

    state = state.copyWith(isSubmitting: true, clearSignupError: true);

    try {
      final authApi = ref.read(authApiProvider);

      final request = SignupRequest(
        identifier: identifier,
        password: password,
        email: email,
      );

      await authApi.signup(request);

      state = state.copyWith(isSubmitting: false);

      return true;
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        signupError: _getErrorMessage(error),
      );

      return false;
    }
  }

  void onIdentifierChanged() {
    state = state.copyWith(
      isIdentifierChecked: false,
      clearIdentifierError: true,
      clearSignupError: true,
    );
  }

  void onEmailChanged() {
    state = state.copyWith(
      isCodeSent: false,
      isVerified: false,
      clearEmailError: true,
      clearCodeError: true,
      clearSignupError: true,
    );
  }

  void onCodeChanged() {
    state = state.copyWith(isVerified: false, clearCodeError: true);
  }

  void reset() {
    state = const SignupState();
  }

  String _getErrorMessage(Object error) {
    if (error is AuthApiException) {
      return error.message;
    }

    return '요청 처리 중 오류가 발생했습니다.';
  }
}
