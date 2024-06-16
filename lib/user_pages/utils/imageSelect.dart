import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static Future<Uint8List?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      return pickedFile.readAsBytes();
    } else {
      return null;
    }
  }
}

// Example usage:
// Uint8List? imageData = await ImagePickerHelper.pickImageFromGallery();