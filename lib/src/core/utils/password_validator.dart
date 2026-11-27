/// 회원가입 및 비밀번호 재설정에서 사용하는 동일한 비밀번호 정책.
abstract final class PasswordValidator {
  static final RegExp _invalidCharacters = RegExp(r'[^A-Za-z0-9!@#$%^&*?_~]');
  static final RegExp _letters = RegExp(r'[A-Za-z]');
  static final RegExp _digits = RegExp(r'[0-9]');
  static final RegExp _specialCharacters = RegExp(r'[!@#$%^&*?_~]');

  static bool isValid(String password) {
    return password.isNotEmpty && errorText(password) == null;
  }

  /// 비어 있는 초기 입력란에는 오류를 노출하지 않는다.
  static String? errorText(String password) {
    if (password.isEmpty) {
      return null;
    }

    // 공백·한글·허용하지 않은 특수문자를 길이/구성 검사보다 먼저 안내한다.
    if (_invalidCharacters.hasMatch(password)) {
      return r'사용할 수 없는 문자가 포함되어 있습니다.';
    }

    if (password.length < 8 || password.length > 20) {
      return '비밀번호는 8~20자로 입력해주세요.';
    }

    if (!_letters.hasMatch(password) ||
        !_digits.hasMatch(password) ||
        !_specialCharacters.hasMatch(password)) {
      return '영문, 숫자, 특수문자를 포함한 8~20자 문자여야 합니다.';
    }

    return null;
  }
}
