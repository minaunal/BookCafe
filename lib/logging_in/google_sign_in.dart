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
        primary: Colors.greenAccent, // Buton rengini değiştirmek için
        onPrimary: Colors.black, // Buton metin rengini değiştirmek için
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      child: Image.asset(
        'images/G_logo.png', // Google logosunun bulunduğu dosya yolunu buraya yazın
        width: 24,
        height: 24,
      ),
    );
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // Kullanıcı giriş yapmayı iptal etti.

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
            builder: (context) => Kullanici(email: user.email!.trim())));
      } else {
        print('Google ile giriş başarısız.');
      }
    } catch (e) {
      print('Google ile giriş hatası: $e');
    }
  }
}
