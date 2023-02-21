import 'package:auction/views/auth/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../views/home.dart';

class FirebaseHelpers {
  // Future<void> addUser(name, email, password) {
  //   CollectionReference users = FirebaseFirestore.instance.collection('users');
  //   return users.add({
  //     'name': name.text,
  //     'email': email.text,
  //     'password': password.text,
  //   });
  // }

  signUp(name, email, password, imageUrl, context) async {
    CollectionReference user = FirebaseFirestore.instance.collection('users');
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    var authCredential = userCredential.user;

    try {
      if (authCredential!.uid.isNotEmpty) {
        await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
        await FirebaseAuth.instance.currentUser!.updatePhotoURL(imageUrl);

        user.add({
          'name': name,
          'email': email,
          'uid': authCredential.uid,
        });

        Get.toNamed(SignIn.routename);

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const Home()),
        // );
      } else {
        print("Failed");
      }
    } on FirebaseAuthException catch (e) {
      // Get.snackbar('Error occured', e.toString());

      if (e.code == 'weak-password') {
        //Get.snackbar('', 'The password provided is too weak.');

        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        //Get.snackbar('', 'The account already exists for that email.');
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  signInUsingEmailPassword(email, password, context) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;

      print("email you typed ${user!.email}");

      if (user != null) {
        Get.offAllNamed(Home.routename);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showDialog(
            context: context,
            builder: ((context) {
              return AlertDialog(title: Text("No user found for that email."));
            }));
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        showDialog(
            context: context,
            builder: ((context) {
              return AlertDialog(title: Text("Wrong password provided."));
            }));
        print('Wrong password provided.');
      } else {
        showDialog(
            context: context,
            builder: ((context) {
              return AlertDialog(title: Text("${e}"));
            }));
      }
    }

    return user;
  }

  Future<void> signOut(context) async {
    await FirebaseAuth.instance.signOut();

    Get.offAllNamed(SignIn.routename);
    // Navigator.pushReplacement(
    //     context, MaterialPageRoute(builder: (context) => SignIn()));
  }

  User? getCurrentUID() {
    FirebaseAuth auth = FirebaseAuth.instance;

    final User? user = auth.currentUser;

    return user;
  }
}
