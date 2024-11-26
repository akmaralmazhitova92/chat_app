class ValidationUtils {
  static String? textValidation(String? value) {
    if (value == null || value.isEmpty) {
      return 'Teksheruuchu paroldu sozsuz jazuu kerek!';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Emaildi sozsuz jazuu kerek!';
    }

    bool emailTuura = isEmail(value);

    if (!emailTuura) {
      return 'Emaildi tuura jaz!';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Paroldu sozsuz jazuu kerek!';
    }

    return null;
  }

  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Teksheruuchu paroldu sozsuz jazuu kerek!';
    }

    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  static bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(p);

    return regExp.hasMatch(em);
  }
}