import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbase/yoneticiekrani.dart';
import 'package:flutter/material.dart';
TextEditingController name = TextEditingController();

class YoneticiGiris extends StatefulWidget {
  const YoneticiGiris({super.key});

  @override
  State<YoneticiGiris> createState() => _YoneticiGirisState();
}

class _YoneticiGirisState extends State<YoneticiGiris> {

  TextEditingController password = TextEditingController();
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  control() {

  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(controller: t1),
            TextField(controller: t2),
            ElevatedButton(
                onPressed: () {
                  FirebaseFirestore.instance
                      .collection('Yoneticiler')
                      .doc(t1.text)
                      .set({'isim':t1.text,'sifre': t2.text});
                },
                child: Text("Kullanıcı adı ve Sifre belirle.")),
            TextField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.blueGrey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  hintText: "name",
                  hintStyle: TextStyle(color: Colors.blueGrey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              controller: name,
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.blueGrey,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                  ),
                  hintText: "password",
                  hintStyle: TextStyle(color: Colors.blueGrey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              controller: password,
              obscureText: true,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              onPressed:(){ FirebaseFirestore.instance
                  .collection('Yoneticiler')
                  .doc(name.text)
                  .get()
                  .then((value) {
                String a = value.data()?['isim'];
                String b = value.data()?['sifre'];

                if (a == name.text && b == password.text) {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => Yonetici()));
                } else {
                  final snackBar = SnackBar(
                    content: Container(
                      width: 150,
                      height: 50,
                      child: Center(
                        child: Text(
                          'Unvalid name or password.',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    action: SnackBarAction(
                      label: 'TRY AGAIN',
                      onPressed: () {
                        name.clear();
                        password.clear();
                      },
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              });},
              child: Text("Log in"),
            ),
          ],
        ),
      ),
    );
  }
}

class userdesign extends StatefulWidget {
  final alanadi;
  const userdesign({Key? mykey, this.alanadi}) : super(key: mykey);

  @override
  State<userdesign> createState() => _userdesignState();
}

class _userdesignState extends State<userdesign> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          TextField(
            style: TextStyle(color: Colors.black),
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.blueGrey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colors.black,
                ),
              ),
              hintText: widget.alanadi,
              hintStyle: TextStyle(color: Colors.blueGrey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
