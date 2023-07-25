import 'package:fbase/logging_in/user_logging_in.dart';
import 'package:fbase/logging_in/google_sign_in.dart';
import 'package:fbase/logging_in/sign_up.dart';
import 'package:fbase/logging_in/admin_logging_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:lottie/lottie.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'TitilliumWeb'),
      title: 'kitapcafe',
      initialRoute: "/",
      routes: {"/": (context) => Iskele()},
    );
  }
}

class Iskele extends StatefulWidget {
  const Iskele({super.key});

  @override
  State<Iskele> createState() => _IskeleState();
}

class _IskeleState extends State<Iskele> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(

        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

          const Text(
            "BookSmart",
            style: TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 25,
            ),
          ),
              KullaniciGiris(),
          SizedBox(height:20),
          Text("Still not signed-up?"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignUpPage(role: 'user')));
                },
                child: const Text("User Sign Up"),
              ),
              googleSignIn(),],
          ),


          SizedBox(height:50),

          const Text("Are you a manager?"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[


              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignUpPage(role: 'admin')));
                },
                child: const Text("Manager Sign Up"),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                      builder: (context) => const YoneticiGiris()));
                },
                child: Text("Manager Log In"),
              ),

            ],
          ),

          SizedBox(height: 10),
            ]),
      ),
    );
  }
}

