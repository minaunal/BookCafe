import 'dart:io';
import 'package:fbase/yoneticiekrani.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class CafeCreationPage extends StatefulWidget {
  @override
  _CafeCreationPageState createState() => _CafeCreationPageState();
}

class _CafeCreationPageState extends State<CafeCreationPage> {
  final ImagePicker picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _cityController = TextEditingController();
  final _tableCountController = TextEditingController();
  List<File> selectedImages = []; // List of selected image

  bool _isLoading = false;

  // Function to pick an image from the gallery
  Future getImages() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, maxHeight: 1000, maxWidth: 1000);
    List<XFile> xfilePick = pickedFile;

    setState(
          () {
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            selectedImages.add(File(xfilePick[i].path));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Nothing is selected')));
        }
      },
    );
  }

  // Function to upload the selected image to Firebase Storage
  Future<List<String>> _uploadImages(List<File> images) async {
    List<String> imageUrls = [];

    for (var image in images) {
      final reference = FirebaseStorage.instance.ref().child('cafe_images/${DateTime.now()}.png');
      final uploadTask = reference.putFile(image);
      final snapshot = await uploadTask.whenComplete(() {});

      if (snapshot.state == TaskState.success) {
        final imageUrl = await reference.getDownloadURL();
        imageUrls.add(imageUrl);
      }
    }

    return imageUrls;
  }


  // Function to handle cafe creation
  Future<void> _createCafe() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    final User? user = FirebaseAuth.instance.currentUser;
    final adminEmail = user?.email;
    final name = _nameController.text;
    final city = _cityController.text;
    final tableCount = int.parse(_tableCountController.text);
    List<String> uploadedImageUrls = await _uploadImages(selectedImages);

    if (name.isNotEmpty && city.isNotEmpty && tableCount > 0) {
      try {
        await FirebaseFirestore.instance.collection('cafes').doc(name).set({
          'name': name,
          'city': city,
          'tableCount': tableCount,
          'imagesUrlList': uploadedImageUrls,
          'available': true,
          'adminEmail': adminEmail,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cafe created successfully!')),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Yonetici(),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again later.')),
        );
      }
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
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the city';
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
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blue)),
                child: const Text('Select Image from Gallery and Camera'),
                onPressed: () {
                  getImages();
                },
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 18.0),
                child: Text(
                  "GFG",
                  textScaleFactor: 3,
                  style: TextStyle(color: Colors.green),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: 300.0,
                  child: selectedImages.isEmpty
                      ? const Center(child: Text('Sorry nothing selected!!'))
                      : GridView.builder(
                    itemCount: selectedImages.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (BuildContext context, int index) {
                      return Center(
                          child: kIsWeb
                              ? Image.network(selectedImages[index].path)
                              : Image.file(selectedImages[index]));
                    },
                  ),
                ),
              ),


              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _createCafe,
                child: _isLoading
                    ? CircularProgressIndicator()
                    : Text('Create Cafe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
