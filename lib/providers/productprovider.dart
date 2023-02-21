import 'package:auction/model/productmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductProvider extends ChangeNotifier {
  final List<ProductModel> productList = [];
  List<ProductModel> get getProduct {
    return productList;
  }

  Future<void> fetchData() async {
    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          productList.insert(
              0,
              ProductModel(
                  details: doc['details'],
                  displayname: doc['displayname'],
                  endTime: doc['endTime'],
                  productimage: doc['image'],
                  productName: doc['productName'],
                  productPrice: doc['productPrice'],
                  profile_photo: doc['profile-photo'],
                  quantity: doc['quantity'],
                  uid: doc['uid']));
          //notifyListeners();
        });
      });
    } on FirebaseException catch (err) {
      Get.snackbar('Error Occured', '$err');
    } catch (err) {
      Get.snackbar('Error Occured', '$err',
          backgroundColor: Colors.teal, colorText: Colors.white);
    }
  }
}
