import 'package:fbase/user_screen.dart';
import 'package:fbase/logging_in/sign_up.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:lottie/src/lottie.dart';

String girismail = '';

class UserLogin extends StatefulWidget {
  const UserLogin({super.key});

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  void control() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: _email.text.trim(),
      password: _password.text.trim(),
    )
        .then((userCredential) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => UserLogged(email: _email.text.trim())));
    }).catchError((error) {
      // Handle login errors here
      String errorMessage = "An error occurred. Please check your email and password.";

      if (error is FirebaseAuthException) {
        if (error.code == 'user-not-found') {
          errorMessage = "No user found with this email.";
        } else if (error.code == 'wrong-password') {
          errorMessage = "Wrong password. Please try again.";
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage),
      ));
    });
    girismail = _email.text.trim();
  }

  void uselessFunc(){
    return;
}

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        IconButton(
          splashRadius: 50,
          iconSize: 70,
          icon: Lottie.asset(Icons8.book, height: 70, fit: BoxFit.fitHeight),
          onPressed: null,
        ),
        const SizedBox(height:25),

        TFdesign(alanadi: "email", onTap: uselessFunc, degisken: _email),
        TFdesign(alanadi: "password", onTap: uselessFunc, degisken: _password),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
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
                  color: Colors.green, // Background color
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Color(int.parse("0xFFF4F2DE")), // Change the border color here
                    width: 5, // Set the border width
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color(int.parse("0xFFF4F2DE")).withOpacity(0.5), // Shadow color
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
    );
  }

}