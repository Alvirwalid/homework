import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../helper/firebase_helpers.dart';
import 'edit_profile.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({Key? key}) : super(key: key);

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  final getCurrentUser = FirebaseHelpers().getCurrentUID();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfile()),
                );
              },
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 100,
                    backgroundImage: getCurrentUser!.photoURL == null
                        ? NetworkImage(
                            "https://cdn-icons-png.flaticon.com/512/149/149071.png")
                        : NetworkImage("${getCurrentUser!.photoURL}"),
                  ),
                  Positioned(
                      top: 120,
                      left: 160,
                      child: Icon(
                        Icons.edit,
                        size: 40,
                        color: Colors.blue,
                      ))
                ],
              ),
            ),
            SizedBox(
              height: size.height * 0.02,
            ),
            Text(
              "${getCurrentUser!.displayName}",
              style: TextStyle(fontSize: 35),
            ),
            SizedBox(
              height: size.height * 0.01,
            ),
            Text("${getCurrentUser!.email}"),
            SizedBox(
              height: size.height * 0.02,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfile()),
                  );
                },
                child: Text("Edit"))
          ],
        ),
      ),
    );
  }
}
