import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbase/kullaniciekrani.dart';
import 'package:flutter/material.dart';

class SavedCardsPage extends StatefulWidget {
  const SavedCardsPage({super.key});

  @override
  _SavedCardsPageState createState() => _SavedCardsPageState();
}

class _SavedCardsPageState extends State<SavedCardsPage> {
  CollectionReference<Map<String, dynamic>> collectionRef =
      FirebaseFirestore.instance.collection('Kartlar');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kaydedilen Kartlar'),
        actions: [],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: collectionRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data = snapshot.data!.docs[index].data();

                // Başlık ve alt başlık değerlerini alın
                String isim = data['isim'];
                String kartno = data['kartno'];
                int limit = data['limit'];
                return ListTile(
                  leading: Icon(Icons.account_balance_wallet_outlined),
                  title: Text(isim),
                  subtitle: Text("$kartno     $limit₺"),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Text('Hata: ${snapshot.error}');
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
