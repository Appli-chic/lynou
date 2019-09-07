import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lynou/providers/theme_provider.dart';
import 'package:lynou/services/auth_service.dart';
import 'package:provider/provider.dart';

class LYAvatar extends StatelessWidget {
  final double size;

  LYAvatar({
    this.size,
  });

  Widget _displaysPlaceholder(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Container(
      width: size != null ? size : 60,
      height: size != null ? size : 60,
      color: themeProvider.secondBackgroundColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    var authService = Provider.of<AuthService>(context);

    return FutureBuilder<String>(
      future: authService.getAccessToken(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              width: size != null ? size : 60,
              height: size != null ? size : 60,
              fit: BoxFit.cover,
              imageUrl: 'http://172.20.10.6:8080/api/file/Butterfree.png',
              httpHeaders: {
                HttpHeaders.authorizationHeader: "Bearer ${snapshot.data}"
              },
              placeholder: (context, url) => _displaysPlaceholder(context),
            ),
          );
        } else if (snapshot.hasError) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _displaysPlaceholder(context),
          );
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: _displaysPlaceholder(context),
        );
      },
    );
  }
}
