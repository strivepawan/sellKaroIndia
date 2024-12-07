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

class BikesForm extends StatefulWidget {
  final Function nextStep;

  BikesForm({required this.nextStep});

  @override
  _BikesFormState createState() => _BikesFormState();
}

class _BikesFormState extends State<BikesForm> {
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
  String yearOfPurchase = '';
  String fuelType = '';
  String kilometersDriven = '';
  String numberOfOwners = '';
  String transmissionType = '';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

final Map<String, List<String>> brandModelMap = {
  'Hero': [
    'Splendor', 'Passion', 'Glamour', 'Xtreme', 'HF Deluxe',
    'Super Splendor', 'Maestro Edge', 'Destini 125', 'Pleasure+', 'Xpulse 200',
    'Xpulse 200T', 'Xtreme 160R', 'Splendor iSmart', 'Duet', 'Karizma ZMR'
  ],
  'Bajaj': [
    'Pulsar', 'Platina', 'CT 100', 'Dominar', 'Avenger',
    'Pulsar NS200', 'Pulsar 150', 'Pulsar 220F', 'Discover 125', 'Discover 110',
    'Platina 110', 'CT 110', 'Dominar 400', 'Avenger Street 160', 'Avenger Cruise 220'
  ],
  'Royal Enfield': [
    'Classic', 'Bullet', 'Himalayan', 'Interceptor', 'Continental GT',
    'Meteor 350', 'Thunderbird 350', 'Thunderbird 500', 'Classic 500', 'Bullet Trials 500',
    'Classic 350', 'Scram 411', 'Hunter 350', '650 Twin', 'Bullet Electra'
  ],
  'Honda': [
    'CB Shine', 'Activa', 'CBR', 'Unicorn', 'Livo',
    'Dio', 'Hornet 2.0', 'Hness CB350', 'CD 110 Dream', 'X-Blade',
    'Grazia', 'Unicorn 160', 'CB200X', 'CB350RS', 'Gold Wing'
  ],
  'TVS': [
    'Apache RTR 160', 'Apache RTR 200', 'Jupiter', 'NTorq', 'Star City Plus',
    'Sport', 'Scooty Pep+', 'Scooty Zest', 'Radeon', 'Victor',
    'Apache RR 310', 'XL100', 'iQube Electric', 'Jupiter Grande', 'Jupiter Classic'
  ],
  'Suzuki': [
    'Access', 'Gixxer', 'Hayabusa', 'Intruder', 'V-Strom',
    'Burgman Street', 'Gixxer SF', 'Gixxer 250', 'GSX-R1000', 'GSX-S750',
    'V-Strom 650XT', 'Gixxer 150', 'Gixxer SF 250', 'Intruder 150', 'V-Strom 250'
  ],
  'Yamaha': [
    'FZ', 'FZS', 'R15', 'MT-15', 'Fascino',
    'RayZR', 'Saluto', 'SZ-RR', 'FZ 25', 'YZF-R3',
    'FZ-S FI', 'FZ FI', 'R15 V3', 'MT-09', 'Aerox 155'
  ],
  'KTM': [
    'Duke 200', 'Duke 390', 'RC 200', 'RC 390', '125 Duke',
    '250 Duke', '390 Adventure', 'RC 125', '250 Adventure', '890 Duke',
    '1290 Super Duke R', '390 Duke BS6', '125 Duke BS6', '250 Duke BS6', '390 Adventure BS6'
  ],
  'BMW': [
    'G 310 R', 'G 310 GS', 'R 1250 GS', 'S 1000 RR', 'F 850 GS',
    'R 1250 RT', 'R 18', 'K 1600 B', 'G 310 GS BS6', 'G 310 R BS6',
    'R nineT', 'F 750 GS', 'S 1000 XR', 'K 1600 GTL', 'F 900 R'
  ],
  'Harley-Davidson': [
    'Iron 883', 'Forty-Eight', 'Street Rod', 'Fat Boy', 'Roadster',
    'Sportster S', 'Low Rider S', 'Street 750', 'Street 500', 'LiveWire',
    'Pan America 1250', 'Heritage Classic', 'Road King', 'Fat Bob', 'Softail Standard'
  ],
  'OTHER':['Other']
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

  void handleYearOfPurchaseChange(String value) {
    setState(() {
      yearOfPurchase = value;
    });
  }

  void handleKilometersDrivenChange(String value) {
    setState(() {
      kilometersDriven = value;
    });
  }

  void handleTransmissionTypeChange(String? value) {
    setState(() {
      transmissionType = value ?? '';
    });
  }

  void handleFuelTypeChange(String? value) {
    setState(() {
      fuelType = value ?? '';
    });
  }

  void handleNumberOfOwnersChange(String? value) {
    setState(() {
      numberOfOwners = value ?? '';
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
    final Reference storageReference = _firebaseStorage.ref().child('bikes/${path.basename(imageFile.path)}');
    await storageReference.putFile(imageFile);
    final String imageUrl = await storageReference.getDownloadURL();
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

        // Post data to the "bikes" subcollection under the main collection "Automobiles"
        final DocumentReference documentRef = _firestore.collection('category').doc('Vehicle').collection('ads').doc(); // Generate a new document reference
        
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
          'year_of_purchase': yearOfPurchase,
          'fuel_type': fuelType,
          'kilometers_driven': kilometersDriven,
          'number_of_owners': numberOfOwners,
          'transmission_type': transmissionType,
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
                addDocId: 'Vehicle',

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
        title:const  Text('Add Bike'),
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
                            color:Color(0xFFC3C3C3),
                            width: 1 ),
                        ),
                        contentPadding:const  EdgeInsets.all(16.0),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text('Model *'),
                    if (brand.isNotEmpty)
                      DropdownButtonFormField<String>(
                        value: model.isNotEmpty ? model : null,
                        onChanged: handleModelChange,
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text('Select Model'),
                          ),
                          ...modelOptions.map((modelName) {
                            return DropdownMenuItem(
                              value: modelName,
                              child: Text(modelName),
                            );
                          }).toList(),
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide:const  BorderSide(
                            color:Color.fromARGB(255, 72, 67, 67),
                            width: 1 ),
                          ),
                          contentPadding:const  EdgeInsets.all(16.0),
                        ),
                      ),
                    const SizedBox(height: 16.0),
                    const Text('Year of Purchase *'),
                    CustomTextFormField(
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Year of Purchase';
                        }
                        return null;
                      },
                      onChanged: handleYearOfPurchaseChange,
                        hintText: 'Enter Year of Purchase',
                    ),
                   
                    const SizedBox(height: 16.0),
                    const Text('Kilometers Driven *'),
                    CustomTextFormField(
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter Kilometers Driven';
                        }
                        return null;
                      },
                      onChanged: handleKilometersDrivenChange,
                      hintText: 'Enter Kilometers Driven',
                    ),
                    const SizedBox(height: 16.0),
                    const Text('Transmission Type *'),
                    DropdownButtonFormField<String>(
                      value: transmissionType.isNotEmpty ? transmissionType : null,
                      onChanged: handleTransmissionTypeChange,
                      items:const  [
                        DropdownMenuItem(
                          value: '',
                          child: Text('Select'),
                        ),
                        DropdownMenuItem(
                          value: 'Automatic',
                          child: Text('Automatic'),
                        ),
                        DropdownMenuItem(
                          value: 'Manual',
                          child: Text('Manual'),
                        ),
                      ],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:const  BorderSide(
                            color:Color(0xFFC3C3C3),
                            width: 1 ),
                        ),
                        contentPadding:const  EdgeInsets.all(16.0),
                      ),
                    ),

                    // Similarly for Fuel Type
                    const Text('Fuel Type *'),
                    DropdownButtonFormField<String>(
                      value: fuelType.isNotEmpty ? fuelType : null,
                      onChanged: handleFuelTypeChange,
                      items:const  [
                        DropdownMenuItem(
                          value: '',
                          child: Text('Select'),
                        ),
                        DropdownMenuItem(
                          value: 'Petrol',
                          child: Text('Petrol'),
                        ),
                        DropdownMenuItem(
                          value: 'Diesel',
                          child: Text('Diesel'),
                        ),
                        DropdownMenuItem(
                          value: 'CNG',
                          child: Text('CNG'),
                        ),
                        DropdownMenuItem(
                          value: 'Electric',
                          child: Text('Electric'),
                        ),
                        DropdownMenuItem(
                          value: 'Other',
                          child: Text('Other'))
                      ],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: const BorderSide(
                          color: Color(0xFFC3C3C3),
                            width: 1),
                        ),
                        contentPadding:const  EdgeInsets.all(16.0),
                      ),
                    ),

                    // And for Number of Owners
                    const Text('Number of Owners *'),
                    DropdownButtonFormField<String>(
                      value: numberOfOwners.isNotEmpty ? numberOfOwners : null,
                      onChanged: handleNumberOfOwnersChange,
                      items:const  [
                        DropdownMenuItem(
                          value: '',
                          child: Text('Select'),
                        ),
                        DropdownMenuItem(
                          value: '1',
                          child: Text('1st'),
                        ),
                        DropdownMenuItem(
                          value: '2',
                          child: Text('2nd'),
                        ),
                        DropdownMenuItem(
                          value: '3',
                          child: Text('3rd'),
                        ),
                        DropdownMenuItem(
                          value: '4+',
                          child: Text('4th'),
                        ),
                      ],
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide:const  BorderSide(
                           color: Color(0xFFC3C3C3),
                           width: 1 ),
                        ),
                        contentPadding:const EdgeInsets.all(16.0),
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
