import 'package:fbase/kullaniciekrani.dart';
import 'package:fbase/table.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'kullanicigiris.dart';

Map<int, String> selectedTables = {};

class UserPage extends StatelessWidget {
  const UserPage({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<CafeTable> tables = [];
  int number = 0;
  TextEditingController numberController = TextEditingController();
  bool filterBySocket = false;
  bool filterByWindow = false;
  bool filterByAvailable = false;
  var chairStatusList = [];

  @override
  void initState() {
    super.initState();
    getDocs();
  }

  Future<void> getDocs() async {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection('Masalar').get();

    for (int i =1; i <= querySnapshot.docs.length; i++) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Masalar')
          .doc("Masa $i")
          .get();
      bool window = snapshot['window'];
      bool socket = snapshot['socket'];
      List<bool> chairStatusList = snapshot['chairStatusList'].cast<bool>();
      _makeTableFromDataBase(socket, window, chairStatusList);
    }

    setState(() {
      number = querySnapshot.docs.length;
    });
  }




  void _makeTableFromDataBase(
      bool socket, bool window, List<bool> chairStatusList) {
    CafeTable tempTable = CafeTable();
    tempTable.socket = socket;
    tempTable.window = window;
    tempTable.chairStatusList = chairStatusList;
    tempTable.chair.count = chairStatusList.length;
    tables.add(tempTable);

  }



  Stream<QuerySnapshot> getFilteredDocuments(String filter) {
    return FirebaseFirestore.instance
        .collection('Masalar')
        .where(filter, isEqualTo: true)
        .snapshots();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text(
          'Number of Tables: $number',
          style: const TextStyle(fontSize: 20),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Wrap(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          filterBySocket = !filterBySocket;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: filterBySocket ? Colors.green : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: Text("Socket"),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          filterByWindow = !filterByWindow;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: filterByWindow ? Colors.green : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: Text("Window"),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          filterByAvailable = !filterByAvailable;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: filterByAvailable ? Colors.green : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        child: Text("Available"),
                      ),
                    ),

                  ],
                ),
                Wrap(
                  children: tables
                      .where((table) =>
                  (!filterBySocket || table.socket == filterBySocket) &&
                      (!filterByWindow || table.window == filterByWindow) &&
                      (!filterByAvailable || table.chairStatusList.contains(false) == filterByAvailable)
                  )
                      .map((table) => CardView(
                    table: table,
                    index: tables.indexOf(table) + 1,
                  ))
                      .toList(),
                ),



              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CardView extends StatelessWidget {
  const CardView({
    super.key,
    required this.table,
    required this.index,
  });

  final CafeTable table;
  final int index;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TablePage(
              table: table,
              index: index,
            ),
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: 100,
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.table_restaurant,
              color: Colors.black,
              size: 50,
            ),
            const SizedBox(height: 5),
            Text(
              index.toString(),
              style: const TextStyle(color: Colors.black, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

class TablePage extends StatefulWidget {
  const TablePage({
    Key? key,
    required this.table,
    required this.index,
  }) : super(key: key);

  final CafeTable table;
  final int index;
  @override
  _TablePageState createState() => _TablePageState();
}

class _TablePageState extends State<TablePage> {
  TextEditingController chairCountController = TextEditingController();
  int chairCount = 0;
  @override
  void initState() {
    super.initState();
    chairCount = widget.table.chair.count;
    chairCountController.text = chairCount.toString();
    getDocs();
  }

  Future<void> getDocs() async {
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('Masalar')
        .doc('Masa ${widget.index}')
        .get();

    if (documentSnapshot.exists) {
      var tempTable = documentSnapshot.data() as Map<String, dynamic>;
      setState(() {
        widget.table.window = tempTable['window'];
        widget.table.socket = tempTable['socket'];
        widget.table.chairStatusList =
            List<bool>.from(tempTable['chairStatusList']);
      });
    }
  }

  @override
  void dispose() {
    chairCountController.dispose();
    super.dispose();
  }

  void _toggleChairStatus(int chairIndex) async {
    setState(() {
      widget.table.chairStatusList[chairIndex] =
          !widget.table.chairStatusList[chairIndex];
    });

    // Firestore veritabanını güncelle
    await updateChairStatus(
        widget.index, chairIndex, widget.table.chairStatusList);
  }

  Future<void> updateChairStatus(
      int tableIndex, int chairIndex, List<bool> chairStatusList) async {
    final tableReference = FirebaseFirestore.instance
        .collection('Masalar')
        .doc('Masa $tableIndex');

    await tableReference.update({
      'chairStatusList': chairStatusList,
    });
  }

  Future<String> takename() async {
    var name;
    await FirebaseFirestore.instance
        .collection("Kartlar")
        .doc(girismail)
        .get()
        .then((value) {
      setState(() {
        name = value.data()!['isim'];
      });
    });
    return name;
  }

  int temp = 0;
  void showAlertDialog(int index) {
    takename().then((name) {
      FirebaseFirestore.instance
          .collection('Cuzdan')
          .doc(name)
          .get()
          .then((value) {
        setState(() {
          temp = value.data()!['para'];
        });
      });
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Reservation'),
              content: const Text('Reserve this table for 35₺'),
              actions: [
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      if (temp - 35 >= 0) {
                        temp = temp - 35;
                        selectedTables[selectedTableCount] =
                            "Masa ${widget.index}";
                        FirebaseFirestore.instance
                            .collection('Cuzdan')
                            .doc(name)
                            .update({'para': temp});
                        _toggleChairStatus(index);
                        selectedTableCount++;
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("insufficient money"),
                        ));
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Approve')),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Decline',
                    )),
              ],
            );
          });
    });
  }

  void updateSocketValue(int tableIndex, bool socketValue) async {
    final tableReference = FirebaseFirestore.instance
        .collection('Masalar')
        .doc('Masa $tableIndex');

    await tableReference.update({'socket': socketValue});
  }

  void updateWindowValue(int tableIndex, bool windowValue) async {
    final tableReference = FirebaseFirestore.instance
        .collection('Masalar')
        .doc('Masa $tableIndex');

    await tableReference.update({'window': windowValue});
  }

  void updateFullValue(int tableIndex, bool fullValue) async {
    final tableReference = FirebaseFirestore.instance
        .collection('Masalar')
        .doc('Masa $tableIndex');

    await tableReference.update({'full': fullValue});
  }

  void updateChairStatusList(int tableIndex, List<bool> chairStatusList) async {
    final tableReference = FirebaseFirestore.instance
        .collection('Masalar')
        .doc('Masa $tableIndex');

    await tableReference.update({'chairStatusList': chairStatusList});
  }

  void updateChairCount(int tableIndex, int newCount) async {
    final tableReference = FirebaseFirestore.instance
        .collection('Masalar')
        .doc('Masa $tableIndex');

    final chairStatusList = List<bool>.filled(newCount, false);

    await tableReference.update({
      'chairStatusList': chairStatusList,
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> chairIcons = List.generate(
      widget.table.chair.count,
      (index) => GestureDetector(
        onTap: () {
          if (widget.table.chairStatusList[index] == false) {
            showAlertDialog(index);
          }
        },
        child: Icon(
          widget.table.chairStatusList[index]
              ? Icons.chair_alt
              : Icons.chair_alt,
          color:
              widget.table.chairStatusList[index] ? Colors.red : Colors.green,
          size: 50,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Table ${widget.index}"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Socket: ",
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    widget.table.socket ? Icons.check : Icons.close,
                    color: widget.table.socket ? Colors.green : Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Window: ",
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(width: 10),
                  Icon(
                    widget.table.window ? Icons.check : Icons.close,
                    color: widget.table.window ? Colors.green : Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Chairs: ",
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    widget.table.chair.count.toString(),
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: (chairIcons.length / 6).ceil(),
                  itemBuilder: (context, index) {
                    int startIndex = index * 6;
                    int endIndex = (index * 6) + 6;
                    if (endIndex > chairIcons.length) {
                      endIndex = chairIcons.length;
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: chairIcons.sublist(startIndex, endIndex),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
