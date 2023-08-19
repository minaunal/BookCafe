
import 'package:fbase/main.dart';
import 'package:fbase/qrscanner.dart';
import 'package:fbase/user_table_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
String selectedCafe = "";
bool isAppBarVisible = true; // Initially set to true

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

      final ref = FirebaseStorage.instance.ref().child('cafes').child(cafeName).child('icon.jpg');
      final url = await ref.getDownloadURL();

      return url;
    } catch (e) {
      return 'images/default_cafe.jpg';
    }
  }

  void toggleAppBarVisibility() {
    setState(() {
      isAppBarVisible = !isAppBarVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(int.parse("0xFFF4F2DE")),
      appBar: isAppBarVisible ? AppBar(
        automaticallyImplyLeading: false,
        title: const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 10),
              Text(
                "BookSmart",
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Pacifico',
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ): null,
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
                toggleAppBarVisibility();
                currentCafeName = cafeName;
                showBottomSheet(
                  context: context,
                  builder: (context) => table(),
                );
              },
              child: FutureBuilder<String>(
                future: getCafeImageURL(cafeName),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                                width: 2.0, // Set the border width here
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0), // Set the border radius here
                              child: Image.network(
                                imageUrl!,
                                width: 100,
                                height: 100,
                                errorBuilder: (context, error, stackTrace) {
                                  // If there was an error loading the image, show a placeholder image
                                  return Image.asset(
                                    'images/default_cafe.png',
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.fitWidth,
                                  );
                                },
                              ),
                            ),
                          ),
                          Container(
                            width: 115,
                            height: 25,
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                              color: Color(int.parse("0xFFF4F2DE")),
                              borderRadius: BorderRadius.circular(20.0),
                              border: Border.all(
                                color:Colors.black,
                                width:2.0,
                              )
                            ),
                            child: Center(
                              child: Text(
                                cafeName,
                                style: const TextStyle(
                                  fontFamily: 'JosefinSans',
                                  color: Colors.black,
                                  fontSize: 14,
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



class table extends StatefulWidget {
  table({Key? mykey}) : super(key: mykey);

  @override
  State<table> createState() => _tableState();
}

class _tableState extends State<table> {
  TextEditingController yorum = TextEditingController();
  List<bool> starColors = List.filled(5, false);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(int.parse("0xFFF4F2DE")),

      body: Center(

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: UserPage(),
            ),
            const Divider(thickness: 2),
            Container(
              color: Color(int.parse("0xFFF4F2DE")),
              child: Row(
              children:[
                const SizedBox(width:7),
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return comment(); // Show the custom dialog
                  },
                );              },
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
            ),)
          ],
        ),
      ),
    );
  }

  Widget comment() {
    TextEditingController comment = TextEditingController();
    List<bool> starColors = List.generate(5, (index) => false);

    return Dialog(
      backgroundColor: Color(int.parse("0xFFF4F2DE")),
      child: Container(
        height:150,
      child:Column(

        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: comment,
          ),
          RatingBar.builder(
            minRating: 1,
            itemSize: 30,
            itemPadding: const EdgeInsets.symmetric(horizontal: 3),
            itemBuilder: (context, index) => Icon(
              Icons.star,
              color: starColors[index] ? Colors.amber : Colors.grey,
            ),
            updateOnDrag: true,
            onRatingUpdate: (rating) {
              setState(() {
                starColors = List.generate(5, (index) => index < rating.round());
              });
            },
          ),
          ElevatedButton(
            onPressed: () async {
              String newComment = comment.text;
              int starRating = starColors.where((color) => color).length;

              if (newComment.isNotEmpty && starRating > 0) {
                try {
                    await FirebaseFirestore.instance
                      .collection('cafes')
                      .doc(currentCafeName)
                      .collection('Comments')
                      .add({
                    'comment': newComment,
                    'rating': starRating,
                    'timestamp': FieldValue.serverTimestamp(),
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Comment is successfully added!')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Something wrong happened. Comment is not added.')),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill comment and star part carefully!')),
                );
              }
            },
            child: Text('Okay'),
          ),
        ]),
      ),
    );
  }

}

Future<void> empty(String qrtext) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final DocumentReference docRef = firestore.collection('cafes').doc(currentCafeName).collection('Masalar').doc(qrtext);

  try {
    final DocumentSnapshot document = await docRef.get();

    if (document.exists) {
      final List<dynamic> chairs =
      List.from(document.get('chairStatusList') as List<dynamic>);

      int indexToUpdate = chairs.indexWhere((chair) => chair == true);

      if (indexToUpdate != -1) {
        chairs[indexToUpdate] = false;

        await docRef.update({'chairStatusList': chairs});
      }
    }
  } catch (e) {
    print('Error: $e');
  }
}
