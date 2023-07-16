import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fbase/user_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'kullaniciekrani.dart';

class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  String _scanResult = 'Henüz bir QR kodu taranmadı';

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

  Future<void> _scanQRCode() async {
    String scanResult = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'İptal',
      true,
      ScanMode.QR,
    );

    setState(() {
      _scanResult = scanResult;
      selectedTables[selectedTableCount] = _scanResult;
      selectedTableCount++;
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _scanResult,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _scanQRCode,
              child: Text('QR Kodunu Tara'),
            ),
          ],
        ),
      ),
    );
  }
}
