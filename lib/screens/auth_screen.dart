// ignore_for_file: use_key_in_widget_constructors

import 'dart:io';

import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var isLoading = false;
  void _submitAuthForm(
    String email,
    String userName,
    String password,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    final UserCredential authResult;
    try {
      setState(() {
        isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final ref = FirebaseStorage.instance
            .ref()
            .child('UserImage')
            .child(authResult.user!.uid + '.jpg');
        await ref.putFile(image).whenComplete(() => null);
        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({'username': userName, 'email': email, 'imageURL': url});
      }
    } on PlatformException catch (error) {
      var message = 'An error occurred ,please check your credentials!';
      if (error.message != null) {
        message = error.message!;
      }
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(message)));
    } on FirebaseAuthException catch (err) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(ctx)
          .showSnackBar(SnackBar(content: Text(err.message.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, isLoading),
    );
  }
}
