import 'package:flutter/material.dart';

import 'package:app_frontend/components/checkout/checkoutAppBar.dart';

class ShippingMethod extends StatefulWidget {
  @override
  _ShippingMethodState createState() => _ShippingMethodState();
}

class _ShippingMethodState extends State<ShippingMethod> {

  String selectedShippingMethod = 'COD';

  checkoutShippingMethod(){
    Map<String,dynamic> args = ModalRoute.of(context).settings.arguments;
    args['shippingMethod'] = selectedShippingMethod;
    Navigator.of(context).pushNamed('/checkout/placeOrder', arguments: args);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CheckoutAppBar('Quay lại', 'Xong', checkoutShippingMethod),
      body: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Shipping',
                style: TextStyle(
                  fontFamily: 'NovaSquare',
                  fontSize: 40.0,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 60.0, bottom: 30.0),
                child: Center(
                  child: Image.asset(
                    'assets/cartonBox.png',
                    width: 250.0,
                    height: 250.0,
                  ),
                ),
              ),
              Text(
                'Phương thức thanh toán',
                style: TextStyle(
                  fontSize: 20.0,
                  letterSpacing: 1.0,
                  fontWeight: FontWeight.bold
                )
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                leading: Icon(Icons.local_shipping),
                title: Text(
                  'Thanh toán khi nhận hàng',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 3.0),
                    Text(
                      'Giao trong 3-5 Ngày',
                      style: TextStyle(
                        fontSize: 16.0
                      ),
                    ),
                    // Text(
                    //   'free',
                    //   style: TextStyle(
                    //     fontSize: 16.0
                    //   ),
                    // )
                  ],
                ),
                trailing: Radio(
                  value: 'COD',
                  groupValue: selectedShippingMethod,
                  onChanged: (value) {
                    setState(() {
                      selectedShippingMethod = 'COD';
                    });
                  },
                )
              ),
              ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                leading: Icon(Icons.local_shipping),
                title: Text(
                  'Thanh toán thẻ',
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Giao trong 3-5 ngày',
                      style: TextStyle(
                          fontSize: 16.0
                      ),
                    ),
                    // Text(
                    //   '\$5.00',
                    //   style: TextStyle(
                    //       fontSize: 16.0
                    //   ),
                    // ),
                  ],
                ),
                  trailing: Radio(
                    value: 'VISA',
                    groupValue: selectedShippingMethod,
                    onChanged: (value) {
                      setState(() {
                        selectedShippingMethod = 'VISA';
                      });
                    },
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
