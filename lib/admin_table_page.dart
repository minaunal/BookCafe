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
        .doc(currentCafe)
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
                    .pop(); // İptal düğmesine basılınca dialog kapatılır
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.onDelete(); // onDelete işlevini çağırarak masayı sil
                Navigator.of(context)
                    .pop(); // Sil düğmesine basılınca dialog kapatılır
                Navigator.of(context).pop(); // TablePage sayfasına geri dönülür
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
        .doc(currentCafe)
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
        .doc(currentCafe)
        .collection('Masalar')
        .doc('Masa $tableIndex');

    await tableReference.update({'socket': socketValue});
  }

  void updateWindowValue(int tableIndex, bool windowValue) async {
    final tableReference = FirebaseFirestore.instance
        .collection('cafes')
        .doc(currentCafe)
        .collection('Masalar')
        .doc('Masa $tableIndex');

    await tableReference.update({'window': windowValue});
  }

  void updateFullValue(int tableIndex, bool fullValue) async {
    final tableReference = FirebaseFirestore.instance
        .collection('cafes')
        .doc(currentCafe)
        .collection('Masalar')
        .doc('Masa $tableIndex');

    await tableReference.update({'full': fullValue});
  }

  void updateChairStatusList(int tableIndex, List<bool> chairStatusList) async {
    final tableReference = FirebaseFirestore.instance
        .collection('cafes')
        .doc(currentCafe)
        .collection('Masalar')
        .doc('Masa $tableIndex');

    await tableReference.update({'chairStatusList': chairStatusList});
  }

  void updateChairCount(int tableIndex, int newCount) async {
    final tableReference = FirebaseFirestore.instance
        .collection('cafes')
        .doc(currentCafe)
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
      appBar: AppBar(
        backgroundColor: Colors.black,
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
                  const Text(
                    "Socket: ",
                    style: TextStyle(fontSize: 15),
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
                  const Text(
                    "Window: ",
                    style: TextStyle(fontSize: 15),
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
                  const Text(
                    "Full: ",
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(width: 10),
                  Switch(
                    value: widget.table.full,
                    onChanged: (bool value) {
                      updateFullValue(widget.index, value);
                      setState(() {
                        widget.table.full = value;
                        // Doluluk durumuna göre koltukları güncelle
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