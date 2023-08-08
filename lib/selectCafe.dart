import 'dart:ffi';

import 'package:fbase/main.dart';
import 'package:fbase/qrscanner.dart';
import 'package:fbase/user_table_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
String selectedCafe = "";

class SelectCafe extends StatefulWidget {
  @override
  _SelectCafeState createState() => _SelectCafeState();
}

class _SelectCafeState extends State<SelectCafe> {
  List<String> cafeNames = [];
  @override
  void initState() {
    super.initState();
    fetchCafeNames();
  }

  Future<void> fetchCafeNames() async {
    List<String> names = await getAllCafeNames();

    setState(() {
      cafeNames = names;
    });
  }
  Future<String> getCafeImageURL(String cafeName) async {
    try {
      final docSnapshot = await FirebaseFirestore.instance.collection('cafes').doc(cafeName).get();
      final icon = docSnapshot.data()?['icon'] ?? 'images/default_cafe.png';

      final ref = FirebaseStorage.instance.ref().child('icon.jpg');
      final url = await ref.getDownloadURL();

      return url;
    } catch (e) {
      // If the image is not available, return the default image URL
      return 'images/default_cafe.png';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.book_online),
              SizedBox(width: 10),
              Text(
                "BookSmart",
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Pacifico',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // cafe count by row
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: cafeNames.length,
          itemBuilder: (context, index) {
            String cafeName = cafeNames[index];
            return GestureDetector(
              onTap: () {
                currentCafe = cafeName;
                showBottomSheet(
                  context: context,
                  builder: (context) => masa(),
                );
              },
              child: FutureBuilder<String>(
                future: getCafeImageURL(cafeName),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // While the image URL is being fetched, show a loading indicator or a placeholder image
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    // If there was an error while fetching the image URL, show an error message or a placeholder image
                    return Text('Error loading image');
                  } else {
                    // If the image URL is available, use it to display the image
                    final imageUrl = snapshot.data;
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0), // Set the border radius here
                              border: Border.all(
                                color: Colors.black, // Set the border color here
                                width: 1.0, // Set the border width here
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0), // Set the border radius here
                              child: Image.network(
                                imageUrl!,
                                width: 70,
                                height: 70,
                                errorBuilder: (context, error, stackTrace) {
                                  // If there was an error loading the image, show a placeholder image
                                  return Image.asset(
                                    'images/default_cafe.png',
                                    width: 120,
                                    height: 100,
                                    fit: BoxFit.fitWidth,
                                  );
                                },
                              ),
                            ),
                          ),
                          Container(
                            width:125,

                            padding: EdgeInsets.all(2.0), // Add padding around the text
                            decoration: BoxDecoration(

                              color: Colors.black12, // Set the background color
                              borderRadius: BorderRadius.circular(10.0), // Set the border radius for the background
                            ),
                            child: Center(
                              child: Text(
                                cafeName,
                                style: const TextStyle(
                                  fontFamily: 'Pacifico',
                                  //fontWeight: FontWeight.bold,
                                  color: Colors.black, // Set the text color
                                  fontSize: 12, // Set the font size
                                ),
                              ),
                  )

                          ),

                        ],
                      ),
                    );
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }}

Future<List<String>> getAllCafeNames() async {
  try {
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection("cafes").get();

    List<String> cafeNames = querySnapshot.docs.map((doc) => doc.id).toList();
    cafeNames.sort(); // Sort the names alphabetically

    return cafeNames;
  } catch (e) {
    print("Error fetching cafe names: $e");
    return [];
  }
}



class masa extends StatefulWidget {
  masa({Key? mykey}) : super(key: mykey);

  @override
  State<masa> createState() => _masaState();
}

class _masaState extends State<masa> {
  TextEditingController yorum = TextEditingController();
  List<bool> starColors = List.filled(5, false);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: UserPage(),
            ),
            const Divider(thickness: 2),
            Row(
              children:[
                SizedBox(width:5),
                ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Empty Table"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: selectedTables.entries.map((entry) {
                          int tableIndex = entry.key;
                          String tableName = entry.value;
                          return ListTile(
                            title: Text('$tableName'),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title:
                                      Text("Are you sure you want to empty the table?"),
                                      actions: [
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              selectedTables.remove(tableIndex);
                                            });
                                            empty(tableName);
                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                          },
                                          child: Text("Yes"),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text("No"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel"),
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.delete,
                  ),
                  SizedBox(width: 5),
                  Text("Empty table"),
                ],
              ),
            ),
                SizedBox(width:5),
                ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => QRScanner()));
              },
              icon: Icon(
                Icons.camera_alt,
                color: Colors.white,
              ),
              label: Text('Get a table'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ),
                SizedBox(width:5),
                ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => yorumSor()));
              },
              icon: Icon(
                Icons.comment,
                color: Colors.white,
              ),
              label: Text('Comment'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
            ),]
            ),
          ],
        ),
      ),
    );
  }

  Widget yorumSor() {
    TextEditingController yorum = TextEditingController();
    List<bool> starColors = List.generate(5, (index) => false);

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: yorum,
          ),
          RatingBar.builder(
            minRating: 1,
            itemSize: 46,
            itemPadding: EdgeInsets.symmetric(horizontal: 4),
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: starColors[index] ? Colors.amber : Colors.grey,
            ),
            updateOnDrag: true,
            onRatingUpdate: (rating) {
              setState(() {
                starColors = List.generate(5, (index) => index < rating.round());
                /*FirebaseFirestore.instance
                    .collection('cafes')
                    .doc(cafeName)
                    .set({'Stars': starColors, 'Comment': .text});*/
              });
            },
          ),
        ],
      ),
    );
  }
}
Future<void> empty(String qrtext) async {
  // Firebase Firestore bağlantısını al
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Belge referansını al
  final DocumentReference docRef = firestore.collection('Masalar').doc(qrtext);

  try {
    // Belgeyi getir
    final DocumentSnapshot document = await docRef.get();

    if (document.exists) {
      // "chairs" alanını güncelle
      final List<dynamic> chairs =
      List.from(document.get('chairStatusList') as List<dynamic>);

      // False olan bir sandalye bul
      int indexToUpdate = chairs.indexWhere((chair) => chair == true);

      if (indexToUpdate != -1) {
        // İlgili sandalyeyi false yap
        chairs[indexToUpdate] = false;

        // Güncellenmiş sandalye listesini Firestore'a kaydet
        await docRef.update({'chairStatusList': chairs});
      }
    }
  } catch (e) {
    // Hata durumunda ilgili işlemleri gerçekleştir
    print('Hata: $e');
  }
}
