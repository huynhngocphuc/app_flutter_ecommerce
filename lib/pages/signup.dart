import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:app_frontend/components/modals/internetConnection.dart';
import 'package:app_frontend/components/alertBox.dart';
import 'package:app_frontend/services/userService.dart';
import 'package:app_frontend/services/validateService.dart';
import 'package:app_frontend/sizeConfig.dart';
import 'package:flutter/services.dart';
import 'package:material_dialogs/material_dialogs.dart';

import '../components/loader.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  double borderWidth = 1.0;
  final _signUpFormKey = GlobalKey<FormState>();
  HashMap userValues = new HashMap<String, String>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  Map customWidth = new Map<String,double>();
  double fieldPadding;

  ValidateService validateService = ValidateService();
  UserService userService = UserService();

  setBorder(double width, Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(36.0),
      borderSide: BorderSide(width: width, color: color),
    );
  }
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: Color(0xff1a1c1a),
    elevation: 16.0,

    minimumSize: Size(88, 36),
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
  );
  void showInSnackBar() {
    bool hover = false;
    Dialogs.materialDialog(
        barrierDismissible: false,
        color: Colors.white,
        title: 'Đăng ký thành công',
        animation: 'assets/congratulation.json',
        context: context,
        actions: [
          ElevatedButton(
            style: raisedButtonStyle,
            onPressed: () { Navigator.pushReplacementNamed(context, '/'); },
            child: Text('Đăng nhập',
              style: TextStyle(
                  fontFamily: 'NovaSquare',
                  fontSize: SizeConfig.safeBlockHorizontal * 5.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),),
          ),

        ]);
  }

  signUpUser() async {
    bool connectionStatus = await userService.checkInternetConnectivity();

    if (this._signUpFormKey.currentState.validate()) {
      _signUpFormKey.currentState.save();

      if(connectionStatus){
        Loader.showLoadingScreen(context, _keyLoader);
        await userService.signup(userValues);
        int statusCode = userService.statusCode;
        if (statusCode == 400) {
          AlertBox alertBox = AlertBox(userService.msg);
          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return alertBox.build(context);
              });
        } else {
          Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
          showInSnackBar();


        }
      }
      else{
       internetConnectionDialog(context);
      }
    }
  }

  InputDecoration customFormField(String text) {
    return InputDecoration(
      hintText: text,
      labelText: text,
      prefixIcon: setFormIcons(text),
      contentPadding: EdgeInsets.all(customWidth['fieldPadding']),
      errorBorder: this.setBorder(1.8, Colors.red),
      focusedErrorBorder: this.setBorder(1.2, Colors.red),
      focusedBorder: this.setBorder(2.0, Colors.blue),
      enabledBorder: this.setBorder(1.0, Colors.white),
      fillColor: Colors.white,
      filled: true,
      errorStyle: TextStyle(
        fontSize: SizeConfig.safeBlockHorizontal * 3
      )
    );
  }

  setUpFieldPadding(screen) {
    switch(screen) {
      case 'smallMobile':
        {
          customWidth['fieldPadding'] = 10.00;
          customWidth['formFieldSpacing'] = SizeConfig.safeBlockVertical * 2.4;
          customWidth['fieldTextSize'] = SizeConfig.safeBlockVertical * 2.6;
          break;
        }
      case 'largeMobile':
        {
          customWidth['fieldPadding'] = 20.00;
          customWidth['formFieldSpacing'] = SizeConfig.safeBlockVertical * 2.6;
          customWidth['fieldTextSize'] = SizeConfig.safeBlockVertical * 2.2;
          break;
        }
      case 'tablet':
        {
          customWidth['fieldPadding'] = 26.00;
          customWidth['formFieldSpacing'] = SizeConfig.safeBlockVertical * 5;
          customWidth['fieldTextSize'] = SizeConfig.safeBlockVertical * 2.4;
          break;
        }
      default:
        break;
    }
  }

  Icon setFormIcons(String label){
    Icon icon;
    switch(label){
      case 'Tên':{
        icon = Icon(Icons.person);
        break;
      }
      case 'Email':{
        icon = Icon(Icons.email);
        break;
      }
      case 'SĐT':{
        icon = Icon(Icons.call);
        break;
      }
      case 'Mật khẩu':{
        icon = Icon(Icons.lock);
        break;
      }
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    setUpFieldPadding(SizeConfig.screenSize);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context, false),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.grey[200],
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.safeBlockVertical / 2,
              horizontal: SizeConfig.safeBlockHorizontal * 10),
          child: Form(
            key: _signUpFormKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "chào mừng bạn đến với shop PT",
                  style: TextStyle(
                      fontFamily: 'NovaSquare',
                      fontSize: SizeConfig.safeBlockHorizontal * 8.0),
                ),
                Text(
                  'Hãy bắt đầu tạo tài khoản bằng cách nhập thông tin bên dưới !',
                  style: TextStyle(
                    fontFamily: 'NovaSquare',
                    fontSize: SizeConfig.safeBlockHorizontal * 3.8,
                    color: Colors.grey[800],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(top: SizeConfig.safeAreaVertical * 0.8),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: this.customFormField('Tên'),
                        validator: (value) =>
                            validateService.isEmptyField(value),
                        onSaved: (String val) {
                          userValues['fullName'] = val;
                        },
                        style: TextStyle(
                          fontSize: customWidth['fieldTextSize']
                        ),
                      ),
                      SizedBox(height: customWidth['formFieldSpacing']),
                      TextFormField(
                        decoration: this.customFormField('SĐT'),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r"^[^._]+$")),
                          LengthLimitingTextInputFormatter(10)
                        ],
                        validator: (value) =>
                            validateService.validatePhoneNumber(value),
                        onSaved: (String val) {
                          userValues['mobileNumber'] = val;
                        },
                        style: TextStyle(
                            fontSize: customWidth['fieldTextSize']
                        ),
                      ),
                      SizedBox(height: customWidth['formFieldSpacing']),
                      TextFormField(
                        decoration: this.customFormField('Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) =>
                            validateService.validateEmail(value),
                        onSaved: (String val) {
                          userValues['email'] = val;
                        },
                        style: TextStyle(
                            fontSize: customWidth['fieldTextSize']
                        ),
                      ),
                      SizedBox(height: customWidth['formFieldSpacing']),
                      TextFormField(
                        decoration: this.customFormField('Mật khẩu'),
                        obscureText: true,
                        validator: (value) =>
                            validateService.validatePassword(value),
                        onSaved: (String val) {
                          userValues['password'] = val;
                        },
                        style: TextStyle(
                            fontSize: customWidth['fieldTextSize']
                        ),
                      ),
                      SizedBox(height: customWidth['formFieldSpacing']),
                      ButtonTheme(
                        minWidth: SizeConfig.screenWidth - 200,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(36),
                              side: BorderSide(color: Colors.black)),
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          color: Colors.black87,
                          textColor: Colors.white,
                          child: Text(
                            'Đăng ký',
                            style: TextStyle(
                                fontFamily: 'NovaSquare',
                                fontSize: SizeConfig.safeBlockHorizontal * 5.2,
                                fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            this.signUpUser();
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
