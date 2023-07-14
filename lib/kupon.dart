import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbase/kullaniciekrani.dart';
import 'package:flutter/material.dart';

class Kupon extends StatefulWidget {
  const Kupon({super.key});

  @override
  State<Kupon> createState() => _KuponState();
}

class _KuponState extends State<Kupon> {
  final indirim = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextField(
            controller: indirim,
          ),
          ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection('Kupon')
                    .doc('kupon')
                    .update({'tl': int.tryParse(indirim.text)!});    
              },
              child: Text("indirim yap"))
        ],
      ),
    );
  }
}
