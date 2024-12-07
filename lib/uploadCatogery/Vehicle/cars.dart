import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
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
      'Xenon', 'Gravitas', 'EVision', 'H5X', 'Eagle',
      'Harrier EV' // New addition
    ],
    'Mahindra': [
      'Scorpio', 'XUV500', 'Thar', 'Bolero', 'XUV300',
      'KUV100', 'Marazzo', 'Alturas G4', 'e2o', 'eVerito',
      'TUV300', 'NuvoSport', 'Verito', 'Quanto', 'Logan',
      'Rexton', 'Marshal', 'Voyager', 'Libero', 'Furio',
      'BE 6e', 'XEV 9e' // New additions
    ],
    'Maruti Suzuki': [
      'Swift', 'Baleno', 'Dzire', 'Wagon R', 'Alto',
      'Ertiga', 'Vitara Brezza', 'Ciaz', 'Ignis', 'S-Presso',
      'S-Cross', 'XL6', 'Celerio', 'Omni', 'Eeco',
      'Gypsy', 'Zen', 'Esteem', 'Versa', 'A-Star',
      'eVX', 'e-Vitara' // New additions
    ],
    'Toyota': [
      'Corolla', 'Camry', 'Avalon', 'Highlander', 'Sienna',
      'RAV4', 'Tacoma', 'Tundra', 'Prius', '4Runner',
      'Land Cruiser', 'Sequoia', 'C-HR', 'Venza', 'Supra',
      'Yaris', 'Mirai', 'bZ4X' // New addition
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
      'Nexo', 'Azera', 'Genesis', 'Equus', 'Santa Cruz',
      'Creta EV' // New addition
    ],
    'Suzuki': [
      'Swift', 'Baleno', 'Vitara', 'Ciaz', 'Alto',
      'Wagon R', 'Ertiga', 'XL6', 'Ignis', 'S-Cross',
      'Dzire', 'Jimny', 'Celerio', 'Grand Vitara', 'Kizashi',
      'APV', 'A-Star', 'Ritz', 'SX4', 'Brezza',
      'Estilo', 'Omni', 'Eeco', 'S-Presso', 'Liana',
      'Escudo', 'Forenza', 'Aerio', 'Equator', 'Splash'
    ],
    'other': ['other']
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
      if (_imageFiles.isEmpty) {
        // Show error if no images are uploaded
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please upload at least one photo before proceeding.'),
            backgroundColor: Colors.black,
          ),
        );
        return;
      }

      try {
        setState(() {
          isSubmitting = true;
        });

        // Upload images and collect their URLs
        List<String> imageUrls = [];
        for (int i = 0; i < _imageFiles.length; i++) {
          final String imageUrl = await uploadImage(_imageFiles[i]);
          imageUrls.add(imageUrl);
        }

        // Firestore reference for a new document
        final DocumentReference documentRef = _firestore
            .collection('category')
            .doc('Vehicle')
            .collection('ads')
            .doc(); // Generate a new document reference

        // Get the document ID
        final String documentId = documentRef.id;

        // Set data in Firestore
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
          'images': imageUrls, // Save uploaded image URLs
          'timestamp': Timestamp.now(),
        });

        setState(() {
          isSubmitting = false;
        });

        // Navigate to ContactUser screen after successful submission
        BuildContext? currentContext = context;
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
            // Optional: Handle navigation completion
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'List Your Car',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDropdown(
                title: 'Brand *',
                value: brand,
                items: brandModelMap.keys.toList(),
                onChanged: handleBrandChange,
              ),
              if (brand.isNotEmpty)
                buildDropdown(
                  title: 'Model *',
                  value: model,
                  items: modelOptions,
                  onChanged: handleModelChange,
                ),
              buildTextField(
                title: 'Year of Purchase *',
                hintText: 'Enter Year',
                onChanged: handleYearOfPurchaseChange,
                keyboardType: TextInputType.number,
              ),
              buildTextField(
                title: 'Kilometers Driven *',
                hintText: 'Enter Kilometers',
                onChanged: handleKilometersDrivenChange,
                keyboardType: TextInputType.number,
              ),
              buildDropdown(
                title: 'Transmission Type *',
                value: transmissionType,
                items: ['Automatic', 'Manual'],
                onChanged: handleTransmissionTypeChange,
              ),
              buildDropdown(
                title: 'Fuel Type *',
                value: fuelType,
                items: ['Petrol', 'Diesel', 'CNG', 'Electric', 'Other'],
                onChanged: handleFuelTypeChange,
              ),
              buildDropdown(
                title: 'Number of Owners *',
                value: numberOfOwners,
                items: ['1', '2', '3', '4+'],
                onChanged: handleNumberOfOwnersChange,
              ),
              buildTextField(
                title: localization.title,
                hintText: localization.pleaseEnterAdTitle,
                onChanged: handleAdNameChange,
              ),
              buildTextField(
                title: localization.description,
                hintText: localization.pleaseEnterDescription,
                onChanged: handleDescriptionChange,
                maxLines: 4,
              ),
              buildTagInput(localization.tag, localization),
              buildDropdown(
                title: localization.negotiable,
                value: negotiable,
                items: [localization.yes, localization.no],
                onChanged: handleNegotiableChange,
              ),
              buildTextField(
                title: localization.price,
                hintText: localization.pleaseEnterPrice,
                onChanged: handlePriceChange,
                keyboardType: TextInputType.number,
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
              ),
              const SizedBox(height: 16.0),
              Text(localization.addPhotos),
              const SizedBox(height: 8.0),
              ImageUploader(
                onImagesChanged: (imageFiles) {
                  setState(() {
                    _imageFiles = imageFiles;

                    // Validation: Ensure the user cannot proceed without uploading a photo
                    if (_imageFiles.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please upload at least one photo to proceed.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBarUpload(
        onNextPressed: handleSubmit,
        isLastStep: true,
      ),
    );
  }

// Helper Widgets
  Widget buildDropdown({
    required String title,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          DropdownButtonFormField<String>(
            value: value.isNotEmpty ? value : null,
            items: items
                .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                .toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextField({
    required String title,
    required String hintText,
    required ValueChanged<String> onChanged,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          TextFormField(
            maxLines: maxLines,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTagInput(String title, AppLocalizations localization) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: tags.map((tag) {
              return Chip(
                label: Text(tag),
                deleteIcon: const Icon(Icons.close, size: 16),
                onDeleted: () => handleRemoveTag(tag),
              );
            }).toList(),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: localization.pleaseEnterDescription,
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  onChanged: (value) => setState(() => newTag = value),
                ),
              ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: handleAddTag,
                child: const Text('Add'),
              ),
            ],
          ),
        ],
      ),
    );
  }

}

