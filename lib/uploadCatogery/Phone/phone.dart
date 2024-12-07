import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

import '../../models/add_tag_button.dart';
import '../../models/custom_text_field.dart';
import '../../models/image_upload.dart';
import '../../models/user_info.dart';
import '../uploadComponent/bottom_next_step.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class MobilesForm extends StatefulWidget {
  final Function nextStep;

  MobilesForm({required this.nextStep});

  @override
  _MobilesFormState createState() => _MobilesFormState();
}

class _MobilesFormState extends State<MobilesForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSubmitting = false;
  String brand = '';
  String model = '';
  String adName = '';
  List<String> tags = [];
  String description = '';
  String price = '';
  String negotiable = '';
  String newTag = '';
  List<String> modelOptions = [];
  List<File> _imageFiles = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  final Map<String, List<String>> brandModelMap = {
  'iPhone': [
    'iPhone 12', 'iPhone 13', 'iPhone 14', 'iPhone 15', 'iPhone 16',
    'iPhone SE (2020)', 'iPhone SE (2022)', 'iPhone 11', 'iPhone 11 Pro', 'iPhone 11 Pro Max',
    'iPhone 12 Mini', 'iPhone 13 Mini', 'iPhone 14 Pro', 'iPhone 14 Pro Max'
  ],
  'Samsung': [
    'Galaxy S21', 'Galaxy S20', 'Galaxy Note 20', 'Galaxy A72', 'Galaxy A52',
    'Galaxy S21 Ultra', 'Galaxy S21 FE', 'Galaxy Z Fold 3', 'Galaxy Z Flip 3', 'Galaxy A32',
    'Galaxy S22', 'Galaxy S22+', 'Galaxy S22 Ultra', 'Galaxy A52s', 'Galaxy A03s'
  ],
  'Google Pixel': [
    'Pixel 6 Pro', 'Pixel 6', 'Pixel 5a', 'Pixel 4a', 'Pixel 4',
    'Pixel 4 XL', 'Pixel 3a', 'Pixel 3a XL', 'Pixel 5', 'Pixel 6a',
    'Pixel 7', 'Pixel 7 Pro'
  ],
  'OnePlus': [
    'OnePlus 9 Pro', 'OnePlus 9', 'OnePlus 8T', 'OnePlus 8', 'OnePlus Nord',
    'OnePlus 9R', 'OnePlus Nord 2', 'OnePlus Nord CE', 'OnePlus 8 Pro', 'OnePlus 7T',
    'OnePlus 10 Pro', 'OnePlus Nord 2T', 'OnePlus 10R'
  ],
  'Xiaomi': [
    'Mi 11 Ultra', 'Mi 11', 'Mi 10T Pro', 'Mi 10T', 'Redmi Note 10 Pro',
    'Mi 11 Lite', 'Redmi Note 10', 'Redmi 9', 'Poco X3', 'Poco F3',
    'Mi Mix Fold', 'Redmi Note 10S', 'Redmi Note 11 Pro', 'Mi 11X', 'Mi 11X Pro'
  ],
  'Oppo': [
    'Find X3 Pro', 'Reno6 Pro', 'Reno6', 'A74', 'A54',
    'Find X2 Pro', 'Reno5 Pro', 'Reno5', 'A94', 'A53',
    'Reno7 Pro', 'Reno7', 'Find X5 Pro'
  ],
  'Huawei': [
    'P40 Pro', 'P40', 'Mate 40 Pro', 'Mate 30 Pro', 'Nova 7i',
    'P30 Pro', 'P30', 'Mate 20 Pro', 'Mate X2', 'Y9a',
    'P50 Pro', 'P50 Pocket', 'Nova 9', 'Nova 8i'
  ],
  'Sony': [
    'Xperia 1 III', 'Xperia 5 III', 'Xperia 10 III', 'Xperia 1 II', 'Xperia 5 II',
    'Xperia Pro-I', 'Xperia L4', 'Xperia 10 II', 'Xperia Ace II'
  ],
  'Nokia': [
    'Nokia 8.3 5G', 'Nokia 7.2', 'Nokia 6.2', 'Nokia 5.3', 'Nokia 3.4',
    'Nokia 2.4', 'Nokia 1.4', 'Nokia G10', 'Nokia G20', 'Nokia X20',
    'Nokia 8.1', 'Nokia 5.4'
  ],
  'Motorola': [
    'Moto G100', 'Moto G60', 'Moto G30', 'Moto G Power', 'Moto G Stylus',
    'Moto G9 Plus', 'Moto G9 Play', 'Edge 20 Pro', 'Edge 20', 'Moto E7',
    'Moto G200', 'Moto G71', 'Moto Edge X30'
  ],
  'Realme': [
    'Realme GT', 'Realme 8 Pro', 'Realme 8', 'Realme 7', 'Realme 7 Pro',
    'Realme Narzo 30', 'Realme X7', 'Realme C25', 'Realme C21', 'Realme C15',
    'Realme GT Master Edition', 'Realme 9 Pro', 'Realme 9i'
  ],
  'Other':['Other']
};


  void handleBrandChange(String? selectedBrand) {
    setState(() {
      brand = selectedBrand!;
      model = '';
      // Clear the model when the brand changes
      modelOptions.clear();
      // Populate modelOptions based on the selected brand
      if (brandModelMap.containsKey(brand)) {
        modelOptions = brandModelMap[brand]!;
      }
    });
  }

  void handleNegotiableChange(String? value) {
    setState(() {
      negotiable = value ?? '';
    });
  }

  void handleModelChange(String? selectedModel) {
    setState(() {
      model = selectedModel!;
    });
  }

  void 
  handleAddTag() {
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
      price = value.replaceAll(',', '');
    });
  }
  String formatPrice(String price) {
  if (price.isEmpty) return price;
  final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '', decimalDigits: 0);
  return formatter.format(int.parse(price));
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
    final Reference storageReference = _firebaseStorage
        .ref()
        .child('category/${path.basename(imageFile.path)}}');
    await storageReference.putFile(imageFile);
    final String imageUrl = await storageReference.getDownloadURL();
    return imageUrl;
  }

  // Inside MobilesForm

  // Inside the _MobilesFormState class
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

        // Post data to the "mobiles" subcollection under the main collection "SmartDevice"
        final DocumentReference documentRef = _firestore.collection('category').doc('Device').collection('ads').doc(); // Generate a new document reference
        
        // Get the document ID
        final String documentId = documentRef.id;

        // Update the document with the desired data
        await documentRef.set({
          'brand': brand,
          'model': model,
          'ad_name': adName,
          'tags': tags,
          'description': description,
          'price': price,
          'negotiable': negotiable,
          'images': imageUrls,
          'timestamp': Timestamp.now(),
        });

        setState(() {
          isSubmitting = false;
        });

        // Store the BuildContext before navigating
        BuildContext? currentContext = context;
        
        // Navigate to ContactUser screen after setting data in Firestore
        Future.delayed(Duration.zero, () {
          Navigator.push(
            currentContext,
            MaterialPageRoute(
              builder: (context) => ContactUser(
                selectedCategory: 'category',
                docId: documentId, // Pass the document ID
                collectionId: 'ads', 
                addDocId: 'Device',

              ),
            ),
          ).then((value) {
            // Handle navigation completion if needed
            print('Navigation to ContactUser completed.');
          }).catchError((error) {
            // Handle navigation error
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
    final AppLocalizations localization = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title:const  Text('Add post'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding:const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Brand *'),
                    DropdownButtonFormField<String>(
                      value: brand.isNotEmpty ? brand : null,
                      onChanged: handleBrandChange,
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text('Select'),
                        ),
                        ...brandModelMap.keys.map((brandName) {
                          return DropdownMenuItem(
                            value: brandName,
                            child: Text(brandName),
                          );
                        }).toList(),
                      ],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:const BorderSide(
                            color: Color(0xFFC3C3C3),
                            width: 1),
                        ),
                        contentPadding: EdgeInsets.all(16.0),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  Text(localization.title),
                  CustomTextFormField(
                    hintText: localization.pleaseEnterAdTitle,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localization.pleaseEnterAdTitle;
                      }
                      return null;
                    },
                    onChanged: handleAdNameChange,
                  ),
                  const SizedBox(height: 16.0),
                  Text(localization.description),
                  CustomTextFormField(
                    hintText: localization.pleaseEnterDescription,
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localization.pleaseEnterDescription;
                      }
                      return null;
                    },
                    onChanged: handleDescriptionChange,
                  ),
                  const SizedBox(height: 16.0),
                  Text(localization.tag),
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
                          hintText: localization.pleaseEnterDescription,
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
                  Text(localization.negotiable),
                  DropdownButtonFormField<String>(
                    value: negotiable.isEmpty ? null : negotiable,
                    onChanged: handleNegotiableChange,
                    items: [
                      DropdownMenuItem(
                        value: 'Yes',
                        child: Text(localization.yes),
                      ),
                      DropdownMenuItem(
                        value: 'No',
                        child: Text(localization.no),
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localization.pleaseSelectNegotiableOption;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Text(localization.price),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFC3C3C3),
                          width: 1.0,
                        ),
                      ),
                      contentPadding: const EdgeInsets.all(16.0),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        final newText = formatPrice(newValue.text);
                        return newValue.copyWith(
                          text: newText,
                          selection: TextSelection.collapsed(offset: newText.length),
                        );
                      }),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localization.pleaseEnterPrice;
                      }
                      return null;
                    },
                    onChanged: handlePriceChange,
                  ),
                  const SizedBox(height: 16.0),
                  Text(localization.addPhotos),
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
          if(isSubmitting) const CircularProgressIndicator(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarUpload(
        onNextPressed: handleSubmit,
        isLastStep: true, // Set this based on your logic
      ),
    );
  }
}
