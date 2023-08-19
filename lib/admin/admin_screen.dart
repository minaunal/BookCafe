
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbase/admin/discount.dart';
import 'package:fbase/main.dart';
import 'package:fbase/admin/moderator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:lottie/lottie.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../changepw.dart';

class Yonetici extends StatefulWidget {
  final email;

  const Yonetici({super.key, required this.email});


  @override
  _YoneticiState createState() => _YoneticiState();
}

class _YoneticiState extends State<Yonetici> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const Table(),
    CafeModerator(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(int.parse("0xFFF4F2DE")),

      body: _pages[_currentIndex],
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            height: 1,
            color: Colors.grey,
            thickness: 1,
          ),
          BottomNavigationBar(
            unselectedLabelStyle: const TextStyle(
              color: Colors.indigoAccent,
              fontSize: 15,
            ),
            backgroundColor: Color(int.parse("0xFFF4F2DE")),
            unselectedItemColor: Colors.indigoAccent,
            currentIndex: _currentIndex,
            onTap: (int index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.table_restaurant, color: Colors.indigoAccent),
                label: 'Tables',
              ),

              BottomNavigationBarItem(
                icon: Icon(Icons.admin_panel_settings, color: Color(0xFF2EA84A)),
                label: 'Account',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Table extends StatefulWidget {
  const Table({super.key});

  @override
  State<Table> createState() => _TableState();
}

class _TableState extends State<Table> {
  @override
  Widget build(BuildContext context) {
    return const Moderator();
  }
}

class Occupancy extends StatefulWidget {
  Occupancy({super.key});

  @override
  State<Occupancy> createState() => _OccupancyState();
}

class _OccupancyState extends State<Occupancy> {
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
        await FirebaseFirestore.instance.collection('cafes').doc(currentCafeName).collection('Masalar').get();

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
        occupancyMessage = "Instant occupancy in $currentCafeName.";
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    dataMap["full"] = trueCount.toDouble();
    dataMap["empty"] = falseCount.toDouble();
    return Scaffold(
      backgroundColor: Color(int.parse("0xFFF4F2DE")),

      body: Column(
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
      ],),
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
        .doc(currentCafeName)
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
      backgroundColor: Color(int.parse("0xFFF4F2DE")),
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


class CafeModerator extends StatefulWidget {
  final email;

  CafeModerator({Key? mykey, this.email}) : super(key: mykey);

  @override
  State<CafeModerator> createState() => _CafeModeratorState();
}


class _CafeModeratorState extends State<CafeModerator> {

  Future<void> uploadImage() async {
    final picker = ImagePicker();

    XFile? imageFile = await picker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      File file = File(imageFile.path);

      firebase_storage.Reference storageReference = firebase_storage.FirebaseStorage.instance.ref().child('cafes').child(currentCafeName).child("icon.jpg");
      firebase_storage.UploadTask uploadTask = storageReference.putFile(file);

      await uploadTask.whenComplete(() {
        print('Image uploaded');
      }).catchError((error) {
        print('Error uploading image: $error');
        print(storageReference);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          Text(currentCafeName,
            style: const TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 25,
            ),
          ),

          IconButton(
            splashRadius: 50,
            iconSize: 80,
            icon: Lottie.asset(Icons8.book, height: 80, fit: BoxFit.fitHeight),
            onPressed: null,
          ),
          const Divider(
            thickness: 2,
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => change(email: widget.email)));
                },
                child: const Icon(
                  Icons.key,
                  color: Colors.black,
                  size: 32,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              const Text(
                'Change password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),

          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Coupon()));
                },
                child: const Icon(
                  Icons.discount,
                  color: Colors.black,
                  size: 32,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              const Text(
                'Make a discount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Income()));
                },
                child: const Icon(
                  Icons.attach_money,
                  color: Colors.black,
                  size: 32,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              const Text(
                'Check your income',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => Occupancy()));
                },
                child: const Icon(
                  Icons.percent_outlined,
                  color: Colors.black,
                  size: 32,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              const Text(
                'Check cafe occupancy',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),const SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  await uploadImage();
                },
                child: Container(
                  padding: const EdgeInsets.all(0),
                  child: const Icon(
                    Icons.image_outlined,
                    color: Colors.black,
                    size: 32,
                  ),
                ),
              ),

              SizedBox(
                width: 20,
              ),
              Text(
                'Change image of cafe',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();

                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const Iskele()));

                },
                child: Icon(
                  Icons.logout_outlined,
                  color: Colors.black,
                  size: 32,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                'Log out',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),


        ],
      ),
    );
  }
}
