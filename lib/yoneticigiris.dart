import 'package:fbase/kullaniciekrani.dart';
import 'package:fbase/yoneticiekrani.dart';
import 'package:flutter/material.dart';

class YoneticiGiris extends StatefulWidget {
  const YoneticiGiris({super.key});

  @override
  State<YoneticiGiris> createState() => _YoneticiGirisState();
}

class _YoneticiGirisState extends State<YoneticiGiris> {
  TextEditingController name = TextEditingController();
  TextEditingController password = TextEditingController();

  void control() {
    if (name.text == "admin" && password.text == "12345") {
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
