import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fbase/order.dart';
import 'package:fbase/user_screen.dart';
import 'package:flutter/material.dart';

class Sepet extends StatefulWidget {
  final isim;
  final foto;
  final fiyat;
  final docname;
  Sepet({Key? mykey, this.isim, this.foto, this.fiyat, this.docname})
      : super(key: mykey);
  @override
  State<Sepet> createState() => _SepetState();
}

class _SepetState extends State<Sepet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        foregroundColor: Colors.black,
        title: Text('My Cart'),
      ),
      body: Makecards(
          isim: widget.isim,
          foto: widget.foto,
          fiyat: widget.fiyat,
          docname: widget.docname),
    );
  }
}

class Makecards extends StatefulWidget {
  final isim;
  final foto;
  var fiyat;
  final docname;
  Makecards({Key? mykey, this.isim, this.foto, this.fiyat, this.docname})
      : super(key: mykey);

  @override
  State<Makecards> createState() => _MakecardsState();
}

int? temp = 0;

class _MakecardsState extends State<Makecards> {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('Cuzdan')
        .doc(widget.docname)
        .get()
        .then((value) {
      setState(() {
        temp = value.data()!['para'];
      });
    });
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: 24.0 / 11.0,
              child: Image.asset(widget.foto),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.isim,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.fiyat.toString() + "TL",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        if (temp! >= int.parse(widget.fiyat.toString())) {
                          temp = (temp! - int.parse(widget.fiyat.toString()));

                          FirebaseFirestore.instance
                              .collection('Cuzdan')
                              .doc(widget.docname)
                              .update({'para': temp});
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Hazir()));

                           FirebaseFirestore.instance
                          .collection('Gelir')
                          .doc('gelir')
                          .get()
                          .then((value) {
                        FirebaseFirestore.instance
                            .collection('Gelir')
                            .doc('gelir')
                            .update(({'tl': int.parse(widget.fiyat.toString()) + value.data()!['tl']}));
                      });
                        } else {
                          final snackBar = SnackBar(
                            content: Text("insufficient funds"),
                            duration: const Duration(seconds: 2),
                            action: SnackBarAction(
                              label: 'Go back to menu.',
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        CafeMenu(docname: widget.docname)));
                              },
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      icon: Icon(
                        Icons.check_circle_sharp,
                        color: Colors.lightGreenAccent.shade700,
                      ),
                      label: Text('approve'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => CafeMenu()));
                      },
                      icon: Icon(
                        Icons.cancel_outlined,
                        color: Colors.red,
                      ),
                      label: Text('cancel'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
