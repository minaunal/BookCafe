import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class QRScanner extends StatefulWidget {
  @override
  _QRScannerState createState() => _QRScannerState();

}

class _QRScannerState extends State<QRScanner> {
  String _scanResult = 'Henüz bir QR kodu taranmadı';
  String getScanResult() {
    return _scanResult;
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
      uploadToFirebase(_scanResult);
    });


  }



  Future<void> uploadToFirebase(String qrtext) async {
    // Firebase Firestore bağlantısını al
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Belge referansını al
    final DocumentReference docRef = firestore.collection('Masalar').doc(qrtext);

    try {
      // Belgeyi getir
      final DocumentSnapshot document = await docRef.get();

      if (document.exists) {
        // "chairs" alanını güncelle
        final List<dynamic> chairs = List.from(document.get('chairStatusList') as List<dynamic>);

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
