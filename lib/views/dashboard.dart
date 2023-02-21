import 'package:auction/model/item.dart';
import 'package:auction/providers/bitprovider.dart';
import 'package:auction/widget/textwidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../model/productmodel.dart';
import '../providers/productprovider.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  static const routename = '/Dashboard';

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  //List<ProductModel> productList=[];

  List<Map<String, dynamic>> dataFlutter = [
    {'year': '2020', 'percent': '3'},
    {'year': '2021', 'percent': '4'},
    {'year': '2022', 'percent': '9'},
    {'year': '2023', 'percent': '3'},
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var productProvider = Provider.of<ProductProvider>(context);
    var bidProvider = Provider.of<OrderProvider>(context);
    List<Item> confirmbidList = bidProvider.orderConfirmlist;

    List<ProductModel> productList = productProvider.productList;

    int totalvalue = 0;

    for (var i = 0; i < confirmbidList.length; i++) {
      setState(() {
        totalvalue += confirmbidList[i].price * confirmbidList[i].quantity;
      });
    }

    List year = [];

    if (confirmbidList.isNotEmpty) {
      for (var i = 0; i < confirmbidList.length; i++) {
        String yyyy = '2020';
        setState(() {
          yyyy = confirmbidList[i].time.substring(6, 10);
          year.add(yyyy);
        });
      }
    }

    for (var i = 0; i < year.length; i++) {
      setState(() {
        //dataFlutter[i]['year'] = year[i].toString();
      });
    }

    return Scaffold(
        body: Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.2,
            ),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('posts').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.data!.docs.isNotEmpty) {
                  return Text(
                      'total number of running bids : ${snapshot.data!.docs.length}');
                } else {
                  return Center(child: Text("load.."));
                }
              },
            ),
            SizedBox(
              height: 10,
            ),
            Text(confirmbidList.isNotEmpty
                ? 'completed bids : ${confirmbidList.length}'
                : 'First Bit now'),
            Text(confirmbidList.isNotEmpty
                ? 'completed bids : $totalvalue'
                : 'First Bit now'),
            Container(
              height: 200,
              width: double.infinity,
              child: DChartBar(
                data: [
                  {
                    'id': 'Bar',
                    'data': [
                      {
                        'domain': year[0] == null ? '2000' : '${year[0]}',
                        'measure': 3
                      },
                      {'domain': '2', 'measure': 4},
                      {'domain': '3', 'measure': 6},
                      {'domain': '4', 'measure': 0.3},
                    ],
                  },
                ],
                domainLabelPaddingToAxisLine: 16,
                axisLineTick: 2,
                axisLinePointTick: 2,
                axisLinePointWidth: 10,
                axisLineColor: Colors.green,
                measureLabelPaddingToAxisLine: 16,
                barColor: (barData, index, id) => Colors.green,
                showBarValue: true,
              ),
            )
          ],
        ),
      ),
    ));
  }
}
