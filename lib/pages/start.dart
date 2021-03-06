import 'package:app_frontend/components/modals/internetConnection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:app_frontend/services/userService.dart';
import 'package:app_frontend/sizeConfig.dart';
import 'package:app_frontend/constants/constantsText.dart';

class Start extends StatelessWidget{
  final UserService _userService = new UserService();

  validateToken(context) async{
    bool connectionStatus = await _userService.checkInternetConnectivity();

    if(connectionStatus) {
      await Firebase.initializeApp();
      final storage = new FlutterSecureStorage();
      String value = await storage.read(key: 'idToken');
      if (value != null) {
        String decodedToken = _userService.validateToken(value);
        if (decodedToken != null) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
        else {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      }
      else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
    else{
      internetConnectionDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: SizeConfig.safeBlockVertical * 8),
                Image.asset('assets/logo.png', height: SizeConfig.safeBlockVertical * 30),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                        TS_WELLCOM_TEXT,
                        style: TextStyle(
                          fontSize: SizeConfig.safeBlockHorizontal * 8,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'NovaSquare',
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.safeBlockVertical * 3,
                    horizontal: SizeConfig.safeBlockHorizontal * 12.5,
                  ),
                  child: Text(
                    TS_WELLCOM_CONTENT_TEXT,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'NovaSquare',
                      fontSize: SizeConfig.safeBlockHorizontal * 4.6,
                      letterSpacing: 1.0
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 5),
                  child: ButtonTheme(
                    minWidth: SizeConfig.screenWidth - 180,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)
                      ),
                      padding: EdgeInsets.symmetric(vertical: SizeConfig.safeBlockVertical * 3),
                      color: Colors.black,
                      textColor: Colors.white,
                      child: Text(
                        TS_LOGIN_TEXT,
                        style: TextStyle(
                          fontFamily: 'NovaSquare',
                          fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      onPressed: () {
                        validateToken(context);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 3.0),
                  child: ButtonTheme(
                    minWidth: SizeConfig.screenWidth - 180,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                        side: BorderSide(color: Colors.black,width: 2.6)
                      ),
                      padding: EdgeInsets.symmetric(vertical: SizeConfig.safeBlockVertical * 3),
                      color: Colors.white,
                      textColor: Colors.black,
                      child: Text(
                        TS_SIGNUP_TEXT,
                        style: TextStyle(
                          fontFamily: 'NovaSquare',
                          fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                    ),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}
