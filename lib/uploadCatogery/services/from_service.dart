// import 'dart:io';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/add_tag_button.dart';
import '../../models/custom_text_field.dart';
import '../../models/image_upload.dart';
import '../../models/user_info.dart';
import '../uploadComponent/bottom_next_step.dart';

class ServiceForm extends StatefulWidget {
  final String whichType;
  final List<String>? serviceTypes;

  const ServiceForm({
    super.key,
    required this.whichType,
    this.serviceTypes,
  });

  @override
  State<ServiceForm> createState() => _ServiceFormState();
}

class _ServiceFormState extends State<ServiceForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSubmitting = false;
  String adName = '';
  String description = '';
  List<String> tags = [];
  String negotiable = '';
  String newTag = '';

  List<File> _imageFiles = [];
  String? selectedServiceType;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
 // Remove duplicate function definitions
void handleNegotiableChange(String? value) {
  setState(() {
    negotiable = value ?? '';
  });
}

void handleAddTag() {
  if (tags.length < 5 && newTag.trim() != '') {
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


Future<void> handleImageSelection() async {
    final pickedFiles = await ImagePicker().pickMultiImage(imageQuality: 80);
    setState(() {
      _imageFiles = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
    });
    }
Future<void> handleCameraClick() async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
  if (pickedFile != null) {
    setState(() {
      _imageFiles.add(File(pickedFile.path));
    });
  }
}


Future<String> uploadImage(File imageFile) async {
  final Reference storageReference = _firebaseStorage.ref().child('category/${path.basename(imageFile.path)}');
  final TaskSnapshot uploadTask = await storageReference.putFile(imageFile);
  final String imageUrl = await uploadTask.ref.getDownloadURL();
  return imageUrl;
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

      final DocumentReference documentRef = _firestore
          .collection('category')
          .doc('Service')
          .collection('ads')
          .doc();

      final String documentId = documentRef.id;

      await documentRef.set({
        'ad_name': adName,
        'tags': tags,
        'description': description,
        'negotiable': negotiable,
        'images': imageUrls,
        'service_type': selectedServiceType, 
        'timestamp': FieldValue.serverTimestamp(),

      });

      setState(() {
        isSubmitting = false;
      });

      BuildContext? currentContext = context;

      Future.delayed(Duration.zero, () {
        Navigator.push(
          currentContext,
          MaterialPageRoute(
            builder: (context) => ContactUser(
              selectedCategory: 'category',
              docId: documentId,
              collectionId: 'ads',
              addDocId: 'Service',
            ),
          ),
        ).then((value) {
          print('Navigation to ContactUser completed.');
        }).catchError((error) {
          print('Error navigating to ContactUser: $error');
        });
      });
    } catch (error) {
      setState(() {
        isSubmitting = false;
      });
      print('Error adding document to Firestore: $error');
    }
  }
}

// UI and other parts of the code remain unchanged


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.whichType),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.serviceTypes != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                         const  Text('Select Service Type *'),
                          DropdownButtonFormField(
                            value: selectedServiceType,
                            onChanged: (newValue) {
                              setState(() {
                                selectedServiceType = newValue;
                              });
                            },
                            items: widget.serviceTypes!
                                .map((serviceType) {
                                  return DropdownMenuItem(
                                    value: serviceType,
                                    child: Text(serviceType),
                                  );
                                })
                                .toList(),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide:const  BorderSide(
                                  color: Color(0xFFC3C3C3),
                                  width: 1),
                              ),
                              contentPadding: const EdgeInsets.all(16.0),
                            ),
                          ),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                   const Text("Titte *"),
                    CustomTextFormField(
                      hintText: 'Tittle',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter tittle';
                        }
                        return null;
                      },
                      onChanged: handleAdNameChange,
                    ),
                    const SizedBox(height: 16.0),
                    const Text('Description *'),
                    CustomTextFormField(
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
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(color: Color(0xFFC3C3C3), width: 1),
                        ),
                        contentPadding: const EdgeInsets.all(16.0),
                      ),
                    ),
                    // const SizedBox(height: 16.0),
                    // const Text('Price (INR) *'),
                    // CustomTextFormField(
                    //   hintText: 'Enter Price',
                    //   keyboardType: TextInputType.number,
                    //   validator: (value) {
                    //     if (value == null || value.isEmpty) {
                    //       return 'Please enter Price';
                    //     }
                    //     return null;
                    //   },
                    //   onChanged: handlePriceChange,
                    // ),
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
                  ],
                ),
              ),
            ),
          ),
          if (isSubmitting) const Center(child: CircularProgressIndicator()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarUpload(
        onNextPressed: handleSubmit,
        isLastStep: true,
      ),
    );
  }
}
