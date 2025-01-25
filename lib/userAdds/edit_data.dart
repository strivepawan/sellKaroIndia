import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import '../models/add_tag_button.dart';
import '../models/image_upload.dart';

class EditData extends StatefulWidget {
  final String whichType;
  final String docName;
  final Map<String, dynamic>? existingData;

  const EditData({
    Key? key,
    required this.whichType,
    required this.docName,
    this.existingData,
  }) : super(key: key);

  @override
  State<EditData> createState() => _EditDataState();
}

class _EditDataState extends State<EditData> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSubmitting = false;
  String adName = '';
  String description = '';
  List<String> tags = [];
  String negotiable = '';
  String newTag = '';
  String price = '';
  List<File> _imageFiles = [];
  List<String> existingImageUrls = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      _populateFields(widget.existingData!);
    } else {
      _fetchDocumentData();
    }
  }

  void _populateFields(Map<String, dynamic> data) {
    setState(() {
      adName = data['ad_name'] ?? '';
      description = data['description'] ?? '';
      tags = List<String>.from(data['tags'] ?? []);
      negotiable = data['negotiable'] ?? '';
      price = data['price'] ?? '';
      existingImageUrls = List<String>.from(data['images'] ?? []);
    });
  }

  Future<void> _fetchDocumentData() async {
    try {
      final DocumentSnapshot docSnapshot = await _firestore
          .collection('category')
          .doc(widget.whichType)
          .collection('ads')
          .doc(widget.docName)
          .get();

      if (docSnapshot.exists) {
        _populateFields(docSnapshot.data() as Map<String, dynamic>);
      } else {
        print('Document does not exist');
      }
    } catch (error) {
      print('Error fetching document data: $error');
    }
  }

  Future<String> uploadImage(File imageFile) async {
    final Reference storageReference = _firebaseStorage
        .ref()
        .child('category/${path.basename(imageFile.path)}');
    final TaskSnapshot uploadTask = await storageReference.putFile(imageFile);
    return await uploadTask.ref.getDownloadURL();
  }

  void handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          isSubmitting = true;
        });

        List<String> imageUrls = [];
        for (int i = 0; i < _imageFiles.length; i++) {
          final String imageUrl = await uploadImage(_imageFiles[i]);
          imageUrls.add(imageUrl);
        }

        imageUrls.addAll(existingImageUrls);

        final DocumentReference documentRef = _firestore
            .collection('category')
            .doc(widget.whichType)
            .collection('ads')
            .doc(widget.docName);

        await documentRef.update({
          'ad_name': adName,
          'tags': tags,
          'description': description,
          'price': price,
          'negotiable': negotiable,
          'images': imageUrls,
          'timestamp': FieldValue.serverTimestamp(),
        });

        setState(() {
          isSubmitting = false;
        });

        Navigator.pop(context, true);
      } catch (error) {
        setState(() {
          isSubmitting = false;
        });
        print('Error updating document in Firestore: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text('Update Ad',
            style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitle('Ad Name *'),
                  _buildTextField(
                    initialValue: adName,
                    hintText: 'Enter Ad Name',
                    onChanged: (value) => adName = value,
                  ),
                  _buildTitle('Description *'),
                  _buildTextField(
                    initialValue: description,
                    hintText: 'Enter Description',
                    maxLines: 4,
                    onChanged: (value) => description = value,
                  ),
                  _buildTitle('Tags *'),
                  _buildTagSection(),
                  _buildTitle('Negotiable *'),
                  _buildDropdownField(),
                  _buildTitle('Price (INR) *'),
                  _buildTextField(
                    initialValue: price,
                    hintText: 'Enter Price',
                    keyboardType: TextInputType.number,
                    onChanged: (value) => price = value,
                  ),
                  _buildTitle('Add Photos'),
                  ImageUploader(
                    onImagesChanged: (imageFiles) {
                      setState(() {
                        _imageFiles = imageFiles;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
          if (isSubmitting)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextField({
    String? initialValue,
    String? hintText,
    TextInputType? keyboardType,
    int maxLines = 1,
    required Function(String) onChanged,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16.0),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: onChanged,
    );
  }

  Widget _buildTagSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.0,
          children: tags.map((tag) {
            return Chip(
              label: Text(tag),
              deleteIcon: const Icon(Icons.close, size: 16.0),
              onDeleted: () {
                setState(() {
                  tags.remove(tag);
                });
              },
            );
          }).toList(),
        ),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                hintText: 'Enter a new tag',
                onChanged: (value) => newTag = value,
              ),
            ),
            const SizedBox(width: 8.0),
            IconButton(
              icon: const Icon(
                Icons.add,
                color: Colors.green,
                size: 35,
              ),
              onPressed: () {
                if (tags.length < 5 && newTag.trim().isNotEmpty) {
                  setState(() {
                    tags.add(newTag.trim());
                    newTag = '';
                  });
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: negotiable,
      onChanged: (value) => setState(() => negotiable = value!),
      items: const [
        DropdownMenuItem(value: '', child: Text('Select')),
        DropdownMenuItem(value: 'Yes', child: Text('Yes')),
        DropdownMenuItem(value: 'No', child: Text('No')),
      ],
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.all(16.0),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: handleSubmit,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: const Text(
          'Submit',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
