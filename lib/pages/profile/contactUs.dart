import 'package:flutter/material.dart';

import 'package:app_frontend/components/profileAppBar.dart';

import '../../constants/constantsText.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool showCartIcon = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      key: _scaffoldKey,
      appBar: ProfileAppBar(PT_CONTACT_US_DETAILS_TEXT, context),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 40.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                CT_CONTACT_TEXT,
                style: TextStyle(
                    fontSize: 15.0,
                    letterSpacing: 1.0
                ),
              ),
            ),
            SizedBox(height: 10.0),
            Material(
              color: Colors.white,
              child: ListTile(
                title: Text(
                  CT_OUR_ADDRESS_TEXT ,
                  style: TextStyle(
                    fontSize:20.0,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Text(
                  CT_ADDRESS_DETAIL_TEXT,
                  style: TextStyle(
                    fontSize:16.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.white,
              child: ListTile(
                leading: Text(
                  'E-mail',
                  style: TextStyle(
                    fontSize:20.0,
                    letterSpacing: 1.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                trailing: Text(
                  CT_EMAIL_TEXT,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.grey
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0, left: 10.0),
              child: Text(
                  CT_TIME_WORKING_TEXT
              ),
            ),
            SizedBox(height: 20.0),
            Material(
              color: Colors.white,
              child: ListTile(
                title: Center(
                  child: Text(
                    'Liên hệ: 0945470158',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.blue
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
