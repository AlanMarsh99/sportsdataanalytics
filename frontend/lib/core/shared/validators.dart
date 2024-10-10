class Validators {
  static bool validateEmail(String value) {
    if (value.isEmpty) return false;
    final Pattern pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    var regex = RegExp(pattern.toString());
    return regex.hasMatch(value) ? true : false;
  }

  static bool validateName(String value) {
    if (value.isEmpty) return false;
    Pattern pattern = r"[a-zA-Z][a-zA-Z0-9-_]{3,32}";
    var regExp = RegExp(pattern.toString());
    return regExp.hasMatch(value) ? true : false;
  }

  static bool validPassword(String value) {
    if (value.isEmpty) return false;
    // Any alphanumerical, any special chars, min 6 chars
    Pattern pattern = r"^(?=.*[a-zA-Z0-9\W-]).{6,}$";
    var regex = RegExp(pattern.toString());
    return regex.hasMatch(value) ? true : false;
  }
}
