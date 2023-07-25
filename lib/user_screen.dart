import 'package:fbase/credit_card.dart';
import 'package:fbase/changepw.dart';
import 'package:fbase/cards.dart';
import 'package:fbase/logging_in/user_logging_in.dart';
import 'package:fbase/qrscanner.dart';
import 'package:fbase/basket.dart';
import 'package:fbase/selectCafe.dart';
import 'package:fbase/user_table_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animated_icons/icons8.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';

int selectedTableCount = 0;

String qrCode = "none";
void updateQR(String newQR) {
  qrCode = newQR;
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
          //masa(docname: docname),
          SelectCafe(),
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
            icon: Icon(
              Icons.table_restaurant_outlined,
              color: Color(0xFFFF7800),
            ),
            label: 'Tables',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_balance_wallet_outlined,
              color: Color(0xFF2EA84A),
            ),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.emoji_food_beverage,
              color: Color(0xFFDA1E60),
            ),
            label: 'Cafe',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle_outlined,
              color: Color(0xFF182B6A),
            ),
            label: 'Account',
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
  Widget build(BuildContext context) {
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
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30.0), // Girinti ayarı
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
              splashRadius: 50,
              iconSize: 80,
              icon:
                  Lottie.asset(Icons8.book, height: 80, fit: BoxFit.fitHeight),
              onPressed: null,
            ),
            Divider(
              thickness: 3,
            ),
            const SizedBox(height: 25),
            Row(
              children: <Widget>[
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 32,
                ),
                const SizedBox(
                  width: 20,
                ),
                Text(
                  "Money in the wallet: $temp tl",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 40, // Genişlik ayarı
                  child: TextField(
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    controller: money,
                    decoration: const InputDecoration(
                      hintText: 'tl',
                      hintStyle: TextStyle(fontSize: 20.0),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 2.0),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.docname == null) {
                      final snackBar = SnackBar(
                        content: Container(
                          width: 150,
                          height: 50,
                          child: const Center(
                            child: Text(
                              'You have no saved cards, add a credit card first.',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        action: SnackBarAction(
                          label: 'Add credit card',
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    CreditCardPage(email: girismail)));
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
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
                    }
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 32,
                  ),
                ),
              ],
            ),
          ],
        ),
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
                isim: "water",
                foto: 'images/su.jpg',
                old: 5,
                fiyat: 5 - (5 * Discount / 100).toInt(),
                docname: widget.docname,
              ),
              Makecards(
                isim: "mineral water",
                foto: 'images/soda.jpg',
                old: 10,
                fiyat: 10 - (10 * Discount / 100).toInt(),
                docname: widget.docname,
              ),
              Makecards(
                isim: "lemonade",
                foto: 'images/lim.jpg',
                old: 18,
                fiyat: (18 - (18 * Discount / 100)).toInt(),
                docname: widget.docname,
              ),
              Makecards(
                isim: "tea",
                foto: 'images/cay.jpg',
                old: 8,
                fiyat: 8 - (8 * Discount / 100).toInt(),
                docname: widget.docname,
              ),
              Makecards(
                isim: "filter coffee",
                foto: 'images/filtre.jpg',
                old: 15,
                fiyat: 15 - (15 * Discount / 100).toInt(),
                docname: widget.docname,
              ),
              Makecards(
                isim: "turkish coffee",
                foto: 'images/kahve.jpg',
                old: 20,
                fiyat: 20 - (20 * Discount / 100).toInt(),
                docname: widget.docname,
              ),
              Makecards(
                isim: "sahlep",
                foto: 'images/salep.jpg',
                fiyat: 20 - (20 * Discount / 100).toInt(),
                old: 20,
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
    String price = '';
    if (old != fiyat) {
      price = old.toString() + "tl";
    }
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
                  price,
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    decorationColor: Colors.redAccent[700],
                    decorationThickness: 3.0,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  fiyat.toString() + "tl",
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
  Future<bool> checkDocumentExists() async {
    var collection = FirebaseFirestore.instance.collection('Kartlar');
    var documentSnapshot = await collection.doc(girismail).get();
    bool n = false;
    if (documentSnapshot.exists) {
      final snackBar = SnackBar(
        content: Container(
          width: 150,
          height: 50,
          child: Center(
            child: Text(
              'You already saved a credit card',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      n = true;
    }
    return n;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(30.0), // Girinti ayarı
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            splashRadius: 50,
            iconSize: 80,
            icon: Lottie.asset(Icons8.book, height: 80, fit: BoxFit.fitHeight),
            onPressed: null,
          ),
          Divider(
            thickness: 3,
          ),
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => change(email: widget.email)));
                },
                child: Icon(
                  Icons.key,
                  color: Colors.black,
                  size: 32,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  checkDocumentExists().then((value) {
                    if (value == true) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CreditCardPage(
                                email: widget.email,
                              )));
                    }
                  });
                },
                child: Icon(
                  Icons.credit_card,
                  color: Colors.black,
                  size: 32,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                'Add credit card',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SavedCardsPage()));
                },
                child: Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 32,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                'Check your saved card info',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

int Discount = 0;
