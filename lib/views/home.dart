import 'package:auction/providers/bitprovider.dart';
import 'package:auction/views/dashboard.dart';
import 'package:auction/views/user/add_post.dart';
import 'package:auction/views/user/profile.dart';
import 'package:auction/widget/textwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../helper/firebase_helpers.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static const routename = '/Home';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final getCurrentUser = FirebaseHelpers().getCurrentUID();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    var orderprovider = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Auction Gallery"),
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Profile()),
                );
              },
              child: Text("mypost")),
          // IconButton(
          //     onPressed: () => FirebaseHelpers().signOut(context),
          //     icon: Icon(Icons.logout))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(AddPost.routename);
          },
          child: Icon(Icons.add)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isNotEmpty) {
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(data[
                                          'profile-photo'] ==
                                      null
                                  ? 'https://static.vecteezy.com/system/resources/thumbnails/002/275/847/small/male-avatar-profile-icon-of-smiling-caucasian-man-vector.jpg'
                                  : '${data['profile-photo']}'),
                            ),
                            SizedBox(width: 10),
                            Text('${data['displayname']}',
                                style: TextStyle(fontWeight: FontWeight.bold))
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.015,
                        ),
                        Text('${data['productName']}'),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Text('Price: BDT  ${data['productPrice']}'),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Text('Quantity: ${data['quantity']}'),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Text('About : ${data['details']}'),
                        SizedBox(
                          height: size.height * 0.01,
                        ),
                        Text(' last date : ${data['endDate']}'),
                        SizedBox(
                          height: 15,
                        ),
                        ElevatedButton(
                            onPressed: () async {
                              orderprovider.addConfirmorder(
                                data['displayname'],
                                int.parse(data['productPrice']),
                                int.parse(data['quantity']),
                                data['endDate'],
                              );
                            },
                            child: Text('Bit now')),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: ClipRRect(
                              child: Image.network(
                            '${data['image']}',
                            height: 100,
                            fit: BoxFit.cover,
                          )),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          } else {
            return Center(child: Text("No data found"));
          }
        },
      ),
      bottomNavigationBar: Container(
        height: 70,
        child: ElevatedButton(
            onPressed: () {
              Get.toNamed(Dashboard.routename);
            },
            child: Textwidget(text: 'Dashboeard', color: Colors.white)),
      ),
    );
  }
}
