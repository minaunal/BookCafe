import 'package:fbase/kullaniciekrani.dart';
import 'package:fbase/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:lottie/src/lottie.dart';

String girismail = '';

class KullaniciGiris extends StatefulWidget {
  const KullaniciGiris({super.key});

  @override
  State<KullaniciGiris> createState() => _KullaniciGirisState();
}

class _KullaniciGirisState extends State<KullaniciGiris> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  void GirisYap() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: _email.text.trim(),
      password: _password.text.trim(),
    )
        .then((userCredential) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => Kullanici(email: _email.text.trim())));
    });
    girismail = _email.text.trim();

  }

  void func() {
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
                splashRadius: 50,
                iconSize: 100,
                icon: Lottie.asset(Icons8.book,
                    height: 70, fit: BoxFit.fitHeight),
                onPressed: null),
            TFdesign(alanadi: "email", onTap: func, degisken: _email),
            TFdesign(alanadi: "password", onTap: func, degisken: _password),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              onPressed: () {
                GirisYap();
              },
              child: Text("Log in"),
            ),
          ],
        ),
      ),
    );
  }
}