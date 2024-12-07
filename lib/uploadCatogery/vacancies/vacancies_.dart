import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import the generated localization file

import '../../models/add_tag_button.dart';
import '../../models/custom_text_field.dart';
import '../../models/image_upload.dart';
import '../../models/user_info.dart';
import '../uploadComponent/bottom_next_step.dart';

class JobVacancies extends StatefulWidget {
  final String whichType;

  const JobVacancies({super.key, required this.whichType});

  @override
  State<JobVacancies> createState() => _JobVacanciesState();
}

class _JobVacanciesState extends State<JobVacancies> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSubmitting = false;
  String adName = '';
  String description = '';
  List<String> tags = [];
  String negotiable = '';
  String newTag = '';
  String price = '';
  List<File> _imageFiles = [];

  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  SalaryPeriod? selectedSalaryPeriod;
  PositionType? selectedPositionType;

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
      price = value;
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
          .doc('Vacancies')
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
        'salary_period': selectedSalaryPeriod.toString().split('.').last,
        'position_type': selectedPositionType.toString().split('.').last,
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
              addDocId: 'Vacancies',
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
        final AppLocalizations localization = AppLocalizations.of(context)!;
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
                    const  Text('Salary Period *'),
                    DropdownButtonFormField<SalaryPeriod>(
                      value: selectedSalaryPeriod,
                      onChanged: (newValue) {
                        setState(() {
                          selectedSalaryPeriod = newValue;
                        });
                      },
                      items: SalaryPeriod.values.map((period) {
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
                          borderSide:const BorderSide(
                          color: Color(0xFFC3C3C3),
                          width: 1),
                        ),
                        contentPadding:const EdgeInsets.all(16.0),
                      ),
                    ),
                   const  SizedBox(height: 16.0),
                    const Text('Position Type *'),
                    DropdownButtonFormField<PositionType>(
                      value: selectedPositionType,
                      onChanged: (newValue) {
                        setState(() {
                          selectedPositionType = newValue;
                        });
                      },
                      items: PositionType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.toString().split('.').last),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                         borderSide:const BorderSide(
                          color: Color(0xFFC3C3C3),
                          width: 1),
                        ),
                        contentPadding:const EdgeInsets.all(16.0),
                      ),
                    ),
                    const  SizedBox(height: 16.0),
                   const  Text('Salary To'),
                    CustomTextFormField(
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter salery';
                        }
                        return null;
                      },
                      onChanged: handlePriceChange,
                        hintText: 'Expected salary'
                    ),
                   const  SizedBox(height: 16.0),
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
          if (isSubmitting) const Center(child: CircularProgressIndicator()),
        ],
      ),
      bottomNavigationBar: BottomNavigationBarUpload(
        onNextPressed: handleSubmit,
        isLastStep: true,
      ),
    );
  }
  
   String formatPrice(String price) {
    if (price.isEmpty) return price;
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '', decimalDigits: 0);
    return formatter.format(int.parse(price));
  }
}



enum SalaryPeriod {
  hourly,
  weekly,
  monthly,
  yearly,
}

enum PositionType {
  contract,
  fullTime,
  partTime,
  temporary,
}
