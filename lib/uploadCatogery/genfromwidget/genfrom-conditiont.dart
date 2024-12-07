import 'dart:io';
import 'package:flutter/material.dart';
import '../../../models/add_tag_button.dart';
import '../../../models/custom_text_field.dart';
import '../../../models/image_upload.dart';

class GenFormCondition extends StatefulWidget {
  final Function(List<File>) onImagesChanged;
  final Function(String) onNegotiableChange;
  final Function(String) onTagAdd;
  final Function(String) onTagRemove;
  final Function(String) onDescriptionChange;
  final Function(String) onTitleChange;
  final String negotiable;
  final List<String> tags;
  final String description;
  final String title;
  final List<File> imageFiles;

  GenFormCondition({
    required this.onImagesChanged,
    required this.onNegotiableChange,
    required this.onTagAdd,
    required this.onTagRemove,
    required this.onDescriptionChange,
    required this.onTitleChange,
    required this.negotiable,
    required this.tags,
    required this.description,
    required this.title,
    required this.imageFiles,
  });

  @override
  _GenFormConditionState createState() => _GenFormConditionState();
}

class _GenFormConditionState extends State<GenFormCondition> {
  String newTag = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Title *"),
        CustomTextFormField(
          hintText: 'Enter Ad title',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter Ad title';
            }
            return null;
          },
          onChanged: widget.onTitleChange,
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
          onChanged: widget.onDescriptionChange,
        ),
        const SizedBox(height: 16.0),
        const Text('Tag *'),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: widget.tags.map((tag) {
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
                    onTap: () => widget.onTagRemove(tag),
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
                hintText: 'Enter a new tag',
                onChanged: (value) {
                  setState(() {
                    newTag = value;
                  });
                },
              ),
            ),
            const SizedBox(width: 8.0),
            AddTagButton(
              onTap: () {
                if (newTag.trim().isNotEmpty) {
                  widget.onTagAdd(newTag.trim());
                  setState(() {
                    newTag = '';
                  });
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 16.0),
        const Text('Negotiable *'),
        DropdownButtonFormField<String>(
          value: widget.negotiable,
          onChanged: (value) {
            widget.onNegotiableChange(value ?? '');
          },
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
        const Text('Add Photos'),
        const SizedBox(height: 8.0),
        ImageUploader(
          onImagesChanged: widget.onImagesChanged,
        ),
      ],
    );
  }
}
