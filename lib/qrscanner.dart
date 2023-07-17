import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbase/user_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'kullaniciekrani.dart';
import 'kullanicigiris.dart';

class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  String _scanResult = 'Not scanned any QR code yet';

  Future<void> uploadToFirebase(String qrtext) async {
    // Firebase Firestore bağlantısını al
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Belge referansını al
    final DocumentReference docRef =
        firestore.collection('Masalar').doc(qrtext);

    try {
      // Belgeyi getir
      final DocumentSnapshot document = await docRef.get();

      if (document.exists) {
        // "chairs" alanını güncelle
        final List<dynamic> chairs =
            List.from(document.get('chairStatusList') as List<dynamic>);

        // False olan bir sandalye bul
        int indexToUpdate = chairs.indexWhere((chair) => chair == false);

        if (indexToUpdate != -1) {
          // İlgili sandalyeyi false yap
          chairs[indexToUpdate] = true;

          // Güncellenmiş sandalye listesini Firestore'a kaydet
          await docRef.update({'chairStatusList': chairs});
        }
      }
    } catch (e) {
      // Hata durumunda ilgili işlemleri gerçekleştir
      print('Hata: $e');
    }
  }

  int temp = 0;
  Future<void> _scanQRCode() async {
    String scanResult = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'İptal',
      true,
      ScanMode.QR,
    );
    if (scanResult != "-1") {
      setState(() {
        _scanResult = scanResult;
        selectedTables[selectedTableCount] = _scanResult;
        selectedTableCount++;
        _scanResult = scanResult;
        uploadToFirebase(_scanResult);
        updateQR(_scanResult);
        FirebaseFirestore.instance
            .collection('Gelir')
            .doc('gelir')
            .get()
            .then((value) {
          FirebaseFirestore.instance
              .collection('Gelir')
              .doc('gelir')
              .update(({'tl': 35 + value.data()!['tl']}));
        });
        takename().then((name) {
          FirebaseFirestore.instance
              .collection('Cuzdan')
              .doc(name)
              .get()
              .then((value) {
            setState(() {
              temp = value.data()!['para'];
              if ((temp - 35) >= 0) {
                temp = temp - 35;
                FirebaseFirestore.instance
                    .collection('Cuzdan')
                    .doc(name)
                    .update({'para':temp});
              }
            });
          });
        });
      });
    }
  }

  Future<String> takename() async {
    var name;
    await FirebaseFirestore.instance
        .collection("Kartlar")
        .doc(girismail)
        .get()
        .then((value) {
      setState(() {
        name = value.data()!['isim'];
      });
    });
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text('QR Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _scanResult,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                _scanQRCode();
              },
              child: Icon(
                Icons.camera_alt_rounded,
                color: Colors.black,
                size: 32,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Scan a QR',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
