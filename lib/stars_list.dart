import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Stars extends StatefulWidget {
  const Stars({super.key});

  @override
  State<Stars> createState() => _StarsState();
}

class _StarsState extends State<Stars> {
  List<dynamic> starColors = [];
  List<List<bool>>? starColorsList;
  List<String> starLabels = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    FirebaseFirestore.instance
        .collection("Yildizlar")
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        starColorsList = List.generate(querySnapshot.docs.length, (_) => []);
        starLabels = List.generate(querySnapshot.docs.length, (_) => "");
        for (int i = 0; i < querySnapshot.docs.length; i++) {
          var a = querySnapshot.docs[i];
          List<dynamic> dynamicList = a['yildizlar'];
          List<bool> colors = dynamicList.cast<bool>();
          starColorsList![i] = colors;
          starLabels[i] = a['yorum'];
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Our Reviews"),
        backgroundColor: Colors.amber[400],
        foregroundColor: Colors.black,
      ),
      body: starColorsList != null
          ? ListView.builder(
              padding: EdgeInsets.only(left: 20.0, top: 20.0),
              itemCount: starColorsList!.length,
              itemBuilder: (context, index) {
                starColors = starColorsList![index];
                String label = starLabels[index];
                return Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Row(
                          children: starColors.map((isYellow) {
                            return Icon(
                              Icons.star,
                              color: isYellow ? Colors.amber : Colors.grey,
                              size: 24,
                            );
                          }).toList(),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            label,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Divider(thickness: 2,),
                  ],
                );
                
              },
            )
          : CircularProgressIndicator(),
    );
  }
}
