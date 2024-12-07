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

class CarsForm extends StatefulWidget {
  final Function nextStep;

  CarsForm({required this.nextStep});

  @override
  _CarsFormState createState() => _CarsFormState();
}

class _CarsFormState extends State<CarsForm> {
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
  'Tata Motors': [
    'Tiago', 'Tigor', 'Altroz', 'Nexon', 'Harrier',
    'Safari', 'Hexa', 'Sumo', 'Indica', 'Indigo',
    'Zest', 'Nano', 'Aria', 'Venture', 'Winger',
    'Xenon', 'Gravitas', 'EVision', 'H5X', 'Eagle'
  ],
  'Mahindra': [
    'Scorpio', 'XUV500', 'Thar', 'Bolero', 'XUV300',
    'KUV100', 'Marazzo', 'Alturas G4', 'e2o', 'eVerito',
    'TUV300', 'NuvoSport', 'Verito', 'Quanto', 'Logan',
    'Rexton', 'Marshal', 'Voyager', 'Libero', 'Furio'
  ],
  'Maruti Suzuki': [
    'Swift', 'Baleno', 'Dzire', 'Wagon R', 'Alto',
    'Ertiga', 'Vitara Brezza', 'Ciaz', 'Ignis', 'S-Presso',
    'S-Cross', 'XL6', 'Celerio', 'Omni', 'Eeco',
    'Gypsy', 'Zen', 'Esteem', 'Versa', 'A-Star'
  ],
  'Toyota': [
    'Corolla', 'Camry', 'Avalon', 'Highlander', 'Sienna',
    'RAV4', 'Tacoma', 'Tundra', 'Prius', '4Runner',
    'Land Cruiser', 'Sequoia', 'C-HR', 'Venza', 'Supra',
    'Yaris', 'Mirai'
  ],
  'Honda': [
    'Civic', 'Accord', 'CR-V', 'Pilot', 'Odyssey',
    'HR-V', 'Fit', 'Ridgeline', 'Passport', 'Insight',
    'Clarity', 'CR-Z', 'Element', 'S2000', 'Prelude'
  ],
  'Ford': [
    'F-150', 'Escape', 'Explorer', 'Mustang', 'Ranger',
    'Bronco', 'Edge', 'Expedition', 'Maverick', 'Fusion',
    'EcoSport', 'Taurus', 'Transit', 'Flex', 'Fiesta',
    'Focus', 'GT'
  ],
  'Chevrolet': [
    'Silverado', 'Equinox', 'Tahoe', 'Malibu', 'Traverse',
    'Colorado', 'Suburban', 'Blazer', 'Camaro', 'Bolt EV',
    'Trailblazer', 'Spark', 'Impala', 'Sonic', 'Corvette',
    'Cruze', 'Express'
  ],
  'BMW': [
    '3 Series', '5 Series', 'X3', 'X5', '7 Series',
    '1 Series', '2 Series', '4 Series', '6 Series', '8 Series',
    'X1', 'X2', 'X4', 'X6', 'X7',
    'Z4', 'i3', 'i8', 'M3', 'M5',
    'M4', 'M2', 'M6', 'i4', 'iX'
  ],
  'Mercedes-Benz': [
    'C-Class', 'E-Class', 'S-Class', 'GLC', 'GLE',
    'A-Class', 'CLA', 'GLA', 'GLS', 'G-Class',
    'B-Class', 'SL', 'SLC', 'EQC', 'EQS',
    'AMG GT', 'AMG A 35', 'AMG CLA 45', 'AMG GLE 63', 'AMG E 63'
  ],
  'Audi': [
    'A3', 'A4', 'A6', 'A8', 'Q3',
    'Q5', 'Q7', 'Q8', 'TT', 'R8',
    'S3', 'S4', 'S5', 'S6', 'S7',
    'RS 3', 'RS 5', 'RS 7', 'e-tron', 'e-tron GT'
  ],
  'Tesla': [
    'Model S', 'Model 3', 'Model X', 'Model Y', 'Roadster',
    'Cybertruck'
  ],
  'Nissan': [
    'Altima', 'Sentra', 'Maxima', 'Rogue', 'Murano',
    'Pathfinder', 'Armada', 'Frontier', 'Titan', 'Versa',
    '370Z', 'GT-R', 'Kicks', 'Leaf', 'Juke',
    'Xterra', 'NV200'
  ],
  'Hyundai': [
    'Elantra', 'Sonata', 'Tucson', 'Santa Fe', 'Palisade',
    'Kona', 'Venue', 'Accent', 'Veloster', 'Ioniq',
    'Nexo', 'Azera', 'Genesis', 'Equus', 'Santa Cruz'
  ],
  'Suzuki': [
    'Swift', 'Baleno', 'Vitara', 'Ciaz', 'Alto',
    'Wagon R', 'Ertiga', 'XL6', 'Ignis', 'S-Cross',
    'Dzire', 'Jimny', 'Celerio', 'Grand Vitara', 'Kizashi',
    'APV', 'A-Star', 'Ritz', 'SX4', 'Brezza',
    'Estilo', 'Omni', 'Eeco', 'S-Presso', 'Liana',
    'Escudo', 'Forenza', 'Aerio', 'Equator', 'Splash'
  ],
  'other' :['other']
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
    final Reference storageReference = _firebaseStorage.ref().child('cars/${path.basename(imageFile.path)}}');
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

        // Post data to the "cars" subcollection under the main collection "Automobiles"
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
        title: const Text('Add Car'),
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
                    const SizedBox(height: 4.0),
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
                          child: Text('Other'),
                        ),
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
