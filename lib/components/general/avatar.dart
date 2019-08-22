import 'package:cache_image/cache_image.dart';
import 'package:flutter/material.dart';

class LYAvatar extends StatelessWidget {
  final double size;

  LYAvatar({
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CacheImage.firebase(
        width: size != null ? size : 60,
        height: size != null ? size : 60,
        fit: BoxFit.cover,
        path: 'avatars/puppy.png',
      ),
    );
  }
}
