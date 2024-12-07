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

  void handleNegotiableChange(String? value) {
    setState(() {
      negotiable = value ?? '';
    });
  }

  void handleAddTag() {
    if (tags.length < 5 && newTag.trim().isNotEmpty) {
      setState(() {
        tags.add(newTag.trim());
        newTag = '';
      });
    }
  }

  void handleAdNameChange(String adNameValue) {
    setState(() {
      adName = adNameValue;
    });
  }

  void handleRemoveTag(String tagToRemove) {
    setState(() {
      tags.remove(tagToRemove);
    });
  }

  void handleTagChange(String value) {
    setState(() {
      tags.add(value);
    });
  }

  void handleDescriptionChange(String value) {
    setState(() {
      description = value;
    });
  }

  void handlePriceChange(String value) {
    setState(() {
      price = value;
    });
  }

  Future<String> uploadImage(File imageFile) async {
    final Reference storageReference = _firebaseStorage.ref().child('category/${path.basename(imageFile.path)}');
    final TaskSnapshot uploadTask = await storageReference.putFile(imageFile);
    return await uploadTask.ref.getDownloadURL();
  }

  void handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          isSubmitting = true;
        });

        // Upload new images and get their URLs
        List<String> imageUrls = [];
        for (int i = 0; i < _imageFiles.length; i++) {
          final String imageUrl = await uploadImage(_imageFiles[i]);
          imageUrls.add(imageUrl);
        }

        // Combine new image URLs with existing ones
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

        Navigator.pop(context, true); // Navigate back with success indicator
      } catch (error) {
        setState(() {
          isSubmitting = false;
        });
        print('Error updating document in Firestore: $error');
        // Handle error display or logging
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Add'),
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
                  const Text("Ad Name *"),
                  CustomTextFormField(
                    initialValue: adName,
                    hintText: 'Enter Ad Name',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Ad Name';
                      }
                      return null;
                    },
                    onChanged: handleAdNameChange,
                  ),
                  const SizedBox(height: 16.0),
                  const Text('Description *'),
                  CustomTextFormField(
                    initialValue: description,
                    hintText: 'Enter Description',
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Description';
                      }
                      return null;
                    },
                    onChanged: handleDescriptionChange,
                  ),
                  const SizedBox(height: 16.0),
                  const Text('Tag *'),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: tags.map((tag) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(tag),
                            const SizedBox(width: 4.0),
                            GestureDetector(
                              onTap: () => handleRemoveTag(tag),
                              child: const Icon(
                                Icons.close,
                                size: 16.0,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextFormField(
                          hintText: 'Enter a new tag',
                          onChanged: (value) {
                            setState(() {
                              newTag = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      AddTagButton(
                        onTap: handleAddTag,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  const Text('Negotiable *'),
                  DropdownButtonFormField<String>(
                    value: negotiable,
                    onChanged: handleNegotiableChange,
                    items: const [
                      DropdownMenuItem(
                        value: '',
                        child: Text('Select'),
                      ),
                      DropdownMenuItem(
                        value: 'Yes',
                        child: Text('Yes'),
                      ),
                      DropdownMenuItem(
                        value: 'No',
                        child: Text('No'),
                      ),
                    ],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(color: Color(0xFFC3C3C3), width: 1),
                      ),
                      contentPadding: const EdgeInsets.all(16.0),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text('Price (INR) *'),
                  CustomTextFormField(
                    initialValue: price,
                    hintText: 'Enter Price',
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Price';
                      }
                      return null;
                    },
                    onChanged: handlePriceChange,
                  ),
                  const SizedBox(height: 16.0),
                  const Text('Add Photos'),
                  const SizedBox(height: 8.0),
                  ImageUploader(
                    onImagesChanged: (imageFiles) {
                      setState(() {
                        _imageFiles = imageFiles;
                      });
                    },
                  ),
                  const SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: handleSubmit,
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
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
}

class CustomTextFormField extends StatefulWidget {
  final String? initialValue;
  final String? hintText;
  final int? maxLines;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;

  const CustomTextFormField({
    Key? key,
    this.initialValue,
    this.hintText,
    this.maxLines,
    this.keyboardType,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue ?? '');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
      ),
      maxLines: widget.maxLines,
      keyboardType: widget.keyboardType,
      onChanged: widget.onChanged,
      validator: widget.validator,
    );
  }
}
