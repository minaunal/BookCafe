import 'package:fbase/kullaniciekrani.dart';
import 'package:fbase/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
          builder: (context) => Kullanici(email: "mina@ddd.com")));
    });
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
