import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_supply_chain_management_fyp/firebase/firebase_user.dart';

import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Register a new user with their role
  Future<void> registerUser(String name,String email, String password, String userRole,String phoneno) async {

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel user = UserModel(
        id: userCredential.user!.uid,
        name:name,
        email: email,
        userRole: userRole,
        photoUrl: 'https://img.freepik.com/free-vector/isolated-young-handsome-man-different-poses-white-background-illustration_632498-859.jpg?size=626&ext=jpg'
      ,phoneno: phoneno
      );

      //add user data fire store
      UserService userService=UserService();
      userService.storeUser(user);
      _auth.signOut();
  }

  Future<UserModel?> loginUser(String email, String password) async {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;
    //get user data fire store
    UserService userService=UserService();
   UserModel? userModel=await userService.getUserById(user!.uid);
    if (user != null)
    {
        return userModel;

    }
    return null;
  }

  Future<void> logoutUser() async {
      await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<UserModel?> getUserLoggedin() async {
    UserService userService=UserService();
    UserModel? userModel;
    if(_auth.currentUser!=null){
      userModel =await userService.getUserById(_auth.currentUser!.uid);
    }
    return userModel;
  }
}
