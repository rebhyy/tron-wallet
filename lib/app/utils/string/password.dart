enum PasswordStrength {
  weak,
  fair,
  normal,
  strong;

  String get tr => name;
}

class PasswordUtils {
  static PasswordStrength checkPasswordStrength(String password) {
    if (password.isEmpty) return PasswordStrength.weak;

    int score = 0;

    if (password.length >= 6) score++; // minimal fair
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score == 3) return PasswordStrength.fair;
    if (score <= 5) return PasswordStrength.normal;
    return PasswordStrength.strong;
  }

  static bool canUseAsPassword(String password) {
    return checkPasswordStrength(password) != PasswordStrength.weak;
  }
}
