import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class Textwidget extends StatelessWidget {
  Textwidget(
      {super.key,
      required this.text,
      required this.color,
      this.fs = 18,
      this.istitle = false});
  String text;
  Color color;
  double fs;
  bool istitle;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.quicksand(
          color: color,
          fontSize: fs,
          fontWeight: istitle == false ? FontWeight.w600 : FontWeight.bold),
    );
  }
}
