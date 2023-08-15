import 'package:fbase/main.dart';
import 'package:fbase/table.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TablePage extends StatefulWidget {
  const TablePage({
    Key? key,
    required this.table,
    required this.index,
    required this.onDelete,
  }) : super(key: key);

  final CafeTable table;
  final int index;
  final Function() onDelete;

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
        .collection('cafes')
        .doc(currentCafeName)
        .collection('Masalar')
        .doc('Masa ${widget.index}')
        .get();

    if (documentSnapshot.exists) {
      var tempTable = documentSnapshot.data() as Map<String, dynamic>;
      setState(() {
        widget.table.window = tempTable['window'];
        widget.table.socket = tempTable['socket'];
        widget.table.chairStatusList = List<bool>.from(tempTable['chairStatusList']);
      });
    }
  }

  @override
  void dispose() {
    chairCountController.dispose();
    super.dispose();
  }

  void _deleteTable() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete the table'),
          content: const Text('Are you sure you want to delete the table?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.onDelete();
                Navigator.of(context)
                    .pop();
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }



  Future<void> updateChairStatus(int tableIndex, int chairIndex, List<bool> chairStatusList) async {
    final tableReference = FirebaseFirestore.instance
        .collection('cafes')
        .doc(currentCafeName)
        .collection('Masalar')
        .doc('Masa $tableIndex');

    await tableReference.update({
      'chairStatusList': chairStatusList,
    });
  }

  int temp = 0;

  void _updateChairCount(int newCount) {
    setState(() {
      chairCount = newCount;
      widget.table.chair.count = newCount;
      widget.table.chairStatusList = List<bool>.filled(newCount, false);
    });
  }

  void updateSocketValue(int tableIndex, bool socketValue) async {
    final tableReference = FirebaseFirestore.instance
        .collection('cafes')
        .doc(currentCafeName)
        .collection('Masalar')
        .doc('Masa $tableIndex');

    await tableReference.update({'socket': socketValue});
  }

  void updateWindowValue(int tableIndex, bool windowValue) async {
    final tableReference = FirebaseFirestore.instance
        .collection('cafes')
        .doc(currentCafeName)
        .collection('Masalar')
        .doc('Masa $tableIndex');

    await tableReference.update({'window': windowValue});
  }

  void updateFullValue(int tableIndex, bool fullValue) async {
    final tableReference = FirebaseFirestore.instance
        .collection('cafes')
        .doc(currentCafeName)
        .collection('Masalar')
        .doc('Masa $tableIndex');

    await tableReference.update({'full': fullValue});
  }

  void updateChairStatusList(int tableIndex, List<bool> chairStatusList) async {
    final tableReference = FirebaseFirestore.instance
        .collection('cafes')
        .doc(currentCafeName)
        .collection('Masalar')
        .doc('Masa $tableIndex');

    await tableReference.update({'chairStatusList': chairStatusList});
  }

  void updateChairCount(int tableIndex, int newCount) async {
    final tableReference = FirebaseFirestore.instance
        .collection('cafes')
        .doc(currentCafeName)
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
        onTap: null,
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
      backgroundColor: Color(int.parse("0xFFF4F2DE")),
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        centerTitle: true,
        title: Text("Table ${widget.index}"),
        actions: [
          IconButton(
            onPressed: _deleteTable,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black, // Set your desired border color
                        width: 2.0, // Set your desired border width
                      ),
                    ),
                    child: Icon(
                      Icons.electrical_services_outlined,
                      color: Colors.black, // Set your desired icon color
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Switch(
                    value: widget.table.socket,
                    onChanged: (bool value) {
                      updateSocketValue(widget.index, value);
                      setState(() {
                        widget.table.socket = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black, // Set your desired border color
                        width: 2.0, // Set your desired border width
                      ),
                    ),
                    child: Icon(
                      Icons.window_outlined,
                      color: Colors.black, // Set your desired icon color
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Switch(
                    value: widget.table.window,
                    onChanged: (bool value) {
                      updateWindowValue(widget.index, value);
                      setState(() {
                        widget.table.window = value;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black, // Set your desired border color
                        width: 2.0, // Set your desired border width
                      ),
                    ),
                    child: Image.asset(
                      'images/icons/available.png',
                      width: 35,
                      height: 35,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Switch(
                    value: widget.table.full,
                    onChanged: (bool value) {
                      updateFullValue(widget.index, value);
                      setState(() {
                        widget.table.full = value;
                        for (int i = 0;
                            i < widget.table.chairStatusList.length;
                            i++) {
                          widget.table.chairStatusList[i] = value;
                        }
                        updateChairStatusList(
                            widget.index, widget.table.chairStatusList);
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Chair count: ",
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 50,
                    child: TextField(
                      controller: chairCountController,
                      onChanged: (value) {
                        int newCount = int.tryParse(value) ?? chairCount;
                        _updateChairCount(newCount);
                        updateChairCount(widget.index, newCount);
                      },
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 10.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
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