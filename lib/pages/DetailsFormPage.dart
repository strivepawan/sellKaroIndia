import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:sell_karo_india/homepage/home_page.dart';

import '../chatApp/api/apis.dart';

class UserForm extends StatefulWidget {
  final String uid;

  const UserForm({super.key, required this.uid});
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final fileName = basename(image.path);
      final storageRef =
          FirebaseStorage.instance.ref().child('user_images/$fileName');
      await storageRef.putFile(image);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print('Image upload failed: $e');
      return null;
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _image != null) {
      final imageUrl = await _uploadImage(_image!);

      if (imageUrl != null) {
        try {
          // Updating the current user information in Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(APIs.user.uid)
              .set({
            'name': _nameController.text,
            'phone': _phoneController.text,
            'email': APIs.user.email ?? '', // Ensure the email is added
            'image': imageUrl,
            'uid': APIs.user.uid, // Use the user.uid to associate this record
            'createdAt': FieldValue.serverTimestamp(), // Optional for tracking
          });

          if (mounted) {
            ScaffoldMessenger.of(this.context).showSnackBar(
              const SnackBar(content: Text('User data uploaded successfully!')),
            );
          }

          // Clear form fields and reset image
          _nameController.clear();
          _phoneController.clear();
          setState(() {
            _image = null;
          });

          // Navigate to HomeScreen
          Navigator.pushReplacement(
            this.context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(this.context).showSnackBar(
              SnackBar(content: Text('Error uploading data: $e')),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(this.context).showSnackBar(
            const SnackBar(content: Text('Image upload failed. Please try again.')),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(this.context).showSnackBar(
          const SnackBar(
            content: Text('Please fill all fields and select an image.'),
          ),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Form',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          _image != null ? FileImage(_image!) : null,
                      backgroundColor: Colors.green.shade100,
                      child: _image == null
                          ? Icon(Icons.camera_alt,
                              size: 50, color: Colors.green)
                          : null,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.green),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
