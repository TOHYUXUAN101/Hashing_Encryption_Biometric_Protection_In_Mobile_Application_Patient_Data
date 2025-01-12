
import 'package:flutter/material.dart';
import 'package:hospitize/utils/constant/screenUtils.dart';

class FormValidator {
  static bool validatePasswordComplexity({
    required BuildContext context,
    required String uPass
  }) {

    final hasUpperCase = RegExp(r'[A-Z]').hasMatch(uPass);
    final hasLowerCase = RegExp(r'[a-z]').hasMatch(uPass);
    final hasNumber = RegExp(r'[0-9]').hasMatch(uPass);
    final hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(uPass);

    if (uPass.length < 8) {
      ScreenUtils.showCupertinoAlertDialog(
        context, 
        "Error",
        "Password must at least 8 characters."
      );
      return false;
    }

    if (!hasUpperCase) {
      ScreenUtils.showCupertinoAlertDialog(
        context, 
        "Error",
        "Password must contain at least one uppercase letter."
      );
      return false;
    }
    
    if (!hasLowerCase) {
      ScreenUtils.showCupertinoAlertDialog(
        context, 
        "Error",
        "Password must contain at least one lowercase letter."
      );
      return false;
    }
    if (!hasNumber) {
      ScreenUtils.showCupertinoAlertDialog(
        context, 
        "Error",
        "Password must contain at least one number."
      );
      return false;
    }
    if (!hasSpecialChar) {
      ScreenUtils.showCupertinoAlertDialog(
        context, 
        "Error",
        "Password must contain at least one special character."
      );
      return false;
    }

    return true;
  }

  static bool validateEmailField({
    required BuildContext context,
    String? emailControllerText,
  }) {

    if (emailControllerText == '') {
      ScreenUtils.showCupertinoAlertDialog(
        context,
        "Error",
        "Email field must not be empty.",
      );
      return false;
    }

    // Email format validation using a regular expression
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regex = RegExp(emailPattern);

    if (!regex.hasMatch(emailControllerText!)) {
      ScreenUtils.showCupertinoAlertDialog(
        context,
        "Error",
        "Please enter a valid email address.",
      );
      return false;
    }

    return true;
  }

  static bool validatePasswordMatching({
    required BuildContext context,
    required String uNewPass,
    required String uRepeatNewPass,
  }){

    if(uNewPass != uRepeatNewPass){
      ScreenUtils.showCupertinoAlertDialog(
        context, 
        "Password Not Matching", 
        "Please check your password"
      );
      return false;
    }

    return true;
  }
}
