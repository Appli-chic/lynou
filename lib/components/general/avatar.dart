import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lynou/providers/theme_provider.dart';
import 'package:lynou/services/auth_service.dart';
import 'package:lynou/services/user_service.dart';
import 'package:provider/provider.dart';

class LYAvatar extends StatefulWidget {
  final double size;

  LYAvatar({
    this.size,
  });

  @override
  _LYAvatarState createState() => _LYAvatarState();
}

class _LYAvatarState extends State<LYAvatar> {
  AuthService _authService;
  UserService _userService;

  bool _didFirstLoad = false;
  bool _isLoaded = false;
  String _accessToken;
  String _photoUrl;

  /// Displays the placeholder until we loaded the image
  Widget _displaysPlaceholder(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Container(
      width: widget.size != null ? widget.size : 60,
      height: widget.size != null ? widget.size : 60,
      color: themeProvider.secondBackgroundColor,
    );
  }

  _loadsTheImage() async {
    if (!_didFirstLoad) {
      setState(() {
        _didFirstLoad = true;
      });

      var accessToken = await _authService.getAccessToken();
      var photoUrl = await _userService.getProfilePhotoUrl();

      setState(() {
        _isLoaded = true;
        _accessToken = accessToken;
        _photoUrl = photoUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _authService = Provider.of<AuthService>(context);
    _userService = Provider.of<UserService>(context);
    _loadsTheImage();

    if (_isLoaded) {
      // Displays the image
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          width: widget.size != null ? widget.size : 60,
          height: widget.size != null ? widget.size : 60,
          fit: BoxFit.cover,
          imageUrl: _photoUrl,
          httpHeaders: {
            HttpHeaders.authorizationHeader: "Bearer $_accessToken"
          },
          placeholder: (context, url) => _displaysPlaceholder(context),
        ),
      );
    } else {
      // Displays a placeholder until the image loads
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: _displaysPlaceholder(context),
      );
    }
  }
}
