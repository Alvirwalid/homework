import 'dart:io';
import 'package:auction/views/auth/sign_in.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../common/contss.dart';
import '../../helper/firebase_helpers.dart';
import '../../service/globalmethod.dart';
import '../../widget/authbutton.dart';
import '../../widget/textwidget.dart';

class Register extends StatefulWidget {
  Register({Key? key}) : super(key: key);
  static const routename = '/Register';

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController name = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  final _passfocus = FocusNode();

  final _emailfocus = FocusNode();

  final _addressfocus = FocusNode();

  var _obscureText = true;

  final _formkey = GlobalKey<FormState>();

  bool _isLoaded = false;

  XFile? _itemPhoto;
  String? imageURl;
  chooseImage() async {
    ImagePicker picker = ImagePicker();
    _itemPhoto = await picker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  void submitFormOnregistration() async {
    File _itemPhotoFile = File(_itemPhoto!.path);

    final isVallid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isVallid) {
      _formkey.currentState!.save();

      setState(() {
        _isLoaded = true;
      });

      FirebaseStorage storage = FirebaseStorage.instance;
      UploadTask uploadTask = storage
          .ref('profile-photo')
          .child(_itemPhoto!.name)
          .putFile(_itemPhotoFile);

      TaskSnapshot snapshot = await uploadTask;
      imageURl = await snapshot.ref.getDownloadURL();

      FirebaseHelpers()
          .signUp(name.text, email.text, password.text, imageURl, context);

      setState(() {
        _isLoaded = false;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      children: [
        Swiper(
          duration: 800,
          autoplayDelay: 6000,
          itemBuilder: (BuildContext context, int index) {
            return Image.asset(
              Constss.imglist[index]['imagepath'],
              fit: BoxFit.cover,
            );
          },
          autoplay: true,
          itemCount: Constss.imglist.length,
        ),
        Container(
          color: Colors.black.withOpacity(0.7),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: size.height * 0.2,
                ),
                Textwidget(text: 'Welcome Back', color: Colors.white, fs: 24),
                const SizedBox(
                  height: 8,
                ),
                Textwidget(
                    text: 'Sign in to continue', color: Colors.white, fs: 16),
                const SizedBox(
                  height: 20,
                ),
                Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        _itemPhoto == null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        chooseImage();
                                      },
                                      icon: Icon(
                                        Icons.add_to_photos_rounded,
                                        color: Colors.white,
                                      )),
                                  Text(
                                    "Add profile picture",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              )
                            : Container(
                                height: 150,
                                // width: double.infinity,
                                child: Image.file(
                                  File(_itemPhoto!.path),
                                  width: 250,
                                  fit: BoxFit.fill,
                                )),
                        SizedBox(
                          height: size.height * 0.02,
                        ),
                        TextFormField(
                          controller: name,
                          textInputAction: TextInputAction.next,
                          //onEditingComplete: () => submitFormOnregistration(),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter  Name';
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Full Name',
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: email,
                          textInputAction: TextInputAction.next,
                          // onEditingComplete: () => submitFormOnregistration(),
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Enter a valid email address';
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: password,
                          textInputAction: TextInputAction.done,
                          // onEditingComplete: () => submitFormOnregistration(),
                          validator: (value) {
                            if (value!.isEmpty || value.length < 7) {
                              return 'enter more than 7';
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            suffix: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: _obscureText
                                    ? const Icon(
                                        Icons.visibility,
                                        color: Colors.white,
                                      )
                                    : const Icon(Icons.visibility_off,
                                        color: Colors.white)),
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                          ),
                          obscureText: _obscureText,
                        ),
                      ],
                    )),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  child: _isLoaded
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : AuthButton(
                          btntext: 'Sign Up',
                          fct: () {
                            submitFormOnregistration();
                          },
                        ),
                ),
                const SizedBox(
                  height: 25,
                ),
                RichText(
                    text: TextSpan(
                        text: 'Already a user?',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                        children: [
                      TextSpan(
                          text: '   Sign in',
                          style: const TextStyle(
                              color: Colors.lightBlue,
                              fontSize: 22,
                              fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()
                            ..onTap = (() {
                              Get.toNamed(SignIn.routename);
                            }))
                    ])),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
