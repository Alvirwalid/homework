import 'package:auction/fetchscreen.dart';
import 'package:auction/providers/bitprovider.dart';
import 'package:auction/providers/productprovider.dart';
import 'package:auction/views/auth/register.dart';
import 'package:auction/views/auth/sign_in.dart';
import 'package:auction/views/dashboard.dart';
import 'package:auction/views/home.dart';
import 'package:auction/views/user/add_post.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: 'AIzaSyAkav3Amwv45KZmTBME3kVikHYgcAY1Apw',
          appId: '1:521501419338:android:de8b835ef8453130d8c3b3',
          messagingSenderId: '521501419338',
          projectId: 'auctionapp-cc0a4',
          authDomain: 'auctionapp-cc0a4.firebaseapp.com'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Provider.of<ProductProvider>(context).fetchData();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return ProductProvider();
        }),
        ChangeNotifierProvider(create: (context) {
          return OrderProvider();
        }),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: FetchScreeen(),
        getPages: [
          GetPage(
            name: SignIn.routename,
            page: () => SignIn(),
          ),
          GetPage(
            name: Home.routename,
            page: () => Home(),
          ),
          GetPage(
            name: AddPost.routename,
            page: () => AddPost(),
          ),
          GetPage(
            name: Register.routename,
            page: () => Register(),
          ),
          GetPage(
            name: Dashboard.routename,
            page: () => Dashboard(),
          )
        ],
      ),
    );
  }
}
