import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:beatit_front_app/src/domain/auth/api/auth_api.dart';
import 'package:beatit_front_app/src/domain/auth/model/account/reset_password_request.dart';
import 'package:beatit_front_app/src/domain/auth/provider/auth_api_provider.dart';

final resetPasswordProvider =
    NotifierProvider.autoDispose<ResetPasswordNotifier, ResetPasswordState>(
      ResetPasswordNotifier.new,
    );

class ResetPasswordState {
  const ResetPasswordState({
    this.isSendingCode = false,
    this.isVerifyingCode = false,
    this.isResettingPassword = false,
    this.isCodeSent = false,
    this.identityError,
    this.codeError,
    this.resetError,
  });

  final bool isSendingCode;
  final bool isVerifyingCode;
  final bool isResettingPassword;

  final bool isCodeSent;

  final String? identityError;
  final String? codeError;
  final String? resetError;

  bool get isLoading => isSendingCode || isVerifyingCode || isResettingPassword;

  ResetPasswordState copyWith({
    bool? isSendingCode,
    bool? isVerifyingCode,
    bool? isResettingPassword,
    bool? isCodeSent,
    String? identityError,
    String? codeError,
    String? resetError,
    bool clearIdentityError = false,
    bool clearCodeError = false,
    bool clearResetError = false,
  }) {
    return ResetPasswordState(
      isSendingCode: isSendingCode ?? this.isSendingCode,
      isVerifyingCode: isVerifyingCode ?? this.isVerifyingCode,
      isResettingPassword: isResettingPassword ?? this.isResettingPassword,
      isCodeSent: isCodeSent ?? this.isCodeSent,
      identityError: clearIdentityError
          ? null
          : identityError ?? this.identityError,
      codeError: clearCodeError ? null : codeError ?? this.codeError,
      resetError: clearResetError ? null : resetError ?? this.resetError,
    );
  }
}

class ResetPasswordNotifier extends Notifier<ResetPasswordState> {
  @override
  ResetPasswordState build() {
    return const ResetPasswordState();
  }

  Future<bool> sendCode({
    required String email,
    required String identifier,
  }) async {
    state = state.copyWith(
      isSendingCode: true,
      isCodeSent: false,
      clearIdentityError: true,
      clearCodeError: true,
      clearResetError: true,
    );

    try {
      final authApi = ref.read(authApiProvider);

      await authApi.sendResetPasswordCode(email: email, identifier: identifier);

      state = state.copyWith(isSendingCode: false, isCodeSent: true);

      return true;
    } catch (error) {
      state = state.copyWith(
        isSendingCode: false,
        isCodeSent: false,
        identityError: _getErrorMessage(error),
      );

      return false;
    }
  }

  Future<bool> verifyCode({required String email, required String code}) async {
    if (!state.isCodeSent) {
      return false;
    }

    state = state.copyWith(isVerifyingCode: true, clearCodeError: true);

    try {
      final authApi = ref.read(authApiProvider);

      await authApi.verifyResetPasswordCode(email: email, code: code);

      state = state.copyWith(isVerifyingCode: false);

      return true;
    } catch (error) {
      state = state.copyWith(
        isVerifyingCode: false,
        codeError: _getErrorMessage(error),
      );

      return false;
    }
  }

  Future<bool> resetPassword({
    required String identifier,
    required String email,
    required String newPassword,
  }) async {
    state = state.copyWith(isResettingPassword: true, clearResetError: true);

    try {
      final authApi = ref.read(authApiProvider);

      await authApi.resetPassword(
        ResetPasswordRequest(
          identifier: identifier,
          email: email,
          newPassword: newPassword,
        ),
      );

      state = state.copyWith(isResettingPassword: false);

      return true;
    } catch (error) {
      state = state.copyWith(
        isResettingPassword: false,
        resetError: _getErrorMessage(error),
      );

      return false;
    }
  }

  void onIdentityChanged() {
    if (!state.isCodeSent &&
        state.identityError == null &&
        state.codeError == null) {
      return;
    }

    state = const ResetPasswordState();
  }

  void onCodeChanged() {
    if (state.codeError == null) {
      return;
    }

    state = state.copyWith(clearCodeError: true);
  }

  void reset() {
    state = const ResetPasswordState();
  }

  String _getErrorMessage(Object error) {
    if (error is AuthApiException) {
      return error.message;
    }

    return '요청 처리 중 오류가 발생했습니다.';
  }
}
