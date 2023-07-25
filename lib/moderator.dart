import 'package:fbase/main.dart';
import 'package:fbase/table.dart';
import 'package:fbase/admin_table_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Moderator extends StatelessWidget {
  const Moderator({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: MainPage(),
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

  var chairStatusList = [];

  @override
  void initState() {
    super.initState();
    getDocs();
  }

  void addTable() {
    setState(() {
      tables.add(CafeTable());
      number++;
    });

    createTableDocument(number);
  }





  Future getDocs() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('cafes').doc(currentCafe).collection('Masalar').get();

    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var tempTable = querySnapshot.docs[i];
      bool window = tempTable['window'];
      bool socket = tempTable['socket'];
      List<bool> chairStatusList = tempTable['chairStatusList'].cast<bool>();
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

  void _makeTablesForFirebase(int masaSayisi) async {
    final collectionReference =
        FirebaseFirestore.instance.collection('cafes').doc(currentCafe).collection('Masalar');
    // Mevcut masaları sil
    final currentTables = await collectionReference.get();
    for (final doc in currentTables.docs) {
      await doc.reference.delete();
    }

    // Masa sayısı kadar yeni masalar oluştur
    for (int i = 1; i <= masaSayisi; i++) {
      final tableData = {
        'socket': false,
        'window': false,
        'full': false,
        'chairStatusList': [false, false, false, false],
      };
      await collectionReference.doc('Masa $i').set(tableData);
    }
  }

  void createTableDocument(int tableIndex) async {
    final tableData = {
      'chairStatusList': [false, false, false, false],
      'socket': false,
      'window': false,
    };

    await FirebaseFirestore.instance
        .collection('cafes').doc(currentCafe).collection('Masalar')
        .doc('Masa $tableIndex')
        .set(tableData);
  }

  void deleteTableDocument(int tableIndex) async {
    final tableReference = FirebaseFirestore.instance
        .collection('cafes')
        .doc(currentCafe)
        .collection('Masalar')
        .doc('Masa $tableIndex');

    await tableReference.delete();
  }

  void removeTable(CafeTable table) {
    setState(() {
      tables.remove(table);
    });
  }

  void _makeTables(int number) {
    setState(() {
      tables = [];
      for (int i = 0; i < number; i++) {
        tables.add(CafeTable());
      }
    });
  }

  void updateFirebaseTableStatus(String qrText) {
    // Split the text by space
    List<String> textParts = qrText.split(' ');

    // Check if the text has at least two parts (e.g., "Masa 1")
    if (textParts.length >= 2) {
      // Get the table number after the space
      String tableNumber = textParts[1];

      // Construct the full table ID in Firebase
      String fullTableId = 'Masa $tableNumber';

      // Get a reference to the table document in Firestore
      DocumentReference tableRef =
          FirebaseFirestore.instance.collection('cafes').doc(currentCafe).collection('Masalar').doc(fullTableId);

      // Update the 'full' field of the table document to true
      tableRef.update({'full': true}).then((_) {
        print('Table status updated successfully.');
      }).catchError((error) {
        print('Error updating table status: $error');
      });

      //UPDATE IN APP
    } else {
      print('Invalid QR code format.');
    }
  }

   
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  
           AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Row(
          children: [
            IconButton(
              padding: const EdgeInsets.all(16.0),
              onPressed: addTable,
              icon: const Icon(Icons.add_circle),
              iconSize: 35,
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  if (tables.isNotEmpty) {
                    tables.removeLast();
                    deleteTableDocument(number);
                    number--;
                  }
                });
              },
              icon: const Icon(Icons.remove_circle),
              iconSize: 35,
            ),
            IconButton(
              icon: const Icon(Icons.format_list_numbered_sharp),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('How many tables will there be? '),
                      content: TextFormField(
                        controller: numberController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: 'Table count',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              number = int.tryParse(numberController.text) ?? 0;
                              _makeTables(number);
                              _makeTablesForFirebase(number);
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text('Okey'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('İptal'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(width: 10),
            Text('Table Count: $number  ',
                style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
      
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Wrap(
              children: [
                for (int i = 0; i < tables.length; i++)
                  CardView(
                    table: tables[i],
                    index: i + 1,
                    onDelete: () {
                      removeTable(tables[i]);
                    },
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
    required this.onDelete,
  });

  final CafeTable table;
  final int index;
  final VoidCallback onDelete;

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
              onDelete: onDelete,
            ),
          ),
        );
      },
      child: Container(
        alignment: Alignment.center,
        color: Colors.white,
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