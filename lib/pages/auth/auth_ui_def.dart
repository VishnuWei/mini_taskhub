import 'package:flutter/material.dart';
import 'package:mini_taskhub/utils/images.dart';

import '../../utils/widgets/widget_factory.dart';

class AuthUiDef {
  static Map<String, dynamic> splash = {
    "type": "splash",
    "logoImage": Images.appLogo,
    "splashImage": Images.splashImage,
    "richTitle": [
      {"text": "Day", "isPrimary": false},
      {"text": "Task", "isPrimary": true},
    ],
    "richContent": [
      {"text": "Manage \n", "isPrimary": false},
      {"text": "your \n", "isPrimary": false},
      {"text": "Task with \n", "isPrimary": false},
      {"text": "DayTask", "isPrimary": true},
    ],
    "fields": [],
    "buttonText": "Let's Start",
    "google": false,
  };

  static final login = {
    "type": "login",
    "logoImage": Images.appLogo,
    "logoTitle": [
      {"text": "Day", "isPrimary": false},
      {"text": "Task", "isPrimary": true},
    ],
    "title": "Welcome Back!",
    "fields": [email, password],
    "buttonText": "Log In",
    "google": true,
  };

  static final privacyPolicyField = {
    'fieldName': "privacyPolicy",
    "checkBoxText": "I have read & agreed to DayTask ",
    "termsAndConditionText": [
      {"text": "Privacy Policy, ", 'url': '', "isPrimary": true},
      {"text": "Terms & Conditions.", 'url': '', "isPrimary": true},
    ],
    "termsAndConditionUrl": "",
    "widgetType": WidgetType.customPrivacyPolicyWidget,
  };

  static final signup = {
    "type": "signup",
    "logoImage": Images.appLogo,
    "logoTitle": [
      {"text": "Day", "isPrimary": false},
      {"text": "Task", "isPrimary": true},
    ],
    "title": "Create your account",
    "fields": [fullName, email, password],
    "buttonText": "Sign Up",
    "google": true,
  };

  static final screens = [splash, login, signup];

  static Map<String, dynamic> get email => {
    "fieldName": "email",
    "labelText": "Email Address",
    "hintText": "fazzzil72@gmail.com",
    "prefixIcon": Icons.alternate_email_rounded,
    "textInputType": TextInputType.emailAddress,
    "widgetType": WidgetType.textBox,
  };

  static Map<String, dynamic> get password => {
    "fieldName": "password",
    "labelText": "Password",
    "hintText": "••••••••",
    "prefixIcon": Icons.lock_outline_rounded,
    "hideText": true,
    "showToggle": true,
    "textInputType": TextInputType.visiblePassword,
    "widgetType": WidgetType.textBox,
  };

  static Map<String, dynamic> get fullName => {
    "fieldName": "name",
    "labelText": "Full Name",
    "hintText": "Fazil Laghari",
    "prefixIcon": Icons.person_outline_rounded,
    "textInputType": TextInputType.name,
    "widgetType": WidgetType.textBox,
  };
}
