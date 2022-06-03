import 'package:app_frontend/components/modals/internetConnection.dart';
import 'package:flutter/material.dart';

import 'package:app_frontend/components/loader.dart';
import 'package:app_frontend/services/shoppingBagService.dart';
import 'package:app_frontend/services/userService.dart';
import 'package:app_frontend/services/profileService.dart';
import 'package:app_frontend/services/productService.dart';
import 'package:app_frontend/services/checkoutService.dart';

import '../constants/constantsText.dart';
import '../sizeConfig.dart';

Widget sidebar(BuildContext context){
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  UserService _userService = new UserService();
  ShoppingBagService _shoppingBagService = new ShoppingBagService();
  ProfileService _profileService = new ProfileService();
  ProductService _productService = new ProductService();
  CheckoutService _checkoutService = new CheckoutService();

  return SafeArea(
    child: Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ListView(
            shrinkWrap: true,
            children: <Widget>[
              Image.asset('assets/logo.png', height: SizeConfig.safeBlockVertical * 20),
              ListTile(
                leading: Icon(Icons.home),
                title:Text(
                  SBT_HOME_TEXT,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0
                  ),
                ),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/home');
                },
              ),
              ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text(
                  SBT_SHOP_TEXT,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0
                  ),
                ),
                onTap: () async{
                  bool connectionStatus = await _userService.checkInternetConnectivity();

                  if(connectionStatus){
                    Map<String,dynamic> args = new Map();
                    Loader.showLoadingScreen(context, _keyLoader);
                    List<Map<String,String>> categoryList = await _productService.listCategories();
                    args['category'] = categoryList;
                    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                    Navigator.pushReplacementNamed(context, '/shop',arguments: args);
                  }
                  else{
                    internetConnectionDialog(context);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.local_mall),
                title: Text(
                  SBT_BAG_TEXT,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0
                  ),
                ),
                onTap: () async{
                  bool connectionStatus = await _userService.checkInternetConnectivity();

                  if(connectionStatus){
                    Map<String,dynamic> args = new Map();
                    Loader.showLoadingScreen(context, _keyLoader);
                    List bagItems = await _shoppingBagService.list();
                    args['bagItems'] = bagItems;
                    args['route'] = '/home';
                    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                    Navigator.pushReplacementNamed(context, '/bag', arguments: args);
                  }
                  else{
                    internetConnectionDialog(context);
                  }
                },
              ),
              // ListTile(
              //   leading: Icon(Icons.search),
              //   title: Text(
              //     SBT_SEARCH_TEXT,
              //     style: TextStyle(
              //         fontSize: 20.0,
              //         fontWeight: FontWeight.bold,
              //         letterSpacing: 1.0
              //     ),
              //   ),
              // ),
              ListTile(
                leading: Icon(Icons.local_shipping),
                title: Text(
                  SBT_ORDERS_TEXT,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0
                  ),
                ),
                onTap: () async {
                  bool connectionStatus = await _userService.checkInternetConnectivity();

                  if(connectionStatus){
                    print("đã vào đây");
                    Loader.showLoadingScreen(context, _keyLoader);
                    List orderData = await _checkoutService.listPlacedOrder();
                    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                    print("orderData : $orderData");
                    Navigator.popAndPushNamed(context, '/placedOrder',arguments: {'data': orderData});
                  }
                  else{
                    internetConnectionDialog(context);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.favorite_border),
                title: Text(
                  SBT_WISHlIST_TEXT,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0
                  ),
                ),
                onTap: ()async{
                  bool connectionStatus = await _userService.checkInternetConnectivity();

                  if(connectionStatus){
                    Loader.showLoadingScreen(context, _keyLoader);
                    List userList = await _userService.userWishlist();
                    print("danh sach yeu thich $userList");
                    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                    Navigator.popAndPushNamed(context, '/wishlist',arguments: {'userList':userList});
                  }
                  else{
                    internetConnectionDialog(context);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  SBT_PROFILE_TEXT,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0
                  ),
                ),
                onTap: () async{
                  bool connectionStatus = await _userService.checkInternetConnectivity();

                  if(connectionStatus){
                    Loader.showLoadingScreen(context, _keyLoader);
                    Map userProfile = await _profileService.getUserProfile();
                    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
                    Navigator.popAndPushNamed(context, '/profile',arguments: userProfile);
                  }
                  else{
                    internetConnectionDialog(context);
                  }
                },
              ),
              ListTile(
                leading: new Icon(Icons.exit_to_app),
                title: Text(
                  SBT_LOGOUT_TEXT,
                  style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0
                  ),
                ),
                onTap: () async{
                  bool connectionStatus = await _userService.checkInternetConnectivity();

                  if(connectionStatus){
                    _userService.logOut(context);
                  }
                  else{
                    internetConnectionDialog(context);
                  }
                },
              )
            ],
          )
        ],
      ),
    ),
  );
}
