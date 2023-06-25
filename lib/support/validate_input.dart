import 'package:trelloboard/Support/string.dart';

class ValidateInput {
  static String? validateCardName(String? value) {
    if (value!.trim().isEmpty) {
      return MyString.vCardName;
    } else {
      return null;
    }
  }
}
