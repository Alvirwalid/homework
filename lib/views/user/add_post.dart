import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

import 'package:image_picker/image_picker.dart';

import '../../helper/firebase_helpers.dart';
import '../../widget/textwidget.dart';

class AddPost extends StatefulWidget {
  const AddPost({Key? key}) : super(key: key);
  static const routename = '/AddPost';

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController endDate = TextEditingController();

  TextEditingController name = TextEditingController();

  bool _isbool = false;

  XFile? _itemPhoto;
  String? imageURl;
  chooseImage() async {
    ImagePicker picker = ImagePicker();
    _itemPhoto = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  addPost() async {
    File _itemPhotoFile = File(_itemPhoto!.path);

    setState(() {
      _isbool = true;
    });

    FirebaseStorage storage = FirebaseStorage.instance;
    UploadTask uploadTask = storage
        .ref('post-photo')
        .child(_itemPhoto!.name)
        .putFile(_itemPhotoFile);

    TaskSnapshot snapshot = await uploadTask;
    imageURl = await snapshot.ref.getDownloadURL();

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection('posts');

    collectionReference.add({
      'image': imageURl,
      'details': descriptionController.text.toString(),
      'productName': name.text.toString(),
      'productPrice': price.text.toString(),
      'quantity': quantity.text.toString(),
      'endDate': endDate.text.toString(),
      'uid': getCurrentUser!.uid,
      'displayname': getCurrentUser!.displayName,
      'profile-photo': getCurrentUser!.photoURL
    });

    setState(() {
      _isbool = false;
    });
  }

  final getCurrentUser = FirebaseHelpers().getCurrentUID();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                Container(
                  height: size.height * 0.17,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: _itemPhoto == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                                onPressed: () {
                                  chooseImage();
                                },
                                icon: Icon(Icons.add_to_photos_rounded)),
                            Text("Add photo")
                          ],
                        )
                      : Image.file(File(_itemPhoto!.path)),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Textwidget(
                  text: 'Product name',
                  color: Colors.black,
                  istitle: true,
                  fs: 16,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                TextFormField(
                  controller: name,
                  key: const ValueKey('name'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter product name';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.transparent))),
                ),
                SizedBox(
                  height: size.height * 0.020,
                ),
                Textwidget(
                  text: 'Price',
                  color: Colors.black,
                  istitle: true,
                  fs: 16,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Container(
                  child: TextFormField(
                    controller: price,
                    key: const ValueKey('Price'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter product Price';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.transparent)),
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
                    ],
                  ),
                ),
                SizedBox(
                  height: size.height * 0.020,
                ),
                Textwidget(
                  text: 'Quantity',
                  color: Colors.black,
                  istitle: true,
                  fs: 16,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                TextFormField(
                  controller: quantity,
                  key: const ValueKey('quantity'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'product quantity';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.transparent))),
                ),
                Textwidget(
                  text: 'End date',
                  color: Colors.black,
                  istitle: true,
                  fs: 16,
                ),
                SizedBox(
                  height: size.height * 0.020,
                ),
                TextFormField(
                  controller: endDate,
                  key: const ValueKey('endtime'),
                  onTap: () async {
                    DateTime? pickeddate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2030));

                    if (pickeddate != null) {
                      setState(() {
                        endDate.text =
                            DateFormat('MM/dd/yyyy hh:mm a').format(pickeddate);
                      });
                    }
                    ;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter auction end time';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      border: InputBorder.none,
                      labelText: 'Select Date',
                      icon: Icon(Icons.calendar_today_rounded),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.transparent))),
                ),
                SizedBox(
                  height: size.height * 0.020,
                ),
                Textwidget(
                  text: 'Product Details',
                  color: Colors.black,
                  istitle: true,
                  fs: 16,
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                TextFormField(
                  //minLines: 20,
                  maxLines: 3,
                  controller: descriptionController,
                  keyboardType: TextInputType.multiline,
                  key: const ValueKey('Enter Product details'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter product details';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.transparent)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.transparent))),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),
                Center(
                  child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(minimumSize: Size(200, 50)),
                      onPressed: () {
                        addPost();
                        Navigator.pop(context);
                      },
                      child: _isbool
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            )
                          : Text("Publish")),
                ),
                SizedBox(
                  height: size.height * 0.2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
