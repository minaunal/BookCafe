import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbase/create_cafe.dart';
import 'package:fbase/logging_in/user_logging_in.dart';
import 'package:fbase/main.dart';
import 'package:fbase/user_screen.dart';
import 'package:fbase/admin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class YoneticiGiris extends StatefulWidget {
  const YoneticiGiris({super.key});

  @override
  State<YoneticiGiris> createState() => _YoneticiGirisState();
}

class _YoneticiGirisState extends State<YoneticiGiris> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  void control() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: _email.text.trim(),
      password: _password.text.trim(),
    )
        .then((userCredential) async {
      var snapshot = await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).get();
      var data = snapshot.data();

      if (data != null) {
        if (data['role'] == "admin") {
          // Admin doesn't have a cafe yet. Navigating to cafe creating page.
          if (data.containsKey('cafe')){
            currentCafe = data['cafe'];
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => Yonetici(email: _email.text.trim()),
            ));

          }
          else {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CafeCreationPage(userCredential.user!.uid),
            ));
          }
        } else {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => Kullanici(email: _email.text.trim()),
          ));
        }
      }
    });
    girismail = _email.text.trim();
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
                  hintText: "name",
                  hintStyle: TextStyle(color: Colors.blueGrey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              controller: _email,
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
              controller: _password,
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
              onPressed: control,
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