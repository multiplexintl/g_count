class Validator {
  static bool validatePrice(String value) {
    return RegExp(r'^[0-9]+$').hasMatch(value);
  }

  static bool validateBarcode(String value) {
    return RegExp(r'^[0-9]{13}$').hasMatch(value);
  }
}
