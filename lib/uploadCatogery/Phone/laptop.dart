// laptop_form.dart

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

class LaptopForm extends StatefulWidget {
  final Function nextStep;

  LaptopForm({required this.nextStep});

  @override
  _LaptopFormState createState() => _LaptopFormState();
}

class _LaptopFormState extends State<LaptopForm> {
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
  'Dell': [
    'Inspiron 15', 'XPS 13', 'Alienware M15', 'Latitude 5410', 'Vostro 15',
    'Inspiron 14', 'XPS 15', 'Alienware Area-51m', 'Latitude 7400', 'G5 15'
  ],
  'HP': [
    'Envy x360', 'Pavilion Gaming 15', 'Omen 15', 'ProBook 450 G7', 'ZBook 15',
    'Spectre x360', 'Elite Dragonfly', 'Pavilion x360', 'ZBook Studio G7', 'ProBook 640 G5'
  ],
  'Lenovo': [
    'ThinkPad X1 Carbon', 'Yoga C940', 'IdeaPad 330S', 'Legion Y540', 'ThinkPad P53',
    'ThinkPad T490', 'Yoga 730', 'IdeaPad S145', 'Legion Y7000', 'ThinkBook 14'
  ],
  'Asus': [
    'ZenBook 14', 'VivoBook X512FA', 'ROG Zephyrus G14', 'TUF Gaming FX505DT', 'ProArt StudioBook 15',
    'ZenBook Pro Duo', 'VivoBook S15', 'ROG Strix Scar III', 'TUF Gaming A15', 'ExpertBook B9450'
  ],
  'Apple': [
    'MacBook Air', 'MacBook Pro 13', 'MacBook Pro 15', 'MacBook 12', 'MacBook Pro 16',
    'MacBook Pro 14', 'MacBook Pro 17', 'MacBook Pro 13 M1', 'MacBook Pro 16 M1', 'MacBook Air M1'
  ],
  'Acer': [
    'Aspire 5', 'Nitro 5', 'Predator Helios 300', 'Swift 3', 'Spin 5',
    'Aspire 7', 'Chromebook 14', 'Predator Triton 500', 'Swift 5', 'ConceptD 7'
  ],
  'Microsoft': [
    'Surface Laptop 3', 'Surface Pro 7', 'Surface Book 2', 'Surface Go 2', 'Surface Laptop Go',
    'Surface Laptop 4', 'Surface Pro X', 'Surface Book 3', 'Surface Go 3', 'Surface Pro 6'
  ],
  'MSI': [
    'GF63 Thin', 'GL65 Leopard', 'GS66 Stealth', 'Prestige 14', 'Creator 15',
    'GT76 Titan', 'GE66 Raider', 'GF65 Thin', 'Modern 14', 'Alpha 15'
  ],
  'Razer': [
    'Blade 15', 'Blade Stealth 13', 'Blade Pro 17', 'Blade 14', 'Blade Advanced',
    'Blade 15 Base', 'Blade Stealth 12', 'Blade Pro 15', 'Blade Studio Edition', 'Blade 15 Studio'
  ],
  'Samsung': [
    'Galaxy Book Flex', 'Galaxy Book Ion', 'Galaxy Chromebook', 'Notebook 9 Pro', 'Galaxy Book S',
    'Notebook Odyssey', 'Galaxy Book', 'Notebook 7 Spin', 'Notebook 5', 'Chromebook 4'
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
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:const BorderSide(
                          color: Color(0xFFC3C3C3),
                          width: 1)
                        ),
                        contentPadding: const EdgeInsets.all(16.0),
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
