import 'package:fbase/main.dart';
import 'package:fbase/kullaniciekrani.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class Giris extends StatefulWidget {
  const Giris({super.key});

  @override
  State<Giris> createState() => _GirisState();
}

class _GirisState extends State<Giris> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  Future GirisYap() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: _email.text.trim(),
      password: _password.text.trim(),
    );
  
  }
  void func(){
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget> [
    TFdesign(alanadi: "email", onTap:func, degisken: _email),
    TFdesign(alanadi: "password",onTap: func, degisken: _password),
    ElevatedButton(onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Kullanici()));
          },
           child: Text("Giriş Yap"),),
      ],
      ),
      ),
    );
  }
}
