import 'package:flutter/material.dart';

class ImageViewDialog extends StatelessWidget {
  final String imageUrl;

  const ImageViewDialog({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: InteractiveViewer(
        panEnabled: true, // Enable panning
        minScale: 0.5, // Minimum scale
        maxScale: 4.0, // Maximum scale
        child: Image.network(imageUrl),
      ),
    );
  }
}
