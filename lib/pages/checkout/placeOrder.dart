import 'package:app_frontend/services/userService.dart';
import 'package:flutter/material.dart';
import 'package:app_frontend/components/loader.dart';
import 'package:app_frontend/components/checkout/checkoutAppBar.dart';
import 'package:app_frontend/services/checkoutService.dart';
import 'package:app_frontend/components/modals/internetConnection.dart';

class PlaceOrder extends StatefulWidget {
  @override
  _PlaceOrderState createState() => _PlaceOrderState();
}

class _PlaceOrderState extends State<PlaceOrder> {
  void thirdFunction(){}
  Map<String,dynamic> orderDetails;
  CheckoutService _checkoutService = new CheckoutService();
  UserService _userService = new UserService();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  setOrderData(){
    Map<String,dynamic> args = ModalRoute.of(context).settings.arguments;
    setState(() {
      orderDetails = args;
    });
  }

  placeNewOrder() async{
    bool connectionStatus = await _userService.checkInternetConnectivity();

    if(connectionStatus){
      Loader.showLoadingScreen(context, _keyLoader);
      await _checkoutService.placeNewOrder(orderDetails);
      Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
      Navigator.pushReplacementNamed(context, '/home');
    }
    else{
      internetConnectionDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    setOrderData();
    return Scaffold(
      appBar: CheckoutAppBar('Giỏ hàng','Đặt hàng',this.thirdFunction),
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xffF4F4F4)
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0,horizontal: 10.0),
          child: Column(
            children: <Widget>[
              Text(
                'Thông tin đơn hàng',
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0
                ),
              ),
              SizedBox(height: 30.0),
              // Card(
              //   color: Colors.white,
              //   shape: ContinuousRectangleBorder(
              //     borderRadius: BorderRadius.zero
              //   ),
              //   borderOnForeground: true,
              //   elevation: 0,
              //   child: ListTile(
              //     title: Text('Payment'),
              //     trailing: Text('Visa ${orderDetails['selectedCard']}'),
              //
              //   ),
              // ),
              Card(
                color: Colors.white,
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.zero
                ),
                borderOnForeground: true,
                elevation: 0,
                child: ListTile(
                  title: Text('Shipping'),
                  trailing: Text(orderDetails['shippingMethod']),
                ),
              ),
              Card(
                color: Colors.white,
                shape: ContinuousRectangleBorder(
                    borderRadius: BorderRadius.zero
                ),
                borderOnForeground: true,
                elevation: 0,
                child: ListTile(
                  title: Text('Tổng tiền'),
                  trailing: Text('VNĐ ${orderDetails['price']}.00'),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width/1.5,
                    height: 50.0,
                    child: FlatButton(
                      onPressed: () {
                        placeNewOrder();
                      },
                      child: const Text(
                          'Đặt hàng',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0
                          )
                      ),
                      color: Color(0xff616161),
                      textColor: Colors.white
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
