import 'package:fbase/admin/create_cafe.dart';
import 'package:fbase/admin/admin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:lottie/lottie.dart';

import '../user_screen.dart';


class SignUpPage extends StatefulWidget {
  final String role; // Example parameter, you can add more as needed

  SignUpPage({required this.role});


  @override
  _SignUpPageState createState() => _SignUpPageState(role);
}

class _SignUpPageState extends State<SignUpPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  final _surname = TextEditingController();
  double _formProgress = 0;
  bool _isLoading = false;
  bool _isEmailAvailable = true;
  String role;
  _SignUpPageState(this.role);


  void _updateFormProgress() {
    var progress = 0.0;
    var controllers = [_email, _password, _name, _surname];

    for (var controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }
    setState(() {
      _formProgress = progress;
      if (_formProgress == 1) {
        _isLoading = true;
      }
    });
  }



  Future<void> _checkEmailAvailability() async {
    final email = _email.text.trim().toLowerCase();

    // Check if the email is already in use
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    setState(() {
      _isEmailAvailable = snapshot.docs.isEmpty;
    });
  }

  SignUpFirebase() {
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text, password: _password.text);
  }


  Future<void> _signUp() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final String email = _email.text.trim();
      final String password = _password.text;
      final String name = _name.text;
      final String surname = _surname.text;

      // Check if email or password is empty
      if (email.isEmpty || password.isEmpty || name.isEmpty || surname.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all fields.'),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Check email availability
      await _checkEmailAvailability();
      if (!_isEmailAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email is already in use.'),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Sign up with Firebase Authentication
      final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Create user in Firestore
        String uid = userCredential.user!.uid;
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'uid': uid,
          'email': email,
          'name': name,
          'surname': surname,
          'role': role, // Set the default role to student
        });

        // Navigate to home page or another appropriate page
        // For example:
          showDialog(
            context: context,
            builder: (context) => const AlertDialog(
              title: Text('Signed up!'),
              content: Text('Successfully signed up.\nReturning to the main screen.'),

            ),
          );

          // Biraz bekle ve sonra ana ekrana dön
          await Future.delayed(const Duration(seconds: 3));
          Navigator.pop(context);
          Navigator.pop(context);

      }
      setState(() {
        _isLoading = false; // Kayıt işlemi tamamlandığında isLoading durumunu false olarak güncelle
      });
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException and show appropriate error message
      // (e.g., email already in use, weak password, etc.)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'An error occurred.'),
          duration: const Duration(seconds: 5),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // Handle other errors
      print('Sign up error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    bool isAdmin = role == "admin";

    return Scaffold(
      appBar: AppBar(
        title: isAdmin ? Text('Manager Sign Up') : Text('Sign Up'),
        centerTitle: true,
        backgroundColor: isAdmin ? Colors.blueAccent : Colors.green, // Change the background color of AppBar based on role
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children:[ Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconButton(
                splashRadius: 50,
                iconSize: 100,
                icon: Lottie.asset(Icons8.book,
                    height: 70, fit: BoxFit.fitHeight),
                onPressed: null),
            AnimatedProgressIndicator(value: _formProgress),
            SizedBox(height: 10),
            TFdesign(
                alanadi: "name", onTap: _updateFormProgress, degisken: _name),
            TFdesign(
                alanadi: "surname",
                onTap: _updateFormProgress,
                degisken: _surname),
            TFdesign(
                alanadi: "email", onTap: _updateFormProgress, degisken: _email),
            TFdesign(
              alanadi: "password",
              onTap: _updateFormProgress,
              degisken: _password,
            ),
            const SizedBox(height: 10),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: _signUp,
              child: const Text('Sign Up'),
            ),
          ],
        ),],
      ),
    );
  }
}



class AnimatedProgressIndicator extends StatefulWidget {
  final double value;

  const AnimatedProgressIndicator({
    required this.value,
  });

  @override
  State<AnimatedProgressIndicator> createState() {
    return _AnimatedProgressIndicatorState();
  }
}

class _AnimatedProgressIndicatorState extends State<AnimatedProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _curveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: Duration(milliseconds: 1200), vsync: this);

    final colorTween = TweenSequence([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.red, end: Colors.orange),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.orange, end: Colors.yellow),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.yellow, end: Colors.green),
        weight: 1,
      ),
    ]);

    _colorAnimation = _controller.drive(colorTween);
    _curveAnimation = _controller.drive(CurveTween(curve: Curves.easeIn));
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.animateTo(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => LinearProgressIndicator(
        value: _curveAnimation.value,
        valueColor: _colorAnimation,
        backgroundColor: _colorAnimation.value?.withOpacity(0.4),
      ),
    );
  }
}

class TFdesign extends StatefulWidget {
  final alanadi;
  final Function()? onTap;
  final degisken;

  TFdesign({Key? mykey, this.alanadi, this.onTap, this.degisken})
      : super(key: mykey);

  @override
  State<TFdesign> createState() => _TFdesignState();
}

class _TFdesignState extends State<TFdesign> {
  @override
  void initState() {
    super.initState();
    widget.degisken.addListener(widget.onTap);
  }

  bool pwsituation() {
    bool n = false;
    if (widget.alanadi == "password") {
      n = true;
    }
    return n;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
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
                borderSide: const BorderSide(
                  color: Colors.black,
                ),
              ),
              hintText: widget.alanadi,
              hintStyle: TextStyle(color: Colors.blueGrey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              )),
          controller: widget.degisken,
          obscureText: pwsituation(),
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}


