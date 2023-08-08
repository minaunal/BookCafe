import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbase/admin/discount.dart';
import 'package:fbase/main.dart';
import 'package:fbase/admin/moderator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:lottie/lottie.dart';

class Yonetici extends StatefulWidget {
  final email;

  const Yonetici({super.key, required this.email});


  @override
  _YoneticiState createState() => _YoneticiState();
}

class _YoneticiState extends State<Yonetici> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Masa(),
    doluluk(),
    Kupon(),
    Income(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        unselectedLabelStyle:
            const TextStyle(color: Colors.white, fontSize: 14),
        backgroundColor: const Color(0xFF084A76),
        fixedColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.table_restaurant_rounded,color: Color(0xFFFF7800),),
            label: 'Tables',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined,color: Color(0xFF2EA84A),),
            label: 'Occupancy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_outlined,color: Color(0xFFDA1E60),),
            label: 'Coupon',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_rounded,color: Color(0xFF182B6A),),
            label: 'Income',
          ),
        ],
      ),
    );
  }
}

class Masa extends StatefulWidget {
  const Masa({super.key});

  @override
  State<Masa> createState() => _MasaState();
}

class _MasaState extends State<Masa> {
  @override
  Widget build(BuildContext context) {
    return const Moderator();
  }
}

class doluluk extends StatefulWidget {
  doluluk({super.key});

  @override
  State<doluluk> createState() => _dolulukState();
}

class _dolulukState extends State<doluluk> {
  Map<String, double> dataMap = {
    "full": 20,
    "empty": 180,
  };

  List<Color> colorList = [
    const Color(0xff1fde25),
    const Color(0xff000000),
  ];
  String occupancyMessage = "";

  int trueCount = 0;
  int falseCount = 0;
  @override
  void initState() {
    super.initState();
    countTrue();
  }

  void countTrue() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('cafes').doc(currentCafe).collection('Masalar').get();

    snapshot.docs.forEach((doc) {
      List<bool> colors = List<bool>.from(doc['chairStatusList']);
      trueCount += colors.where((color) => color == true).length;
      falseCount += colors.where((color) => color == false).length;
    });

    if (trueCount == 0 && falseCount == 0) {
      setState(() {
        occupancyMessage = "No chair available. Try to add a table.";
      });
    } else {
      setState(() {
        occupancyMessage = "Instant occupancy in $currentCafe.";
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    dataMap["full"] = trueCount.toDouble();
    dataMap["empty"] = falseCount.toDouble();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(occupancyMessage, style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),),
        SizedBox(height: 15,),
        Divider(thickness: 3,),
         SizedBox(height: 15,),
     PieChart(
      dataMap: dataMap,
      colorList: colorList,
      chartRadius: MediaQuery.of(context).size.width / 2,
      centerText: "Occupancy",
      chartValuesOptions: ChartValuesOptions(
        showChartValues: true,
        showChartValuesOutside: true,
        showChartValuesInPercentage: true,
        chartValueStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      legendOptions: LegendOptions(
        showLegends: true,
        legendShape: BoxShape.circle,
        legendTextStyle: TextStyle(
          fontSize: 15, // Veri isimlerinin boyutunu burada ayarlayabilirsiniz
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ),
     SizedBox(height: 15,),
    Divider(thickness: 3,),
     SizedBox(height: 15,),
      ],
    );
  }
}

class Income extends StatefulWidget {
  const Income({super.key});

  @override
  State<Income> createState() => _IncomeState();
}

class _IncomeState extends State<Income> {
  dynamic data;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("cafes")
        .doc(currentCafe)
        .collection('Gelir')
        .doc('gelir')
        .get();

    if (snapshot.exists) {
      setState(() {
        data = snapshot['tl'];
      });
    } else {
      setState(() {
        data = 0; // Set data to 0 or any default value you prefer when the document doesn't exist
      });
    }
  }


final indirim = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
      padding: EdgeInsets.all(30.0), // Girinti ayarı
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
              splashRadius: 50,
              iconSize: 80,
              icon: Lottie.asset(Icons8.book, height: 80, fit: BoxFit.fitHeight),
              onPressed: null,
            ),
          Divider(thickness: 3,),
          SizedBox(height: 20,),
          Row(
            children:<Widget>[
         Icon(
                Icons.attach_money_rounded,
                size: 32,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                "Your income is : ${data.toString()} tl",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}