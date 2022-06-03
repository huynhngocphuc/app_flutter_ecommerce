import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
class UserService{
  FirebaseAuth _auth;
  FirebaseFirestore _firestore;
  FlutterSecureStorage _storage;
  GoogleSignInAccount _ggAuth;

  UserService(){
    initializeFirebaseApp();
  }

  void initializeFirebaseApp() async{
    bool internetConnection = await checkInternetConnectivity();
    if(internetConnection){
      await Firebase.initializeApp();
      _auth = FirebaseAuth.instance;
      _firestore = FirebaseFirestore.instance;
      _storage = new FlutterSecureStorage();
    }
  }

  int statusCode;
  String msg;

  void storeJWTToken(String idToken, refreshToken) async{
    await _storage.write(key: 'idToken', value: idToken);
    await _storage.write(key: 'refreshToken', value: refreshToken);
  }

  String validateToken(String token){
    bool isExpired = Jwt.isExpired(token);

    if(isExpired){
      return null;
    }
    else{
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      print("xem pay load ${payload['user_id']}");
      if(payload['user_id'] == null)
        {
          return payload['sub'];
        }
      return payload['user_id'];
    }
  }

  void logOut(context) async{
    await _storage.deleteAll();
    await _auth.signOut();
    await GoogleSignIn().signOut();
    Navigator.of(context).pushReplacementNamed('/');
  }

  Future<void> login(userValues) async{
    String email = userValues['email'];
    String password = userValues['password'];
    await _auth.signInWithEmailAndPassword(email: email, password: password).then((dynamic user) async{
      final User currentUser = _auth.currentUser;
      String idToken = await currentUser.getIdToken();
      String refreshToken = currentUser.refreshToken;
      storeJWTToken(idToken, refreshToken);
      statusCode = 200;
    }).catchError((error){
      handleAuthErrors(error);
    });
  }

  Future<String> loginWithGoogle() async{
    try {
      _ggAuth = await GoogleSignIn().signIn();

      if (_ggAuth != null){
        final GoogleSignInAuthentication googleSignInAuthentication = await _ggAuth.authentication;
        QuerySnapshot data = await _firestore.collection('users').where("userId", isEqualTo: _ggAuth.id).get();
        if(data.docs.length == 0)
          {
            _firestore.collection('users').add({
              'fullName': _ggAuth.displayName,
              'mobileNumber': "09",
              'userId': _ggAuth.id,
              'email': _ggAuth.email
            });
          }
        else {
          print("không đăng ký nua");
        }
        print("data lấy được ${data.docs[0].data()}");
        await _storage.write(key: 'email', value: _ggAuth.email);
        String idToken = googleSignInAuthentication.idToken;
        storeJWTToken(idToken, "");
        print("token ban dau $idToken");
        statusCode = 200;
        return _ggAuth.email;
      }
    }
    catch(e){
      print("lỗi $e");
    }

  }
  Future<String> getUserId() async{
    var token = await _storage.read(key: 'idToken');
    print("idToken hieenj tai ${token}");
    var uid = validateToken(token);
    return uid;
  }
  Future<void> signup(userValues) async{
    String email = userValues['email'];
    String password = userValues['password'];

    await _auth.createUserWithEmailAndPassword(email: email, password: password).then((dynamic user){
      String uid = user.user.uid;
      _firestore.collection('users').add({
        'fullName': userValues['fullName'],
        'mobileNumber': userValues['mobileNumber'],
        'userId': uid
      });

      statusCode = 200;
    }).catchError((error){
      handleAuthErrors(error);
    });
  }

  void handleAuthErrors(error){
    String errorCode = error.code;
    switch(errorCode){
      case "email-already-in-use":
        {
          statusCode = 400;
          msg = "Email đã được sử dụng";
        }
        break;
      case "wrong-password":
        {
          statusCode = 400;
          msg = "Sai mật khẩu";
        }
    }
  }

  String capitalizeName(String name){
    name = name[0].toUpperCase()+ name.substring(1);
    return name;
  }

  Future<String> userEmail() async{

    var checkEmail = _auth.currentUser;
    var userEmail = "";
    if(checkEmail == null)
      {
        print("xem email lấy $userEmail");
        userEmail = await _storage.read(key: 'email');
      }
    else {
      userEmail = _auth.currentUser.email;
    }

    return userEmail;
  }


  Future<List> userWishlist() async{
    String uid = await getUserId();
    QuerySnapshot userRef = await _firestore.collection('users').where('userId',isEqualTo: uid).get();

    Map userData = userRef.docs[0].data();
    List userWishList =[];
    if(userData.containsKey('wishlist')){
      for(String item in userData['wishlist']){
        Map<String, dynamic> tempWishList = new Map();
        DocumentSnapshot productRef = await _firestore.collection('products').doc(item).get();

        tempWishList['productName'] = productRef.data()['name'];
        tempWishList['price'] = productRef.data()['price'];
        tempWishList['image'] = productRef.data()['imageId'];
        tempWishList['productId'] = productRef.id;
        userWishList.add(tempWishList);
      }
    }

    return userWishList;
  }

  Future<void> deleteUserWishlistItems(String productId) async{
    String uid = await getUserId();
    QuerySnapshot userRef = await _firestore.collection('users').where('userId',isEqualTo: uid).get();
    String documentId = userRef.docs[0].id;
    Map<String,dynamic> wishlist = userRef.docs[0].data();
    wishlist['wishlist'].remove(productId);

    await _firestore.collection('users').doc(documentId).update({
      'wishlist':wishlist['wishlist']
    });
  }

  String getConnectionValue(var connectivityResult) {
    String status = '';
    switch (connectivityResult) {
      case ConnectivityResult.mobile:
        status = 'Mobile';
        break;
      case ConnectivityResult.wifi:
        status = 'Wi-Fi';
        break;
      case ConnectivityResult.none:
        status = 'None';
        break;
      default:
        status = 'None';
        break;
    }
    return status;
  }

  Future<bool> checkInternetConnectivity() async{
    final Connectivity _connectivity = Connectivity();
    ConnectivityResult result = await _connectivity.checkConnectivity();
    String connection = getConnectionValue(result);
    if(connection == 'None') {
      return false;
    }
    else{
      return true;
    }
  }
}

