import 'package:fbase/cam.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:lottie/lottie.dart';

import 'giris.dart';

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
      title: 'kitapcafe',
      initialRoute: "/",
      routes: {"/": (context) => Iskele(), "/anasayfa": (context) => Giris()},
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
              IconButton(
                  splashRadius: 50,
                  iconSize: 100,
                  icon: Lottie.asset(Icons8.book,
                      height: 70, fit: BoxFit.fitHeight),
                  onPressed: null),
              Kayit(),
            ]),
      ),
    );
  }
}

class Kayit extends StatefulWidget {
  const Kayit({super.key});

  @override
  State<Kayit> createState() => _KayitState();
}

class _KayitState extends State<Kayit> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  final _surname = TextEditingController();
  double _formProgress = 0;
  bool _controlprogress=false;
  
  void _updateFormProgress() {
    var progress = 0.0;
    var controllers = [_email, _password,_name,_surname];

    for (var controller in controllers) {
      if (controller.value.text.isNotEmpty) {
        progress += 1 / controllers.length;
      }
    }
    setState(() {
      _formProgress = progress;
      if(_formProgress==1){
        _controlprogress=true;
      }
    });
  }

  KayitOl() {
    FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text, password: _password.text);
  }



  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("Chill & Study",
          style: TextStyle(
            fontFamily: 'Pacifico',
            fontSize: 25,
          ),),
          SizedBox(
            height: 30,
          ),
          AnimatedProgressIndicator(value: _formProgress),
          TFdesign(alanadi: "name", onTap:_updateFormProgress,degisken: _name),
    TFdesign(alanadi: "surname", onTap:_updateFormProgress,degisken: _surname),
          TFdesign(
              alanadi: "email", onTap: _updateFormProgress, degisken: _email),
          TFdesign(
            alanadi: "password",
            onTap: _updateFormProgress,
            degisken: _password,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
            ),
          
            onPressed: _controlprogress ? () => KayitOl() : null, 
            child: Text("Sign in"),
          ),
          SizedBox(
            height: 50,
          ),
          Text("Already have an account?"),
          Text("Log in."),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
            ),
           onPressed: () {
           // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Giris()));
          },
            child: Text("Manager"),
          ),
           ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
            ),
           onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => QRScanner()));
          },
            child: Text("kamera"),
          ),
         ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
            ),
            onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Giris()));
          },
            child: Text("Student"),
          ),
            ],
          ),
        ],
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

  @override
  Widget build(BuildContext context) {
    return Column(
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
              )),
          controller: widget.degisken,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
