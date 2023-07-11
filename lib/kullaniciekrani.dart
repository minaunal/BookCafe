import 'package:fbase/banka.dart';
import 'package:fbase/kartlarim.dart';
import 'package:fbase/kullanicigiris.dart';
import 'package:fbase/sepet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Kullanici extends StatefulWidget {
  final email;

  Kullanici({Key? mykey, this.email}) : super(key: mykey);

  @override
  State<Kullanici> createState() => _KullaniciState();
}

class _KullaniciState extends State<Kullanici> {
  String docname = '';

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('Kartlar')
        .doc(widget.email)
        .get()
        .then((docSnapshot) {
      if (docSnapshot.exists) {
        setState(() {
          docname = docSnapshot.data()!['isim'];
        });
      }
    });
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
            bottom: TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.table_restaurant_outlined),
            ),
            Tab(
              icon: Icon(Icons.account_balance_wallet_outlined),
            ),
            Tab(
              icon: Icon(Icons.emoji_food_beverage),
            ),
            Tab(
              icon: Icon(Icons.account_circle_outlined),
            ),
          ],
        )),
        body: TabBarView(
          children: [
            // İlk taba ait widget ve fonksiyonları
            masa(),

            // İkinci taba ait widget ve fonksiyonları
            cuzdan(email: widget.email, docname: docname),

            // Üçüncü taba ait widget ve fonksiyonları
            Cafe(docname: docname),

            // Dördüncü taba ait widget ve fonksiyonları
            hesap(email: widget.email),
          ],
        ),
      ),
    );
  }
}

class masa extends StatelessWidget {
  const masa({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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
                fiyat: 5 - (5 * Discount / 100),
                docname: widget.docname,
              ),
              Makecards(
                isim: "çay",
                foto: 'images/cay.jpg',
                old: 8,
                fiyat: 8 - (8 * Discount / 100),
                docname: widget.docname,
              ),
              Makecards(
                isim: "filtre kahve",
                foto: 'images/filtre.jpg',
                old: 15,
                fiyat: 15 - (15 * Discount / 100),
                docname: widget.docname,
              ),
              Makecards(
                isim: "maden suyu",
                foto: 'images/soda.jpg',
                old: 10,
                fiyat: 10 - (10 * Discount / 100),
                docname: widget.docname,
              ),
              Makecards(
                isim: "türk kahvesi",
                foto: 'images/kahve.jpg',
                old: 20,
                fiyat: 20 - (20 * Discount / 100),
                docname: widget.docname,
              ),
              Makecards(
                isim: "salep",
                foto: 'images/salep.jpg',
                fiyat: 20 - (20 * Discount / 100),
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
                  old.toString()+ "₺",
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

getDoc() async {
  final db = FirebaseFirestore.instance;
  String id = '';
  var result = await db.collection('Kartlar').get();
  result.docs.forEach((res) {
    id = (res.id);
  });
  return (id);
}

int Discount = 0;