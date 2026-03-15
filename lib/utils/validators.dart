class Validator {
  Pattern p;
  String message;
  String name;
  late RegExp regExp;

  Validator(this.name, this.p, this.message) {
    regExp = RegExp(p as String);
    instances[message] = this;
  }

  static Map<String, Validator> instances = {};

  Validator mobile = Validator("mobile", r'^(?:[+0][1-9])?[0-9]{10}$',
      "Please enter valid Phone Number");
  Validator email = Validator(
      "email", r'^(?:[+0][1-9])?[0-9]{10}$', "Please enter valid Email");

  static String? userNameValidator(String patternName, String? value) {
    Validator? v = instances[patternName];

    if (v!.regExp.hasMatch(value!)) {
      return null;
    }
    return v.message;
  }

  static String? validateOtp(String? value, {int length = 4}) {
    if (value == null || value.isEmpty) {
      return 'OTP is required.';
    }

    final RegExp numbersOnly = RegExp(r'^[0-9]+$');
    if (!numbersOnly.hasMatch(value)) {
      return 'OTP must contain only numbers.';
    }

    if (value.length != length) {
      return 'OTP must be $length digits.';
    }

    return null;
  }

  static String? validateDropDown({
    required String? value,
    required List<Map<String, dynamic>> optionList,
    String errorMessage = 'Please select an option',
  }) {
    if (value == null || value.isEmpty) {
      return errorMessage;
    }

    final isValid = optionList.any((option) => option['id'] == value);

    if (!isValid) {
      return errorMessage;
    }

    return null;
  }

  static String? validateName(String? value, {bool? isRequired = false}) {
    if (value!.isEmpty) {
      return isRequired != null
          ? isRequired
              ? 'Name is required.'
              : null
          : null;
    }
    final RegExp nameExp = RegExp(r'^[A-za-z ]+$');
    if (!nameExp.hasMatch(value)) {
      return 'Please enter only alphabetical characters.';
    }

    return null;
  }

  static String? validateLastName(String? value) {
    if (value!.isEmpty) return null;
    final RegExp nameExp = RegExp(r'^[A-za-z ]+$');
    if (!nameExp.hasMatch(value)) {
      return 'Please enter only alphabetical characters.';
    }

    return null;
  }

  static String? validateEmail(String? value, {bool? isRequired = false}) {
    if (value!.isEmpty) {
      return isRequired != null
          ? isRequired
              ? 'Email is required.'
              : null
          : null;
    }
    final RegExp emailExp =
        RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
    if (!emailExp.hasMatch(value)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value!.isEmpty) return 'Password is required.';
    return null;
  }

  static String? validateEmptyField(String? value) {
    if (value!.isEmpty) return 'This field is required.';
    return null;
  }

  static String? validateConfirmPassword({String? value, String? password}) {
    if (value!.isEmpty) return 'Password is required.';
    if (password == null) return 'Please enter password first!';
    if (password.isEmpty) return 'Please enter password first!';
    if (value != password) return 'Password mismatch!';
    return null;
  }

  static String? validateMobileNumber(String? value) {
    if (value!.isEmpty) return 'PhoneNumber is required.';

    final RegExp nameExp =
        RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$');

    if (!nameExp.hasMatch(value)) return 'Please enter a valid Mobile number';

    // To check if the length is exactly 10 characters
    if (value.length != 10) return 'Mobile number must be 10 digits.';

    return null;
  }

  static String? validateNumber(String? value) {
    if (value!.isEmpty) return 'Field is required.';
    final RegExp numbersExp = RegExp(r'^[0-9]+$');
    if (!numbersExp.hasMatch(value)) {
      return 'Please enter only numbers.';
    }
    return null;
  }

  static String? validateCurrency(String? value) {
    if (value!.isEmpty) return 'Field is required.';
    final RegExp currencyExp = RegExp(r'^(\$)?(\d+)(\.\d{1,2})?$');
    if (!currencyExp.hasMatch(value)) {
      return 'Please enter a valid currency amount.';
    }
    return null;
  }

  static String? validateEntry(String? value) {
    if (value!.isEmpty) return 'Field is required.';
    final RegExp lettersAndNumbersExp =
        RegExp(r'^[a-zA-Z]*[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[a-zA-Z-\s\.:/0-9]*$');
    if (!lettersAndNumbersExp.hasMatch(value)) {
      return 'Please enter the entry.';
    }
    return null;
  }

  static String? validateEntryEmptyOrNot(String? value) {
    if (value!.isEmpty) return 'Field is required.';
    return null;
  }
}
