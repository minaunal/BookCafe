import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbase/user_screen.dart';
import 'package:fbase/logging_in/user_logging_in.dart';
import 'package:flutter/material.dart';

class SavedCardsPage extends StatefulWidget {
  const SavedCardsPage({super.key});

  @override
  _SavedCardsPageState createState() => _SavedCardsPageState();
}

String isim = '';
String kartno = '';
int limit = 0;

class _SavedCardsPageState extends State<SavedCardsPage> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('Kartlar')
        .doc(girismail)
        .get()
        .then((value) {
      setState(() {
        isim = value.data()!['isim'];
        kartno = value.data()!['kartno'];
        limit = value.data()!['limit'];
       
      });
    });

    return Scaffold(
      appBar: AppBar(title: Text('My Credit Card'),backgroundColor: Colors.red[200],foregroundColor: Colors.black,),
      body: SingleChildScrollView(
        child: ListTile(
          leading: Icon(Icons.account_balance_wallet_outlined,size: 30.0,color: Colors.black,),
          title: Text(isim,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0),),
          subtitle: Text("$kartno     $limit tl",style: TextStyle(fontSize: 16.0),),
        ),
      ),
    );
  }
}
