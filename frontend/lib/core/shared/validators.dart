class Validators {
  static bool validateEmail(String value) {
    if (value.isEmpty) return false;
    const Pattern pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    var regex = RegExp(pattern.toString());
    return regex.hasMatch(value) ? true : false;
  }

  static bool validateName(String value) {
    if (value.isEmpty) return false;
    Pattern pattern = r"[a-zA-Z][a-zA-Z0-9-_]{3,11}";
    var regExp = RegExp(pattern.toString());
    return regExp.hasMatch(value) ? true : false;
  }

  static bool isAlphanumeric(String password) {
    if (!RegExp(r'[A-Za-z]').hasMatch(password) ||
        !RegExp(r'[0-9]').hasMatch(password)) {
      return false;
    }
    return true;
  }
}
