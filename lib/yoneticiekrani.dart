import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbase/kupon.dart';
import 'package:fbase/moderator.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class Yonetici extends StatefulWidget {
  @override
  _YoneticiState createState() => _YoneticiState();
}

class _YoneticiState extends State<Yonetici> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Masa(),
    doluluk(),
    Kupon(),
    Income(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your App Name'),
      ),
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
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.table_restaurant_rounded),
            label: 'Tables',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_outlined),
            label: 'Occupancy',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_outlined),
            label: 'Coupon',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money_rounded),
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
    return Moderator();
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

  int trueCount = 0;
  int falseCount = 0;
  @override
  void initState() {
    super.initState();
    countTrue();
  }

  void countTrue() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('Masalar').get();

    snapshot.docs.forEach((doc) {
      List<bool> colors = List<bool>.from(doc['chairStatusList']);
      trueCount += colors.where((color) => color == true).length;
      falseCount += colors.where((color) => color == false).length;
      
    });

    setState(() {
      this.trueCount = trueCount;
      this.falseCount = falseCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    dataMap["full"] = trueCount.toDouble();
    dataMap["empty"] = falseCount.toDouble();
    return PieChart(
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
        .collection('Gelir')
        .doc('gelir')
        .get();

    setState(() {
      data = snapshot['tl'];
    });
  }
  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      body: Text(data.toString()),
    );
  }
}
