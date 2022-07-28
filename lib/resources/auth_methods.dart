import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:instagram_flutter/resources/storage_methods.dart';

class AuthMethods{

  // ignore: unused_field
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign Up user
  Future<String> signupUser({
      required String email,
      required String password,
      required String username,
      required String bio,
      required Uint8List file

  }) async {
      String res = "something went wrong";
      try{
        if(email.isNotEmpty || password.isNotEmpty || username.isNotEmpty || bio.isNotEmpty || file != null){
          // Register User
          UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);


          print(cred.user!.uid);

          String photoUrl = await StorageMethods().UploadImageToStorage('ProfilePics', file, false);

          // Add user to database(firestore)
          await _firestore.collection('users').doc(cred.user!.uid).set({
            'username' : username,
            'password' : password,
            'uid' : cred.user!.uid,
            'email' : email,
            'bio' : bio,
            'followers' : [],
            'following' : [],
            'photoUrl' : photoUrl,

          });

          res = "Success!";


        }
      }catch(err){
        res = err.toString();
      }
      return res;
  }

  // Logging in users

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {

    String res = "Some error occured";

    try{
      if(email.isNotEmpty && password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = "Success!";
      } else {
        res = "Please enter all the fields";
      }
    } catch(err){
        res = err.toString();
    }

    return res;
  }





}