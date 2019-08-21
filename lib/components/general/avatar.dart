import 'package:cache_image/cache_image.dart';
import 'package:flutter/material.dart';

class LYAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CacheImage.firebase(
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        path: 'avatars/puppy.png',
      ),
    );
  }
}
