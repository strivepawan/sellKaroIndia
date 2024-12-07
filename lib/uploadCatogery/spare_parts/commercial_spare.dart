
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import '../../models/add_tag_button.dart';
import '../../models/custom_text_field.dart';
import '../../models/image_upload.dart';
import '../../models/user_info.dart';
import '../uploadComponent/bottom_next_step.dart';

class CommercialSpare extends StatefulWidget {
  final String whichType;

  const CommercialSpare({super.key, required this.whichType});

  @override
  State<CommercialSpare> createState() => _CommercialSpareState();
}

class _CommercialSpareState extends State<CommercialSpare> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSubmitting = false;
  String adName = '';
  String description = '';
  List<String> tags = [];
  String negotiable = '';
  String newTag = '';
  String price = '';
  List<File> _imageFiles = [];
  String year = '';
  String  kmDriven = '';

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  TypeVehicle? selectedTypeVehicle;
  

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

  void handlePriceChange(String value) {
    setState(() {
      year = value;
    });
  }
  void handlekmDriven(String? value) { // Change parameter type to String?
  if (value != null && value.isNotEmpty) {
    setState(() {
      kmDriven = int.parse(value) as String; // Convert String to int
    });
  }
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
    final Reference storageReference =
        _firebaseStorage.ref().child('category/${path.basename(imageFile.path)}');
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

      final DocumentReference documentRef = FirebaseFirestore.instance
          .collection('category')
          .doc('SpareParts')
          .collection('ads')
          .doc();

      final String documentId = documentRef.id;

      await documentRef.set({
        'ad_name': adName,
        'tags': tags,
        'description': description,
        'price': price,
        'negotiable': negotiable,
        'images': imageUrls,
        'TypeVehicle': selectedTypeVehicle.toString().split('.').last,
        'timestamp': FieldValue.serverTimestamp(),
        'year': year, // Add year to the document data
        'km_driven': kmDriven, 
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
              addDocId: 'SpareParts',
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
                    const  Text('Type *'),
                    DropdownButtonFormField<TypeVehicle>(
                      value: selectedTypeVehicle,
                      onChanged: (newValue) {
                        setState(() {
                          selectedTypeVehicle = newValue;
                        });
                      },
                      items: TypeVehicle.values.map((period) {
                        return DropdownMenuItem(
                          value: period,
                          child: Text(period.toString().split('.').last),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:const  BorderSide(
                            color:Color(0xFFC3C3C3),
                            width: 1 ),
                        ),
                        contentPadding:const  EdgeInsets.all(16.0),
                      ),
                    ),
                   
                    const  SizedBox(height: 16.0),
                   const  Text('Year'),
                    CustomTextFormField(
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'which is Buy';
                        }
                        return null;
                      },
                      onChanged: handlePriceChange,
                        hintText: 'Which Year Buy',
                    ),
                    const SizedBox(height: 16.0),
                   const  Text('KM  driven'),
                    CustomTextFormField(
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Driven';
                        }
                        return null;
                      },
                      onChanged: handlekmDriven,
                        hintText: 'KM Driven',
                    ),
                   const  SizedBox(height: 16.0),
                     const Text("Ad Name *"),
                    CustomTextFormField(
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



enum TypeVehicle {
  hourly,
  // ignore: constant_identifier_names
  Buses,
  trucks,
  // ignore: constant_identifier_names
  Heavy_machine,
  // ignore: constant_identifier_names
  Modified_jeeps,
  // ignore: constant_identifier_names
  Pick_up_vans,
  // ignore: constant_identifier_names
  Scraps_Cars,
  // ignore: constant_identifier_names
  Taxi_cab,
  // ignore: constant_identifier_names
  Tractor,
  // ignore: constant_identifier_names
  Othter,
}
