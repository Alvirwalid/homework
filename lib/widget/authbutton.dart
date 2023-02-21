import 'package:auction/widget/textwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class AuthButton extends StatelessWidget {
  const AuthButton(
      {super.key,
      required this.btntext,
      this.primary = Colors.white,
      required this.fct});

  final String btntext;
  final Color primary;
  final Function fct;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        fct();
      },
      child: Container(
          width: double.infinity,
          height: size.height * 0.07,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              //color: Colors.amber,
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff2886A6),
                    Color(0xff2888A8),
                    Color(0xff2B92B4),
                    Color(0xff2C97BB),
                    Color(0xff2D9BBF),
                    Color(0xff2FA2C8),
                    Color(0xff32AAD2),
                    Color(0xff34B2DD),
                    Color(0xff36BAE6),
                    Color(0xff37BBE8),
                  ])),
          child: Center(child: Textwidget(text: btntext, color: primary))),
    );
  }
}
