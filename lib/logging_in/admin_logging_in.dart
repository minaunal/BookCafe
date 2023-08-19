import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbase/admin/create_cafe.dart';
import 'package:fbase/logging_in/user_logging_in.dart';
import 'package:fbase/main.dart';
import 'package:fbase/user_screen.dart';
import 'package:fbase/admin/admin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:lottie/src/lottie.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
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
            currentCafeName = data['cafe'];
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
            builder: (context) => UserLogged(email: _email.text.trim()),
          ));
        }
      }
    }).catchError((error) {
      // Handle login errors here
      String errorMessage = "An error occurred. Please check your email and password.";

      if (error is FirebaseAuthException) {
        if (error.code == 'user-not-found') {
          errorMessage = "No manager found with this email.";
        } else if (error.code == 'wrong-password') {
          errorMessage = "Wrong password. Please try again.";
        }
      }

      // Show the error message using a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
    });
    girismail = _email.text.trim();
  }


  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        backgroundColor: Color(int.parse("0xFFF4F2DE")),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[


            const Text(
              "BookSmart Manager",
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 25,
              ),
            ),
            SizedBox(height:20),
            IconButton(
              splashRadius: 50,
              iconSize: 70,
              icon: Lottie.asset(Icons8.book, height: 70, fit: BoxFit.fitHeight),
              onPressed: null,
            ),
            SizedBox(height:25),
            TextField(
              style: const TextStyle(color: Colors.black),
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
                  hintText: "email",
                  hintStyle: TextStyle(color: Colors.blueGrey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  )),
              controller: _email,
            ),
            const SizedBox(
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
            SizedBox(height:25),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigoAccent,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(50.0),
                ),
              ),
              onPressed: () {
                control();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // Center the content horizontally
                mainAxisSize: MainAxisSize.min, // Use the minimum amount of space horizontally
                children: [
                  Container(
                    padding: const EdgeInsets.all(5.0), // Add padding to the icon container
                    decoration: BoxDecoration(
                      color: Colors.indigoAccent, // Background color
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.white, // Change the border color here
                        width: 5, // Set the border width
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5), // Shadow color
                          spreadRadius: 1, // Spread radius
                          blurRadius: 1, // Blur radius
                          //offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.login_outlined,
                      color: Colors.white,
                      size: 25, // Icon size
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Log in",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            )

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