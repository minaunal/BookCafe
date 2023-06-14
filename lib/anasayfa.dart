import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  CikisYap() {
    setState(() {
      FirebaseAuth.instance.signOut();
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('hey'),
        backgroundColor: Colors.pink,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.blueGrey,
              ),
              onPressed: CikisYap),
        ],
      ),
      body: Izgara(),
    );
  }
}

class Izgara extends StatefulWidget {
  const Izgara({super.key});

  @override
  State<Izgara> createState() => _IzgaraState();
}

class _IzgaraState extends State<Izgara> {
  Card() {
    return Image.network(
        'https://artprojectsforkids.org/wp-content/uploads/2021/06/Draw-Clouds.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
     child:AspectRatio(aspectRatio:18/11, 
     child:GridView.count(
        crossAxisCount: 2,
        children: <Widget>[
          Card(),
        
        ],
      ),
     ),
    );
  }
}
