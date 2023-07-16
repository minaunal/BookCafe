import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:lottie/lottie.dart';

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
      body: Padding(
        padding: EdgeInsets.all(30.0), // Girinti ayarı
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              splashRadius: 50,
              iconSize: 80,
              icon:
                  Lottie.asset(Icons8.book, height: 80, fit: BoxFit.fitHeight),
              onPressed: null,
            ),
            Divider(
              thickness: 3,
            ),
            SizedBox(height: 25,),
            Text(
              "set the discount percentage",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 20,),
            Row(
              children: <Widget>[
                Icon(
                  Icons.discount_outlined,
                  color: Colors.black,
                  weight: 20.0,
                  size: 25,
                ),
                SizedBox(
                  width: 30,
                ),
                Container(
                  width: 40, // Genişlik ayarı
                  child: TextField(
                    style: TextStyle(fontWeight: FontWeight.bold),
                    controller: indirim,
                    decoration: InputDecoration(
                      hintText: '%',
                      hintStyle: TextStyle(fontSize: 20.0),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                GestureDetector(
                  onTap: () {
                    FirebaseFirestore.instance
                        .collection('Kupon')
                        .doc('kupon')
                        .update({'tl': int.tryParse(indirim.text)!});
                    final snackBar = SnackBar(
                      content: Container(
                        width: 150,
                        height: 50,
                        child: Center(
                          child: Text(
                            'The discount coupon has setted',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: Icon(
                    Icons.check,
                    color: Colors.black,
                    weight: 20.0,
                    size: 25,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
