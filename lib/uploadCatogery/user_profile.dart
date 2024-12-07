import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewProfile extends StatefulWidget {
  const ReviewProfile({Key? key, required mobileDetails, required userInfo}) : super(key: key);

  @override
  _ReviewProfileState createState() => _ReviewProfileState();
}

class _ReviewProfileState extends State<ReviewProfile> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _name = '';
  String _email = '';
  String _phoneNumber = '';
  String _whatsAppNumber = '';
  String _address = '';

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Load user profile information when the widget initializes
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    // Retrieve user profile information from Firestore
    // Replace 'userId' with the actual user ID after implementing authentication
    DocumentSnapshot<Map<String, dynamic>> userSnapshot =
        await _firestore.collection('users').doc('userId').get();

    if (userSnapshot.exists) {
      setState(() {
        _name = userSnapshot['name'] ?? '';
        _email = userSnapshot['email'] ?? '';
        _phoneNumber = userSnapshot['phoneNumber'] ?? '';
        _whatsAppNumber = userSnapshot['whatsAppNumber'] ?? '';
        _address = userSnapshot['address'] ?? '';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Profile'),
      ),
      body: _isLoading
          ?const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 const  Text(
                    'Name:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(_name),
                  const SizedBox(height: 16),
                  const Text(
                    'Email:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(_email),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _phoneNumber,
                    onChanged: (value) => _phoneNumber = value,
                    decoration:const  InputDecoration(labelText: 'Phone Number'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _whatsAppNumber,
                    onChanged: (value) => _whatsAppNumber = value,
                    decoration:const  InputDecoration(labelText: 'WhatsApp Number'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _address,
                    onChanged: (value) => _address = value,
                    decoration:const  InputDecoration(labelText: 'Address'),
                  ),
                 const  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    child:const  Text('Update Profile'),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _updateProfile() async {
    // Update user profile information in Firestore
    // Replace 'userId' with the actual user ID after implementing authentication
    await _firestore.collection('users').doc('userId').set({
      'name': _name,
      'email': _email,
      'phoneNumber': _phoneNumber,
      'whatsAppNumber': _whatsAppNumber,
      'address': _address,
    });

    // Show a success message or navigate to the next screen
  }
}

class MobileDetails {
  final String brand;
  final String model;
  final String adName;
  final List<String> tags;
  final String description;
  final String price;
  final String negotiable;
  final List<String> images;
  final Timestamp timestamp;

  MobileDetails({
    required this.brand,
    required this.model,
    required this.adName,
    required this.tags,
    required this.description,
    required this.price,
    required this.negotiable,
    required this.images,
    required this.timestamp,
  });
}

