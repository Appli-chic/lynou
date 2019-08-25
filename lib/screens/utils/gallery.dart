import 'package:flutter/material.dart';
import 'package:lynou/providers/theme_provider.dart';
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';

class Gallery {
  static Future<List<AssetEntity>> pickAssets(BuildContext context,
      ThemeProvider _themeProvider) async {
    return await PhotoPicker.pickAsset(
      context: context,
      maxSelected: 8,
      provider: ENProvider(),
      themeColor: _themeProvider.backgroundColor,
      disableColor: Colors.grey[600],
      pickType: PickType.all,
      thumbSize: 150,
      rowCount: 5,
    );
  }
}