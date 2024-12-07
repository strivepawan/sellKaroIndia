import 'dart:io';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/add_tag_button.dart';
import '../../../models/custom_drop_down.dart';
import '../../../models/custom_text_field.dart';
import '../../../models/image_upload.dart';
import '../../../models/user_info.dart';
import '../../uploadComponent/bottom_next_step.dart';

class ShoopOfficeShowroom extends StatefulWidget {
  const ShoopOfficeShowroom({super.key});

  @override
  _ShoopOfficeShowroomState createState() => _ShoopOfficeShowroomState();
}

class _ShoopOfficeShowroomState extends State<ShoopOfficeShowroom> {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? selectedType;
  String? selectedBedroom;
  String? selectedBathroom;
  String? selectedFurnished;
  String? selectedConstructionStatus;
  String? selectedListedBy;
  String? selectedFacing;
  String? projectName = '';
  String? adTitle = '';
  String? description = '';
  String? superBuiltUpArea;
  String? carpetArea;
  String? maintenanceMonth;
  String? totalFloors;
  String? carParking;
 bool isSubmitting = false;
  String adName = '';
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

        final DocumentReference documentRef = _firestore
            .collection('category')
            .doc('Property')
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
          'timestamp': FieldValue.serverTimestamp(),
          'type': selectedType,
          'bedroom': selectedBedroom,
          'bathroom': selectedBathroom,
          'furnished': selectedFurnished,
          'construction_status': selectedConstructionStatus,
          'listed_by': selectedListedBy,
          'facing': selectedFacing,
          'super_built_up_area': superBuiltUpArea,
          'carpet_area': carpetArea,
          'maintenance_month': maintenanceMonth,
          'total_floors': totalFloors,
          'car_parking': carParking,
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
                addDocId: 'Property',
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
    title: const Text('Property Form'),
  ),
  body: Stack(
    children: [
      SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text("Type"),
              CustomDropdownFormField(
                value: selectedType,
                onChanged: (newValue) {
                  setState(() {
                    selectedType = newValue;
                  });
                },
                items: const ['Shop', 'Office', 'Showroom', 'SOHO'],
                hintText: 'Select Type',
              ),
              const SizedBox(height: 16.0),
              const Text("Bedroom"),
              CustomDropdownFormField(
                value: selectedBedroom,
                onChanged: (newValue) {
                  setState(() {
                    selectedBedroom = newValue;
                  });
                },
                items: const ['1', '2', '3', '4'],
                hintText: 'Select Bedroom',
              ),
              const SizedBox(height: 16.0),
              const Text("Bathrooms"),
              CustomDropdownFormField(
                value: selectedBathroom,
                onChanged: (newValue) {
                  setState(() {
                    selectedBathroom = newValue;
                  });
                },
                items: const ['1', '2', '3', '4'],
                hintText: 'Select Bathrooms',
              ),
              const SizedBox(height: 16.0),
              const Text("Furnished"),
              CustomDropdownFormField(
                value: selectedFurnished,
                onChanged: (newValue) {
                  setState(() {
                    selectedFurnished = newValue;
                  });
                },
                items: const ['Furnished', 'Semi-furnished', 'Unfurnished'],
                hintText: 'Select Furnished',
              ),
              const SizedBox(height: 16.0),
              const Text("Listed By"),
              CustomDropdownFormField(
                value: selectedListedBy,
                onChanged: (newValue) {
                  setState(() {
                    selectedListedBy = newValue;
                  });
                },
                items: const ['Builder', 'Dealer', 'Owner'],
                hintText: 'Select Listed By',
              ),
              const SizedBox(height: 16.0),
              const Text("Facing"),
              CustomDropdownFormField(
                value: selectedFacing,
                onChanged: (newValue) {
                  setState(() {
                    selectedFacing = newValue;
                  });
                },
                items: const ['East', 'North', 'South', 'West', 'Other'],
                hintText: 'Select Facing',
              ),
              const SizedBox(height: 16.0),
              const Text("Area in Square Yards"),
              CustomTextFormField(
                onChanged: (value) {
                  setState(() {
                    superBuiltUpArea = int.tryParse(value)?.toString();
                  });
                },
                keyboardType: TextInputType.number,
                hintText: 'Enter Area in Square Yards',
              ),
              const SizedBox(height: 16.0),
              const Text("Covered Area in Square Feet"),
              CustomTextFormField(
                onChanged: (value) {
                  setState(() {
                    carpetArea = int.tryParse(value)?.toString();
                  });
                },
                keyboardType: TextInputType.number,
                hintText: 'Enter Covered Area in Square Feet',
              ),
              const SizedBox(height: 16.0),
              const Text("Total Floors"),
              CustomDropdownFormField(
                value: totalFloors,
                onChanged: (newValue) {
                  setState(() {
                    totalFloors = newValue;
                  });
                },
                items: const ['1st', '2nd', '3rd', '4th', '5th', 'Above'],
                hintText: 'Select Total Floors',
              ),
              const SizedBox(height: 16.0),
              const Text("Available Parking"),
              CustomDropdownFormField(
                value: carParking,
                onChanged: (newValue) {
                  setState(() {
                    carParking = newValue;
                  });
                },
                items: const ['Yes', 'No'],
                hintText: 'Select Available Parking',
              ),
              const SizedBox(height: 16.0),
              const Text("Title *"),
              CustomTextFormField(
                hintText: 'Enter Ad Title',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Ad Title';
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
              const Text('Tags *'),
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
                      hintText: 'Enter a New Tag',
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
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: const BorderSide(
                      color: Color(0xFFC3C3C3), // Side edges color
                      width: 1.0, // Border width
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
