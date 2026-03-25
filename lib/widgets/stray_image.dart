import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';

/// A widget that can display an image from various sources:
/// - Base64 string (from JSON)
/// - Local file path (from device storage)
/// - Asset path (predefined images in the app)
class StrayImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;

  const StrayImage({
    super.key, 
    required this.imagePath, 
    this.width, 
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // shows a placeholder if no image is provided
    if (imagePath.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey.shade300,
        child: const Center(
          child: Icon(Icons.pets, size: 30, color: Colors.black54),
        ),
      );
    }

    // If Base64 encoded text from JSON, decode and display as image
    if (imagePath.startsWith('base64,')) {
      // Cut off the "base64," prefix before decoding
      final cleanBase64 = imagePath.substring(7); 
      return Image.memory(
        base64Decode(cleanBase64), 
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    } 
    
    // if hardcoded asset path, load from assets
    else if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    } 
    
    // otherwise, load the pre-existing local files
    else {
      return Image.file(
        File(imagePath),
        width: width,
        height: height,
        fit: BoxFit.cover,
      );
    }
  }
}