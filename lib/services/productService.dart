import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:app_frontend/services/userService.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class ProductService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference _productReference = FirebaseFirestore.instance.collection('products');
  CollectionReference _categoryReference = FirebaseFirestore.instance.collection('category');
  CollectionReference _subCategoryReference = FirebaseFirestore.instance.collection('subCategory');

  UserService _userService = new UserService();
  List subCategoryList = [];


  Future<List> listSubCategories(String categoryId) async {
    QuerySnapshot subCategoryRef = await _subCategoryReference.where('categoryId',isEqualTo: categoryId).get();
    List subCategoryList = [];
    for(int i=0;i< subCategoryRef.docs.length;i++){
      Map subCategory = subCategoryRef.docs[i].data();
      String image = await getProductsImage(subCategory['imageId']);
      subCategoryList.add({
        'imageId': image,
        'name': subCategory['name'],
        'id': subCategoryRef.docs[i].id
      });
    }
    return subCategoryList;
  }

  Future<String> getProductsImage(String imageId) async{
    final ref = FirebaseStorage.instance.ref().child('$imageId.jpg');
    String url = await ref.getDownloadURL();
    return url;
  }

  Future<List> newItemArrivals() async{
    Random rdn = new Random();
    List<Map<String,String>> itemList = [];

    int randomNumber = 1 + rdn.nextInt(20);

    QuerySnapshot itemsRef = await _productReference.orderBy('name').startAt([randomNumber]).limit(5).get();
    for(QueryDocumentSnapshot docRef in itemsRef.docs){
      Map<String,String> items = new Map();
      // String image = await getProductsImage(docRef.data()['imageId'][0]);
      String image = "assets/mock_images/products/${docRef.data()['imageId'][0]}.jpg";
      items['image'] = image;
      items['name'] = docRef.data()['name'];
      items['productId'] = docRef.id;
      itemList.add(items);
    }
    return itemList;
  }
  
  Future <List> featuredItems() async{
    List<Map<String,String>> itemList = [];
    QuerySnapshot itemsRef = await _productReference.limit(15).get();
    for(DocumentSnapshot docRef in itemsRef.docs){
      Map<String,String> items = new Map();
      // String image = await getProductsImage(docRef.data()['imageId'][0]);
      String image = "assets/mock_images/products/${docRef.data()['imageId'][0]}.jpg";
      items['image'] = image;
      items['name'] = docRef.data()['name'];
      items['price'] = docRef.data()['price'].toString();
      items['productId'] = docRef.id;
      itemList.add(items);
    }
    return itemList;
  }
  
  Future <List> listSubCategoryItems(String subCategoryId) async{
    List<Map<String,String>> itemsList = [];
    QuerySnapshot productRef = await _productReference.where("subCategory",isEqualTo: subCategoryId).get();

    for(DocumentSnapshot docRef in productRef.docs){
      Map<String,String> items  = new Map();
      String imageProduct = "assets/mock_images/products/${docRef.data()['imageId'][0]}.jpg";
      // items['image'] = await getProductsImage(docRef.data()['imageId'][0]);
      items['image'] = imageProduct;

      items['name'] = docRef.data()['name'];
      items['price'] = docRef.data()['price'].toString();
      items['productId'] = docRef.id;
      itemsList.add(items);
    }
    return itemsList;
  }
  
  Future <List> listCategories() async{
    QuerySnapshot _categoryRef = await _categoryReference.get();

    List <Map<String,String>> categoryList = [];
    for(DocumentSnapshot dataRef in _categoryRef.docs){
      Map<String,String> category = new Map();
      category['name'] = dataRef.data()['name'];
      category['image'] = dataRef.data()['image'];
      category['id'] = dataRef.id;
      categoryList.add(category);
    }
    return categoryList;
  }

  // ignore: missing_return
  Future <String> addItemToWishlist(String productId) async{
    String msg;
    String uid = await _userService.getUserId();
    print("v??o h??m add wish list uid : ${uid} idproduct : ${productId}");
    List<dynamic> wishlist = <dynamic>[];
    QuerySnapshot userRef = await _firestore.collection('users').where('userId',isEqualTo: uid).get();
    print("userRef ${userRef.docs[0]}");
    Map userData = userRef.docs[0].data();
    String documentId = userRef.docs[0].id;
    if(userData.containsKey('wishlist')){
      wishlist = userData['wishlist'];
      if(wishlist.indexOf(productId) == -1){
        wishlist.add(productId);
      }
      else{
        msg = 'S???n ph???m ???? t???n t???i trong y??u th??ch';
        return msg;
      }
    }
    else{
      wishlist.add(productId);
    }
    await _firestore.collection('users').doc(documentId).update({
      'wishlist': wishlist
    }).then((value) {
      print("nh???y v??o r???i");
      msg = '???? th??m v??o s???n ph???m y??u th??ch';
    }).catchError((e) {
      print("l???i update $e");
    });
    return msg;

  }

  Future<Map> particularItem(String productId) async{

    DocumentSnapshot prodRef = await _productReference.doc(productId).get();
    Map<String, dynamic> itemDetail = new Map();
    String imageProduct = "assets/mock_images/products/${prodRef.data()['imageId'][0]}.jpg";
    // itemDetail['image'] = await getProductsImage(prodRef.data()['imageId'][0]);
    itemDetail['image'] = imageProduct;
    itemDetail['color'] = prodRef.data()['color'];
    itemDetail['size'] = prodRef.data()['size'];
    itemDetail['price'] = prodRef.data()['price'];
    itemDetail['name'] = prodRef.data()['name'];
    itemDetail['productId'] = productId;
    return itemDetail;
  }
}

class NewArrival{
  final String name;
  final String image;
  NewArrival({this.name, this.image});
}