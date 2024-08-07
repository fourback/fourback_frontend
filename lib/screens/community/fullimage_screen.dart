import 'package:bemajor_frontend/publicImage.dart';
import 'package:flutter/material.dart';

class FullImageScreen extends StatelessWidget {
  final String imageUrl;

  FullImageScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: InteractiveViewer(
        panEnabled: true, // 화면 드래그 가능
        minScale: 0.5, // 최소 확대/축소 비율
        maxScale: 4.0, // 최대 확대/축소 비율
        child: Center(
          child: PublicImage(
            placeholderPath: 'assets/icons/loading.gif',
            imageUrl: imageUrl,
            fit: BoxFit.contain,

          ),
        ),
      ),
    );
  }
}