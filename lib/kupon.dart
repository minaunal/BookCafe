import 'package:fbase/kullaniciekrani.dart';
import 'package:flutter/material.dart';

class Kupon extends StatefulWidget {
  const Kupon({super.key});

  @override
  State<Kupon> createState() => _KuponState();
}

class _KuponState extends State<Kupon> {
  final indirim = TextEditingController();
  int? discount;
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
                  Discount = int.tryParse(indirim.text)!;
                   Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Cafe()));
                },
                child: Text("indirim yap"))
          ],
        ),
      
    );
  }
}
