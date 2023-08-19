import 'package:fbase/logging_in/user_logging_in.dart';
import 'package:fbase/logging_in/google_sign_in.dart';
import 'package:fbase/logging_in/sign_up.dart';
import 'package:fbase/logging_in/admin_logging_in.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
String currentCafeName="BookSmart";

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
        debugShowCheckedModeBanner: false,
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
      backgroundColor: Color(int.parse("0xFFF4F2DE")),
      body: Container(

        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height:45),

          const Text(
            "BookSmart",
            style: TextStyle(
              fontFamily: 'Pacifico',
              fontSize: 25,
            ),
          ),

              const UserLogin(),
          const SizedBox(height:50),
          const Text("Still not signed-up?"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(int.parse("0xFFF4F2DE")),
                  foregroundColor: Colors.black ,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    side: const BorderSide(color: Colors.grey),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignUpPage(role: 'user')));
                },
                child:
                Row(
              children: [
                Icon(Icons.app_registration_rounded),
                SizedBox(width:5,),
                Text("Sign Up",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ))
              ],
              )
              ),
              googleSignIn(),
              ],
          ),


          const SizedBox(height:40),

          const Text("Are you a manager?"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[


              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignUpPage(role: 'admin')));
                },
                child:Row(
                  children: [
                    Icon(Icons.app_registration_rounded),
                    SizedBox(width:5,),
                    Text("Manager Sign Up"),

                  ],
                )
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigoAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                      builder: (context) => const AdminLogin()));
                },
                child:
                Row(
                  children: [
                    Icon(Icons.login_outlined),
                    SizedBox(width:5,),
                    Text("Manager Log In"),

                  ],
                )
              ),

            ],
          ),

          SizedBox(height: 10),
            ]),
      ),
    );
  }
}

