import 'package:auction/providers/productprovider.dart';
import 'package:auction/views/auth/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

class FetchScreeen extends StatefulWidget {
  const FetchScreeen({super.key});

  @override
  State<FetchScreeen> createState() => _FetchScreeenState();
}

class _FetchScreeenState extends State<FetchScreeen> {
  @override
  void initState() {
    // TODO: implement initState

    Future.delayed(Duration(seconds: 3), (() {
      // final provider = Provider.of<ProductProvider>(context, listen: false);
      // provider.fetchData();

      Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) {
          return Register();
        },
      ));
    }));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
