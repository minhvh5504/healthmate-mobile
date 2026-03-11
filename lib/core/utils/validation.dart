class Validation {
  static bool isPhoneOrEmailValid(String input) {
    if (input.contains('@')) {
      return isValidEmail(input);
    } else {
      return isPhoneValid(input);
    }
  }

  static bool isPhoneValid(String phone) {
    final RegExp phoneRegex = RegExp(r'^(?:\+84|0)(?:3|5|7|8|9)[0-9]{8}$');
    return phoneRegex.hasMatch(phone);
  }

  static bool isValidEmail(String email) {
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(email);
  }

  static bool isStrongPassword(String password) {
    final RegExp passwordRegExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*[!@#$%^&*]).{8,}$',
    );
    return passwordRegExp.hasMatch(password);
  }

  static bool isCodeActive(String code) {
    final RegExp codeRegExp = RegExp(r'^\d{6}$');
    return codeRegExp.hasMatch(code);
  }

  static bool isValidUsername(String username) {
    final trimmed = username.trim();

    if (trimmed.isEmpty) return false;

    if (username != trimmed) return false;

    if (RegExp(r'\s{2,}').hasMatch(username)) return false;
    final RegExp vietnameseNameRegex = RegExp(r'^[a-zA-ZÀ-Ỹà-ỹ\s]+$');

    return vietnameseNameRegex.hasMatch(username);
  }
}
