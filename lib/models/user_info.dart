import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'city_selction.dart';

class ContactUser extends StatefulWidget {
  final String selectedCategory;
  final String docId;
  final String collectionId;
  final String addDocId;

  const ContactUser({
    super.key,
    required this.selectedCategory,
    required this.docId,
    required this.collectionId,
    required this.addDocId,
  });

  @override
  _ContactUserState createState() => _ContactUserState();
}

class _ContactUserState extends State<ContactUser> {
  final TextEditingController _whatsappNumberController = TextEditingController();
  final TextEditingController _userAddressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _error = '';
  bool _isLoading = false;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  Future<void> _fetchCurrentUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      _currentUser = FirebaseAuth.instance.currentUser;
      if (_currentUser != null) {
        final userDocRef = FirebaseFirestore.instance
            .collection('users')
            .doc(_currentUser!.uid);

        final userDocSnapshot = await userDocRef.get();
        if (userDocSnapshot.exists) {
          final data = userDocSnapshot.data()!;
          _whatsappNumberController.text = data['whatsappNumber'] ?? '';
          _cityController.text = data['city'] ?? '';
          _userAddressController.text = data['userAddress'] ?? '';
        }
      }
    } catch (error) {
      print('Error fetching current user: $error');
      setState(() {
        _error = 'Error fetching user data. Please try again.';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _whatsappNumberController.dispose();
    _userAddressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: const Text('Your ad has been posted successfully.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleUpdate() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final userDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid);

      try {
        // Update user's personal collection
        await userDocRef.set({
          'whatsappNumber': _whatsappNumberController.text,
          'city': _cityController.text,
          'userAddress': _userAddressController.text,
        }, SetOptions(merge: true));

        // Update the specified document in the given path
        final docRef = FirebaseFirestore.instance
            .collection(widget.selectedCategory)
            .doc(widget.addDocId)
            .collection(widget.collectionId)
            .doc(widget.docId);

        await docRef.update({
          'whatsappNumber': _whatsappNumberController.text,
          'city': _cityController.text,
          'userAddress': _userAddressController.text,
          'userId': _currentUser?.uid, // Store current user ID
        });

        _showSuccessDialog();

        setState(() {
          _isLoading = false;
          _error = ''; // Clear error on success
        });
      } on FirebaseException catch (error) {
        setState(() {
          _isLoading = false;
          _error = 'Error updating document: ${error.message}';
        });
        print('Firebase error: $error');
      } catch (error) {
        setState(() {
          _isLoading = false;
          _error = 'Error updating document. Please try again.';
        });
        print('Unknown error: $error');
      }
    }
  }

  void _selectCity() async {
    
    final selectedCity = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CitySelectionScreen(),
      ),
    );

    if (selectedCity != null) {
      setState(() {
        _cityController.text = selectedCity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Contact Info'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text("WhatsApp Number"),
                TextFormField(
                  controller: _whatsappNumberController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Number';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'WhatsApp Number',
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
                ),
                const SizedBox(height: 16),
                const Text("City"),
                TextFormField(
                  controller: _cityController,
                  readOnly: true,
                  onTap: () async {
                    final selectedCity = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CitySelectionScreen(),
                      ),
                    );
                    if (selectedCity != null) {
                      setState(() {
                        _cityController.text = selectedCity;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a city';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Select City',
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
                ),
                if (_error.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _error,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 16),
                const Text("Enter detail address"),
                TextFormField(
                  controller: _userAddressController,
                  keyboardType: TextInputType.streetAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Address',
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
                ),
                if (_error.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      _error,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[200], // Set bottom navigation bar background color to green
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEBEEF7),
              borderRadius: BorderRadius.circular(8)
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: _isLoading ? null : _handleUpdate,
                child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                    'Post ads',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
