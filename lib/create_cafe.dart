import 'dart:io';
import 'package:fbase/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'admin_screen.dart';

class CafeCreationPage extends StatefulWidget {
  final String uid;
  CafeCreationPage(this.uid);

  @override
  _CafeCreationPageState createState() => _CafeCreationPageState();
}

class _CafeCreationPageState extends State<CafeCreationPage> {
  final ImagePicker picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _tableCountController = TextEditingController();
  List<File> selectedImages = []; // List of selected image
  String? selectedCity;
  bool _isLoading = false;

  // Function to pick an image from the gallery




  // Function to handle cafe creation
  Future<void> _createCafe() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });


    final User? user = FirebaseAuth.instance.currentUser;
    final adminEmail = user?.email;
    final name = _nameController.text;
    final tableCount = int.tryParse(_tableCountController.text) ?? 0;

    final cafeSnapshot = await FirebaseFirestore.instance
        .collection('cafes')
        .doc(name)
        .get();

    if (!cafeSnapshot.exists && name.isNotEmpty && selectedCity != null && tableCount > 0 && selectedImages.isNotEmpty) {
      try {
        await FirebaseFirestore.instance.collection('cafes').doc(name).set({
          'name': name,
          'city': selectedCity,
          'tableCount': tableCount,
          'available': true,
          'adminEmail': adminEmail,
        });



        // Upload images to Firebase Storage and add their download URLs to the subcollection

        // Add admin's uid
        await FirebaseFirestore.instance.collection('users').doc(widget.uid).set({
          'cafe': name,
        });
        currentCafe = name;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cafe created successfully!')),
        );

        // Replace this with your desired navigation logic after cafe creation
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Yonetici(email: adminEmail!),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again later.')),
        );
      }
    }

    if (cafeSnapshot.exists){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cafe name is not available. It already exists.')),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Cafe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Cafe Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a cafe name';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedCity,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCity = newValue;
                  });
                },
                items: CityData().turkishCities.map((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'City',
                  border: OutlineInputBorder(),
                  // Add any additional styling here if needed
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a city';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tableCountController,
                decoration: InputDecoration(labelText: 'Table Count'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the table count';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid table count';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              Expanded(
                child: SizedBox(
                  width: 150.0,
                  child: selectedImages.isEmpty
                      ? const Center(child: Text('Nothing selected!!'))
                      : GridView.builder(
                    itemCount: selectedImages.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return Center(
                        child: kIsWeb
                            ? Image.network(selectedImages[index].path)
                            : Image.file(selectedImages[index]),
                      );
                    },
                  ),
                ),
              ),
              ElevatedButton(

                onPressed: _isLoading ? null : _createCafe,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Create Cafe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CityData {
  static final CityData _instance = CityData._internal();

  factory CityData() {
    return _instance;
  }

  CityData._internal();
  List<String> turkishCities = [
    'İstanbul',
    'Ankara',
    'İzmir',
    'Adana',
    'Adıyaman',
    'Afyonkarahisar',
    'Ağrı',
    'Amasya',
    'Antalya',
    'Artvin',
    'Aydın',
    'Balıkesir',
    'Bilecik',
    'Bingöl',
    'Bitlis',
    'Bolu',
    'Burdur',
    'Bursa',
    'Çanakkale',
    'Çankırı',
    'Çorum',
    'Denizli',
    'Diyarbakır',
    'Edirne',
    'Elazığ',
    'Erzincan',
    'Erzurum',
    'Eskişehir',
    'Gaziantep',
    'Giresun',
    'Gümüşhane',
    'Hakkâri',
    'Hatay',
    'Isparta',
    'Mersin',

    'Kars',
    'Kastamonu',
    'Kayseri',
    'Kırklareli',
    'Kırşehir',
    'Kocaeli',
    'Konya',
    'Kütahya',
    'Malatya',
    'Manisa',
    'Kahramanmaraş',
    'Mardin',
    'Muğla',
    'Muş',
    'Nevşehir',
    'Niğde',
    'Ordu',
    'Rize',
    'Sakarya',
    'Samsun',
    'Siirt',
    'Sinop',
    'Sivas',
    'Tekirdağ',
    'Tokat',
    'Trabzon',
    'Tunceli',
    'Şanlıurfa',
    'Uşak',
    'Van',
    'Yozgat',
    'Zonguldak',
    'Aksaray',
    'Bayburt',
    'Karaman',
    'Kırıkkale',
    'Batman',
    'Şırnak',
    'Bartın',
    'Ardahan',
    'Iğdır',
    'Yalova',
    'Karabük',
    'Kilis',
    'Osmaniye',
    'Düzce',
  ];
}
