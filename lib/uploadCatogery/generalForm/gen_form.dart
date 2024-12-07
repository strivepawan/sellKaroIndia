import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Import the generated localization file

import '../../models/add_tag_button.dart';
import '../../models/custom_text_field.dart';
import '../../models/image_upload.dart';
import '../../models/user_info.dart';
import '../uploadComponent/bottom_next_step.dart';

class GenForm extends StatefulWidget {
  final String whichType;
  final String docName;

  const GenForm({super.key, required this.whichType, required this.docName});

  @override
  State<GenForm> createState() => _GenFormState();
}

class _GenFormState extends State<GenForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isSubmitting = false;

  String adName = '';
  String description = '';
  List<String> tags = [];
  String negotiable = '';
  String newTag = '';
  String price = '';
  List<File> _imageFiles = [];

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

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

  Future<String> uploadImage(File imageFile) async {
    final Reference storageReference =
        _firebaseStorage.ref().child('category/${path.basename(imageFile.path)}');
    final TaskSnapshot uploadTask = await storageReference.putFile(imageFile);
    return await uploadTask.ref.getDownloadURL();
  }

  void handleSubmit() async {
    final localization = AppLocalizations.of(context)!;

    if (_formKey.currentState!.validate()) {
      if (_imageFiles.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(localization.pleaseAddAtLeastOnePhoto)),
        );
        return;
      }

      setState(() {
        isSubmitting = true;
      });

      try {
        List<String> imageUrls = [];
        for (File imageFile in _imageFiles) {
          final String imageUrl = await uploadImage(imageFile);
          imageUrls.add(imageUrl);
        }

        final DocumentReference documentRef = _firestore
            .collection('category')
            .doc(widget.docName)
            .collection('ads')
            .doc();

        await documentRef.set({
          'ad_name': adName,
          'tags': tags,
          'description': description,
          'price': price,
          'negotiable': negotiable,
          'images': imageUrls,
          'timestamp': FieldValue.serverTimestamp(),
        });

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContactUser(
              selectedCategory: 'category',
              docId: documentRef.id,
              collectionId: 'ads',
              addDocId: widget.docName,
            ),
          ),
        ).then((_) {
          setState(() {
            isSubmitting = false;
          });
        }).catchError((error) {
          setState(() {
            isSubmitting = false;
          });
          print('Error navigating to ContactUser: $error');
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
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

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
