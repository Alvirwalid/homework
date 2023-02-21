import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/textwidget.dart';
//import 'package:marchentapp/widgets/textwidget.dart';

class GlobalMethod {
  static navigateTo({required BuildContext ctx, required String routeName}) {
    Navigator.of(ctx).pushNamed(routeName);
  }

  static Future<void> warningDialog(
      {required BuildContext ctx,
      required String title,
      required String subtitle,
      required Function onpressed}) async {
    await showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: Row(children: [
              Image.asset(
                './asset/image/warning-sign.png',
                height: 20,
                width: 20,
                fit: BoxFit.fill,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(title)
            ]),
            content: Text(subtitle),
            actions: [
              TextButton(
                  onPressed: (() {
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop();
                    }
                  }),
                  child: Textwidget(
                    color: Colors.cyan,
                    text: 'Cancel',
                    fs: 18,
                  )),
              TextButton(
                  onPressed: () {
                    onpressed();
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Textwidget(
                    color: Colors.red,
                    text: 'Ok',
                    fs: 18,
                  )),
            ],
          );
        });
  }

  static Future<void> errorDialog({
    required BuildContext ctx,
    required String subtitle,
  }) async {
    await showDialog(
        context: ctx,
        builder: (context) {
          return AlertDialog(
            title: Row(children: [
              Image.asset(
                './asset/image/warning-sign.png',
                height: 20,
                width: 20,
                fit: BoxFit.fill,
              ),
              const SizedBox(
                width: 8,
              ),
              const Text('An error occured')
            ]),
            content: Text(subtitle),
            actions: [
              TextButton(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Textwidget(
                    color: Colors.red,
                    text: 'Ok',
                    fs: 18,
                  )),
            ],
          );
        });
  }
}
