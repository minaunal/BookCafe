import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../user_screen.dart';

class googleSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await signInWithGoogle(context);
      },

      style: ElevatedButton.styleFrom(
        backgroundColor: Color(int.parse("0xFFF4F2DE")),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
          side: const BorderSide(color: Colors.grey),

        ),
      ),
      child: Image.asset(
        'images/G_logo.png',
        width: 24,
        height: 24,
      ),
    );
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase ile kimlik doğrulama
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        print('Kullanıcı giriş yaptı: ${user.displayName}');
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => UserLogged(email: user.email!.trim())));
      } else {
        print('Google ile giriş başarısız.');
      }
    } catch (e) {
      print('Google ile giriş hatası: $e');
    }
  }
}
