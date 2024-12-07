import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploader extends StatefulWidget {
  final Function(List<File>) onImagesChanged;

  const ImageUploader({super.key, required this.onImagesChanged});

  @override
  _ImageUploaderState createState() => _ImageUploaderState();
}

class _ImageUploaderState extends State<ImageUploader> {
  List<File> _imageFiles = [];

  Future<void> handleImageSelection() async {
    final pickedFiles = await ImagePicker().pickMultiImage(imageQuality: 80);
    setState(() {
      _imageFiles = pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
      widget.onImagesChanged(_imageFiles);
    });
  }

  Future<void> handleCameraClick() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFiles.add(File(pickedFile.path));
        widget.onImagesChanged(_imageFiles);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: handleImageSelection,
                icon: const Icon(Icons.image),
                label: const Text('Upload'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.green[50],
                  side: BorderSide(color: Colors.green),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: handleCameraClick,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Take Photo'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.green[50],
                  side: BorderSide(color: Colors.green),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        Container(
          height: _imageFiles.isEmpty ? 0 : 200,
          child: _imageFiles.isEmpty
              ? const SizedBox.shrink()
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _imageFiles.length,
                  itemBuilder: (context, index) {
                    final File imageFile = _imageFiles[index];
                    return Stack(
                      children: [
                        Container(
                          width: 150,
                          margin: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            image: DecorationImage(
                              image: FileImage(imageFile),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8.0,
                          right: 8.0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _imageFiles.removeAt(index);
                                widget.onImagesChanged(_imageFiles);
                              });
                            },
                            child: const CircleAvatar(
                              backgroundColor: Colors.red,
                              radius: 12.0,
                              child: Icon(
                                Icons.close,
                                size: 16.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
        ),
      ],
    );
  }
}
