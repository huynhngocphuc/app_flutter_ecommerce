import '../constants/constantsText.dart';

class ValidateService{
  String isEmptyField(String value) {
    if (value.isEmpty) {
      return  TV_REQUIRED_TEXT;
    }
    return null;
  }

  String validatePhoneNumber(String value){
    String isEmpty = isEmptyField(value);
    int len = value.length;

    if(isEmpty != null){
      return isEmpty;
    }
    else if(len != 10){
      return TV_PHONE_VALIDATE_TEXT;
    }
    return null;
  }

  String validateEmail(String value){
    String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern);
    String isEmpty = isEmptyField(value);

    if(isEmpty != null){
      return isEmpty;
    }
    else if(!regExp.hasMatch(value)){
      return TV_EMAIL_VALIDATE_TEXT;
    }
    return null;
  }

  String validatePassword(String value){
    String isEmpty = isEmptyField(value);
    String pattern = r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$';
    RegExp regExp = new RegExp(pattern);

    if(isEmpty != null){
      return isEmpty;
    }
    else if(!regExp.hasMatch(value)){
      return TV_PASS_VALIDATE_TEXT;
    }
    return null;
  }
}