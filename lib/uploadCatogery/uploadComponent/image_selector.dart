import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageSelector extends StatefulWidget {
  @override
  _ImageSelectorState createState() => _ImageSelectorState();
}

class _ImageSelectorState extends State<ImageSelector> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];

  void _takePhoto() async {
    await _checkAndRequestPermissions(); // Check and request permissions
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _images.add(pickedFile);
      });
    }
  }

  void _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _images.addAll(pickedFiles);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  void _showOptionsDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title:const  Text('Options'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              GestureDetector(
                child: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
             const Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child:const  Text('Select Images'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImages(); // Call _pickImages method
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _passImagesBack() {
    Navigator.pop(context, _images);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Images"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 8),
          _images.isEmpty
              ? Container(
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.upload),
                  SizedBox(width: 8),
                  Text('No images selected'),
                ],
              ),
            ),
          )
              : SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    GestureDetector(
                      onTap: () => _showOptionsDialog(context, index),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(
                          File(_images[index].path),
                          width: 150,
                          height: 250,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _removeImage(index),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.close, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _showOptionsDialog(context, -1),
            child: Text('Add Images'),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _passImagesBack,
            child: Text('Select Images'),
          ),
        ],
      ),
    );
  }

  Future<void> _checkAndRequestPermissions() async {
    // Check camera permission
    var cameraStatus = await Permission.camera.status;
    if (!cameraStatus.isGranted) {
      // Request camera permission
      await Permission.camera.request();
    }

    // Check storage permission
    var storageStatus = await Permission.storage.status;
    if (!storageStatus.isGranted) {
      // Request storage permission
      await Permission.storage.request();
    }
  }
}
