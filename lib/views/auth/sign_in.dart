import 'package:auction/views/auth/register.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:iconly/iconly.dart';

import '../../helper/firebase_helpers.dart';
import '../../widget/authbutton.dart';
import '../../widget/textwidget.dart';

class SignIn extends StatefulWidget {
  SignIn({Key? key}) : super(key: key);
  static const routename = '/SignIn';

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  final _passfocus = FocusNode();
  var _obscureText = true;
  Color color = Colors.grey.withOpacity(0.7);

  final _formkey = GlobalKey<FormState>();

  bool _isloaded = false;

  void submitFormOnLogin() async {
    final isVallid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isVallid) {
      _formkey.currentState!.save();

      setState(() {
        _isloaded = true;
      });
      FirebaseHelpers().signInUsingEmailPassword(
          emailController.text, passwordController.text, context);

      setState(() {
        _isloaded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  height: size.height * 0.1,
                ),
                Textwidget(text: 'Welcome', color: Colors.black, fs: 24),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Image.asset(
                  './asset/image/llll.png',
                  width: double.infinity,
                  height: size.height * 0.3,
                ),
                const SizedBox(
                  height: 10,
                ),
                Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          textInputAction: TextInputAction.next,
                          // onEditingComplete: () =>
                          //     FocusScope.of(context).requestFocus(_passfocus),
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return 'Enter a valid email address';
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                IconlyBold.message,
                                color: Colors.black,
                                size: 30,
                              ),
                              contentPadding: EdgeInsets.all(20),
                              filled: true,
                              fillColor: Colors.grey.withOpacity(0.1),
                              hintText: 'Email',
                              hintStyle: TextStyle(color: Colors.black),
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none)),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: passwordController,
                          textInputAction: TextInputAction.done,
                          // onEditingComplete: () => submitFormOnLogin(),
                          validator: (value) {
                            if (value!.isEmpty || value.length < 6) {
                              return 'Enter a valid  password';
                            } else {
                              return null;
                            }
                          },
                          style: const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              IconlyBold.lock,
                              color: Colors.black,
                              size: 30,
                            ),
                            contentPadding: EdgeInsets.all(17),
                            filled: true,
                            fillColor: Colors.grey.withOpacity(0.1),
                            suffix: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                                child: _obscureText
                                    ? const Icon(
                                        Icons.visibility,
                                        color: Colors.black,
                                        // size: 22,
                                      )
                                    : const Icon(Icons.visibility_off,
                                        color: Colors.black)),
                            hintText: 'Password',
                            hintStyle: const TextStyle(color: Colors.black),
                            enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide.none),
                          ),
                          obscureText: _obscureText,
                        ),
                      ],
                    )),
                SizedBox(
                    width: double.infinity,
                    child: _isloaded
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : AuthButton(
                            btntext: 'Login',
                            fct: () {
                              submitFormOnLogin();
                            })),
                const SizedBox(
                  height: 25,
                ),
                RichText(
                    text: TextSpan(
                        text: 'Registration',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                        children: [
                      TextSpan(
                          text: '   Sign up',
                          style: const TextStyle(
                              color: Colors.lightBlue,
                              fontSize: 22,
                              fontWeight: FontWeight.w600),
                          recognizer: TapGestureRecognizer()
                            ..onTap = (() {
                              Get.toNamed(Register.routename);
                            }))
                    ])),
              ]),
        ),
      ),
    );
  }
}
