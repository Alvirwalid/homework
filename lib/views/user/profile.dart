import 'package:auction/views/user/profile_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../helper/firebase_helpers.dart';
import 'add_post.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final getCurrentUser = FirebaseHelpers().getCurrentUID();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: SafeArea(
        child: Drawer(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.1,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: Size(150, 40)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileInfo()),
                    );
                  },
                  child: Text("Profile Info")),
              SizedBox(
                height: size.height * 0.02,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: Size(150, 40)),
                  onPressed: () => FirebaseHelpers().signOut(context),
                  child: Text("Logout"))
            ],
          ),
        ) // Populate the Drawer in the next step.
            ),
      ),
      appBar: AppBar(
        title: Text("${getCurrentUser!.displayName}"),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AddPost()),
            );
          },
          child: Icon(Icons.add)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('uid', isEqualTo: getCurrentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isNotEmpty) {
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Card(
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
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Spacer(),
                          //IconButton(onPressed: () {}, icon: Icon(Icons.edit))
                        ],
                      ),
                      SizedBox(
                        height: size.height * 0.015,
                      ),
                      Text('${data['productName']}'),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Text('Price  BDT${data['productPrice']}'),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Text('About : ${data['details']}'),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Text('Auction last date : ${data['endTime']}'),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: ClipRRect(
                            child: Image.network(
                          '${data['image']}',
                          fit: BoxFit.cover,
                        )),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          } else {
            return Center(child: Text("No post"));
          }
        },
      ),
    );
  }
}
