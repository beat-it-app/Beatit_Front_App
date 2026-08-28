import 'package:beatit_front_app/src/domain/auth/api/auth_api.dart';
import 'package:beatit_front_app/src/domain/auth/provider/auth_api_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final findIdentifierProvider =
    NotifierProvider.autoDispose<FindIdentifierNotifier, FindIdentifierState>(
      FindIdentifierNotifier.new,
    );

class FindIdentifierState {
  const FindIdentifierState({
    this.isSendingCode = false,
    this.isVerifyingCode = false,
    this.isCodeSent = false,
    this.identifier,
    this.emailError,
    this.codeError,
  });

  final bool isSendingCode;
  final bool isVerifyingCode;
  final bool isCodeSent;

  final String? identifier;

  final String? emailError;
  final String? codeError;

  bool get isVerified => identifier?.isNotEmpty == true;
  bool get isLoading => isSendingCode || isVerifyingCode;

  FindIdentifierState copyWith({
    bool? isSendingCode,
    bool? isVerifyingCode,
    bool? isCodeSent,
    String? identifier,
    String? emailError,
    String? codeError,
    bool clearIdentifier = false,
    bool clearEmailError = false,
    bool clearCodeError = false,
  }) {
    return FindIdentifierState(
      isSendingCode: isSendingCode ?? this.isSendingCode,
      isVerifyingCode: isVerifyingCode ?? this.isVerifyingCode,
      isCodeSent: isCodeSent ?? this.isCodeSent,
      identifier: clearIdentifier ? null : identifier ?? this.identifier,
      emailError: clearEmailError ? null : emailError ?? this.emailError,
      codeError: clearCodeError ? null : codeError ?? this.codeError,
    );
  }
}

class FindIdentifierNotifier extends Notifier<FindIdentifierState> {
  @override
  FindIdentifierState build() {
    return const FindIdentifierState();
  }

  Future<bool> sendCode({required String email}) async {
    state = state.copyWith(
      isSendingCode: true,
      isCodeSent: false,
      clearIdentifier: true,
      clearEmailError: true,
      clearCodeError: true,
    );

    try {
      final authApi = ref.read(authApiProvider);

      await authApi.sendFindIdentifierCode(email: email);

      state = state.copyWith(isSendingCode: false, isCodeSent: true);

      return true;
    } catch (error) {
      state = state.copyWith(
        isSendingCode: false,
        emailError: error.toString(),
      );

      return false;
    }
  }

  Future<bool> verifyCode({required String email, required String code}) async {
    if (!state.isCodeSent) {
      return false;
    }

    state = state.copyWith(
      isVerifyingCode: true,
      clearIdentifier: true,
      clearCodeError: true,
    );

    try {
      final authApi = ref.read(authApiProvider);

      final result = await authApi.verifyFindIdentifierCode(
        email: email,
        code: code,
      );

      state = state.copyWith(
        isVerifyingCode: false,
        identifier: result.identifier,
      );

      return true;
    } catch (error) {
      state = state.copyWith(
        isVerifyingCode: false,
        codeError: _getErrorMessage(error),
      );

      return false;
    }
  }

  void onEmailChanged() {
    if (!state.isCodeSent &&
        state.emailError == null &&
        state.codeError == null &&
        state.identifier == null) {
      return;
    }

    state = const FindIdentifierState();
  }

  void onCodeChanged() {
    if (state.codeError == null) {
      return;
    }

    state = state.copyWith(clearCodeError: true);
  }

  void reset() {
    state = const FindIdentifierState();
  }

  String _getErrorMessage(Object error) {
    if (error is AuthApiException) {
      return error.message;
    }

    return '요청 처리 중 오류가 발생했습니다.';
  }
}
