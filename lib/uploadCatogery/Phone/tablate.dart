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

class TabletsForm extends StatefulWidget {
  final Function nextStep;

  TabletsForm({required this.nextStep});

  @override
  _TabletsFormState createState() => _TabletsFormState();
}

class _TabletsFormState extends State<TabletsForm> {
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
  'iPad': [
    'iPad Pro', 'iPad Air', 'iPad Mini', 'iPad', 'iPad 2',
    'iPad Pro 11', 'iPad Pro 12.9', 'iPad 3', 'iPad 4', 'iPad Mini 2',
    'iPad Mini 3', 'iPad Mini 4', 'iPad Air 2', 'iPad (5th generation)', 'iPad (6th generation)',
    'iPad (7th generation)', 'iPad (8th generation)', 'iPad (9th generation)'
  ],
  'Samsung': [
    'Galaxy Tab S7', 'Galaxy Tab S6', 'Galaxy Tab S5e', 'Galaxy Tab A7', 'Galaxy Tab A8',
    'Galaxy Tab S7+', 'Galaxy Tab S6 Lite', 'Galaxy Tab A 10.1', 'Galaxy Tab Active3', 'Galaxy Tab A 8.0',
    'Galaxy Tab S4', 'Galaxy Tab S3', 'Galaxy Tab A 8.4', 'Galaxy Tab A7 Lite', 'Galaxy Tab S8'
  ],
  'Google': [
    'Pixel Slate', 'Pixel C', 'Nexus 9',
    'Nexus 7', 'Nexus 10'
  ],
  'Microsoft': [
    'Surface Pro 7', 'Surface Pro X', 'Surface Go 2', 'Surface Pro 6', 'Surface Go',
    'Surface Pro 4', 'Surface Pro 5', 'Surface Pro 3', 'Surface Go 3', 'Surface Pro 8',
    'Surface Book', 'Surface Book 2'
  ],
  'Amazon': [
    'Fire HD 10', 'Fire HD 8', 'Fire 7', 'Kindle Fire', 'Kindle Paperwhite',
    'Fire HD 10 Plus', 'Fire HD 8 Plus', 'Fire HD Kids Edition', 'Fire HD 6', 'Fire HD 7',
    'Kindle Oasis', 'Kindle Voyage'
  ],
  'Huawei': [
    'MatePad Pro', 'MediaPad M5', 'MediaPad T5', 'MatePad 10.4', 'MatePad T8',
    'MediaPad M6', 'MediaPad T3', 'MatePad 11', 'MatePad Paper', 'MediaPad M3'
  ],
  'Lenovo': [
    'Tab P11 Pro', 'Tab M10', 'Yoga Smart Tab', 'Tab M8', 'Tab P11',
    'Tab M7', 'Tab P10', 'Tab E10', 'Yoga Tab 3', 'Yoga Tab 3 Pro',
    'Tab M10 Plus', 'Tab K10'
  ],
  'Asus': [
    'ZenPad 3S 10', 'ZenPad Z8s', 'ZenPad 10', 'Transformer Mini', 'Transformer 3 Pro',
    'ZenPad Z10', 'ZenPad 8.0', 'VivoTab', 'Transformer Pad', 'Memo Pad 7'
  ],
  'Acer': [
    'Iconia One 10', 'Iconia Tab 10', 'Iconia One 8', 'Iconia Tab 8', 'Switch Alpha 12',
    'Iconia One 7', 'Switch 7 Black Edition', 'Predator 8', 'Iconia One 7 B1', 'Iconia W4'
  ],
  'Sony': [
    'Xperia Z4 Tablet', 'Xperia Tablet Z', 'Xperia Z3 Tablet Compact', 'Xperia Z2 Tablet', 'Xperia Tablet S'
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
        .child('mobiles/${path.basename(imageFile.path)}}');
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
              padding:const  EdgeInsets.all(16.0),
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
                        contentPadding:const  EdgeInsets.all(16.0),
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
