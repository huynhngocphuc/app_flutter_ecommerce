import 'package:flutter/material.dart';
import 'package:app_frontend/sizeConfig.dart';

class ProductButtons extends StatefulWidget {
  final void Function() addToShoppingBag;
  // final void Function() checkoutProduct;
  final void Function() addToWishList;

  ProductButtons(this.addToShoppingBag,this.addToWishList);
  @override
  _ProductButtonsState createState() => _ProductButtonsState();
}

class _ProductButtonsState extends State<ProductButtons> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:[
        ButtonTheme(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.safeBlockVertical * 1.6
          ),
          minWidth: SizeConfig.screenWidth / 2.7,
          child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              ),
              elevation: 16.0,
              onPressed: (){
                widget.addToShoppingBag();
              },
              color: Colors.white,
              child: Text(
                'Thêm giỏ hàng',
                style: TextStyle(
                    fontFamily: 'NovaSquare',
                    fontSize: SizeConfig.safeBlockHorizontal * 5.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                ),
              )
          ),
        ),
        ButtonTheme(
          minWidth: SizeConfig.screenWidth / 2.7,
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.safeBlockVertical * 1.6
          ),
          child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
              ),
              elevation: 16.0,
              onPressed: (){
                widget.addToWishList();
              },
              color: Colors.black,
              child: Text(
                'yêu thích ',
                style: TextStyle(
                    fontFamily: 'NovaSquare',
                    fontSize: SizeConfig.safeBlockHorizontal * 5.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              )
          ),
        )
      ],
    );
  }
}
