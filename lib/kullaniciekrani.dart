import 'package:fbase/banka.dart';
import 'package:fbase/kartlarim.dart';
import 'package:fbase/kullanicigiris.dart';
import 'package:fbase/qrscanner.dart';
import 'package:fbase/sepet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'moderator.dart';

String qrCode = "none";
void updateQR(String newQR) {
  qrCode = newQR;
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

class Kullanici extends StatefulWidget {
  final email;

  Kullanici({Key? key, this.email}) : super(key: key);

  @override
  State<Kullanici> createState() => _KullaniciState();
}

class _KullaniciState extends State<Kullanici> {
  var docname;
  int selectedIndex = 0;

  Future<dynamic> fetchData() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('Kartlar')
        .doc(widget.email)
        .get();
    if (docSnapshot.exists) {
      setState(() {
        docname = docSnapshot.data()!['isim'];
      });
    }
    return docname;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void onTabTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: [
          masa(docname: docname),
          cuzdan(email: widget.email, docname: docname),
          Cafe(docname: docname),
          hesap(email: widget.email),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedLabelStyle:
            const TextStyle(color: Colors.white, fontSize: 14),
        backgroundColor: const Color(0xFF084A76),
        fixedColor: Colors.black,
        unselectedItemColor: Colors.black,
        currentIndex: selectedIndex,
        onTap: onTabTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.table_restaurant_outlined),
            label: 'Masa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'Cüzdan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_food_beverage),
            label: 'Cafe',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Hesap',
          ),
        ],
      ),
    );
  }
}

class chosentable extends StatelessWidget {
  const chosentable({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class masa extends StatefulWidget {
  final docname;

  masa({Key? mykey, this.docname}) : super(key: mykey);

  @override
  State<masa> createState() => _masaState();
}

class _masaState extends State<masa> {
  TextEditingController yorum = TextEditingController();
  List<bool> starColors = List.filled(5, false);
  func() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Moderator(),
            ),
            ElevatedButton(
                onPressed: () {
                  empty(qrCode);
                  
                },
                child: Text('bosalt')),
            TextField(
              controller: yorum,
            ),
            RatingBar.builder(
                minRating: 1,
                itemSize: 46,
                itemPadding: EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (context, index) => Icon(Icons.star,
                    color: starColors[index] ? Colors.amber : Colors.grey),
                updateOnDrag: true,
                onRatingUpdate: (rating) {
                  setState(() {
                    starColors =
                        List.generate(5, (index) => index < rating.round());
                    FirebaseFirestore.instance
                        .collection('Yildizlar')
                        .doc(widget.docname)
                        .set({'yildizlar': starColors, 'yorum': yorum.text});
                  });
                }),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
              ),
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => QRScanner()));
              },
              child: Text("get a table"),
            ),
          ],
        ),
      ),
    );
  }
}

class cuzdan extends StatefulWidget {
  final email;
  final docname;

  cuzdan({Key? mykey, this.email, this.docname}) : super(key: mykey);
  @override
  State<cuzdan> createState() => _cuzdanState();
}

class _cuzdanState extends State<cuzdan> {
  int sayac = 0;
  final money = TextEditingController();
  int? temp = 0;
  int? control = 0;
  int? control1 = 0;

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('Cuzdan')
        .doc(widget.docname)
        .get()
        .then((value) {
      setState(() {
        temp = value.data()!['para'];
      });
    });

    FirebaseFirestore.instance
        .collection('Kartlar')
        .doc(widget.email)
        .get()
        .then((value) {
      setState(() {
        control = value.data()!['limit'];
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cüzdan")),
      body: Column(
        children: <Widget>[
          TextField(controller: money),
          ElevatedButton(
            child: Text("para ekle"),
            onPressed: () {
              temp = (int.tryParse(money.text)! + temp!);

              FirebaseFirestore.instance
                  .collection('Kartlar')
                  .doc(widget.email)
                  .get()
                  .then((value) {
                setState(() {
                  control1 = value.data()?['limit'];
                });
              });
              if (sayac == 0) {
                FirebaseFirestore.instance
                    .collection('Cuzdan')
                    .doc(widget.docname)
                    .set({'para': temp});
                sayac++;
              } else {
                FirebaseFirestore.instance
                    .collection('Cuzdan')
                    .doc(widget.docname)
                    .update({'para': temp});
              }

              control = control! - int.tryParse(money.text)!;
              FirebaseFirestore.instance
                  .collection('Kartlar')
                  .doc(widget.email)
                  .update({'limit': control});
            },
          ),
          Icon(Icons.account_balance_wallet_outlined),
          Text("$temp₺"),
        ],
      ),
    );
  }
}

class Cafe extends StatefulWidget {
  final docname;
  Cafe({Key? mykey, this.docname}) : super(key: mykey);

  @override
  State<Cafe> createState() => _CafeState();
}

class _CafeState extends State<Cafe> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('Kupon')
        .doc('kupon')
        .get()
        .then((value) {
      Discount = value.data()!['tl'];
    });
    return Column(
      children: <Widget>[
        Flexible(
          child: GridView.count(
            crossAxisCount: 2,
            children: <Widget>[
              Makecards(
                isim: "su",
                foto: 'images/su.jpg',
                old: 5,
                fiyat: 5 - (5 * Discount / 100).toInt(),
                docname: widget.docname,
              ),
              Makecards(
                isim: "çay",
                foto: 'images/cay.jpg',
                old: 8,
                fiyat: 8 - (8 * Discount / 100).toInt(),
                docname: widget.docname,
              ),
              Makecards(
                isim: "filtre kahve",
                foto: 'images/filtre.jpg',
                old: 15,
                fiyat: 15 - (15 * Discount / 100).toInt(),
                docname: widget.docname,
              ),
              Makecards(
                isim: "maden suyu",
                foto: 'images/soda.jpg',
                old: 10,
                fiyat: 10 - (10 * Discount / 100).toInt(),
                docname: widget.docname,
              ),
              Makecards(
                isim: "türk kahvesi",
                foto: 'images/kahve.jpg',
                old: 20,
                fiyat: 20 - (20 * Discount / 100).toInt(),
                docname: widget.docname,
              ),
              Makecards(
                isim: "salep",
                foto: 'images/salep.jpg',
                fiyat: 20 - (20 * Discount / 100).toInt(),
                old: 20,
                docname: widget.docname,
              ),
              Makecards(
                isim: "limonata",
                foto: 'images/lim.jpg',
                old: 18,
                fiyat: (18 - (18 * Discount / 100)).toInt(),
                docname: widget.docname,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Makecards extends StatelessWidget {
  final isim;
  final foto;
  var old;
  var fiyat;
  final docname;

  Makecards(
      {Key? mykey, this.isim, this.foto, this.old, this.fiyat, this.docname})
      : super(key: mykey);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: AspectRatio(
              aspectRatio: 24.0 / 11.0,
              child: Image.asset(foto),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  isim,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  old.toString() + "₺",
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Colors.redAccent[700],
                    decorationThickness: 3.0,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  fiyat.toString() + "₺",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Row(
                  children: [
                    Text(
                      'Add to Cart',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    new IconButton(
                      icon: new Icon(Icons.data_saver_on),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Sepet(
                                isim: isim,
                                foto: foto,
                                fiyat: fiyat,
                                docname: docname)));
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class hesap extends StatefulWidget {
  final email;

  hesap({Key? mykey, this.email}) : super(key: mykey);

  @override
  State<hesap> createState() => _hesapState();
}

class _hesapState extends State<hesap> {
  final oldpwcontroller = TextEditingController();
  var newpwcontroller = TextEditingController();

  var auth = FirebaseAuth.instance;
  var currentUser = FirebaseAuth.instance.currentUser;

  changepw({email, oldpassword, newpassword}) async {
    var cred =
        EmailAuthProvider.credential(email: email, password: oldpassword);
    await currentUser!
        .reauthenticateWithCredential(cred)
        .then((value) => {currentUser!.updatePassword(newpassword)})
        .catchError((error) {
      final snackBar = SnackBar(
        content: Container(
          width: 150,
          height: 50,
          child: Center(
            child: Text(
              'Wrong Password',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
        action: SnackBarAction(
          label: 'Try Again',
          onPressed: () {
            oldpwcontroller.clear();
            newpwcontroller.clear();
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  String textField = 'Change Password';

  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Visibility(
          visible: isVisible,
          child: TextFormField(
            autofocus: true,
            decoration: InputDecoration(
              labelText: "old password: ",
              hintText: "enter old password: ",
              labelStyle: TextStyle(fontSize: 20.0),
              border: OutlineInputBorder(),
              errorStyle: TextStyle(color: Colors.black, fontSize: 15.0),
            ),
            controller: oldpwcontroller,
          ),
        ),
        Visibility(
          visible: isVisible,
          child: TextFormField(
            decoration: InputDecoration(
              labelText: "new password: ",
              hintText: "enter new password: ",
              labelStyle: TextStyle(fontSize: 20.0),
              border: OutlineInputBorder(),
              errorStyle: TextStyle(color: Colors.black, fontSize: 15.0),
            ),
            controller: newpwcontroller,
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              isVisible = true;

              textField = 'Approve';
              changepw(
                email: widget.email,
                oldpassword: oldpwcontroller.text,
                newpassword: newpwcontroller.text,
              ).then((_) {
                final snackBar = SnackBar(
                  content: Container(
                    width: 150,
                    height: 50,
                    child: Center(
                      child: Text(
                        'Şifre değiştirildi.',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  action: SnackBarAction(
                    label: 'GİRİŞ YAP',
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => KullaniciGiris(),
                      ));
                    },
                  ),
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });
            });
          },
          child: Text(textField),
        ),
        ElevatedButton(
          child: Text("kart ekle"),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CreditCardPage(
                      email: widget.email,
                    )));
          },
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SavedCardsPage()));
            },
            child: Text("kayıtlı kartlar")),
      ],
    );
  }
}

int Discount = 0;
