import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lynou/components/general/cached_image.dart';
import 'package:lynou/models/database/file.dart';
import 'package:lynou/providers/theme_provider.dart';
import 'package:lynou/screens/utils/viewer/src/photo_view_controller.dart';
import 'package:lynou/screens/utils/viewer/src/photo_view_controller_delegate.dart';
import 'package:lynou/services/storage_service.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

typedef PhotoViewImageTapUpCallback = Function(BuildContext context,
    TapUpDetails details, PhotoViewControllerValue controllerValue);
typedef PhotoViewImageTapDownCallback = Function(BuildContext context,
    TapDownDetails details, PhotoViewControllerValue controllerValue);

/// Internal widget in which controls all animations lifecycles, core responses
/// to user gestures, updates to  the controller state and mounts the entire PhotoView Layout
class PhotoViewImageWrapper extends StatefulWidget {
  const PhotoViewImageWrapper({
    Key key,
    this.lynouFile,
    this.videoPath,
    this.imageProvider,
    this.backgroundDecoration,
    this.gaplessPlayback = false,
    this.heroTag,
    this.enableRotation,
    this.transitionOnUserGestures = false,
    this.onTapUp,
    this.onTapDown,
    @required this.delegate,
  })  : customChild = null,
        super(key: key);

  const PhotoViewImageWrapper.customChild({
    Key key,
    @required this.customChild,
    this.backgroundDecoration,
    this.heroTag,
    this.enableRotation,
    this.transitionOnUserGestures = false,
    this.onTapUp,
    this.onTapDown,
    this.lynouFile,
    this.videoPath,
    @required this.delegate,
  })  : imageProvider = null,
        gaplessPlayback = false,
        super(key: key);

  final LYFile lynouFile;
  final String videoPath;
  final Decoration backgroundDecoration;
  final ImageProvider imageProvider;
  final bool gaplessPlayback;
  final Object heroTag;
  final bool enableRotation;
  final Widget customChild;
  final bool transitionOnUserGestures;

  final PhotoViewControllerDelegate delegate;

  final PhotoViewImageTapUpCallback onTapUp;
  final PhotoViewImageTapDownCallback onTapDown;

  @override
  State<StatefulWidget> createState() {
    return _PhotoViewImageWrapperState();
  }
}

class _PhotoViewImageWrapperState extends State<PhotoViewImageWrapper>
    with TickerProviderStateMixin {
  VideoPlayerController _videoPlayerController;
  bool _isOverlayVisible = false;
  bool _isVideoLoading = true;
  bool _didVideoLoaded = false;

  ThemeProvider _themeProvider;
  StorageService _storageService;

  Offset _normalizedPosition;
  double _scaleBefore;
  double _rotationBefore;

  AnimationController _scaleAnimationController;
  Animation<double> _scaleAnimation;

  AnimationController _positionAnimationController;
  Animation<Offset> _positionAnimation;

  AnimationController _rotationAnimationController;
  Animation<double> _rotationAnimation;

  void handleScaleAnimation() {
    widget.delegate.scale = _scaleAnimation.value;
  }

  void handlePositionAnimate() {
    widget.delegate.controller.position = _positionAnimation.value;
  }

  void handleRotationAnimation() {
    widget.delegate.controller.rotation = _rotationAnimation.value;
  }

  void onScaleStart(ScaleStartDetails details) {
    _rotationBefore = widget.delegate.controller.rotation;
    _scaleBefore = widget.delegate.scale;
    _normalizedPosition =
        details.focalPoint - widget.delegate.controller.position;
    _scaleAnimationController.stop();
    _positionAnimationController.stop();
    _rotationAnimationController.stop();
  }

  void onScaleUpdate(ScaleUpdateDetails details) {
    final double newScale = _scaleBefore * details.scale;
    final Offset delta = details.focalPoint - _normalizedPosition;

    widget.delegate.updateScaleStateFromNewScale(details.scale, newScale);

    widget.delegate.updateMultiple(
        scale: newScale,
        position: widget.delegate.clampPosition(delta * details.scale),
        rotation: _rotationBefore + details.rotation,
        rotationFocusPoint: details.focalPoint);
  }

  void onScaleEnd(ScaleEndDetails details) {
    final double _scale = widget.delegate.scale;
    final Offset _position = widget.delegate.controller.position;
    final double maxScale = widget.delegate.scaleBoundaries.maxScale;
    final double minScale = widget.delegate.scaleBoundaries.minScale;

    //animate back to maxScale if gesture exceeded the maxScale specified
    if (_scale > maxScale) {
      final double scaleComebackRatio = maxScale / _scale;
      animateScale(_scale, maxScale);
      final Offset clampedPosition = widget.delegate
          .clampPosition(_position * scaleComebackRatio, scale: maxScale);
      animatePosition(_position, clampedPosition);
      return;
    }

    //animate back to minScale if gesture fell smaller than the minScale specified
    if (_scale < minScale) {
      final double scaleComebackRatio = minScale / _scale;
      animateScale(_scale, minScale);
      animatePosition(
          _position,
          widget.delegate
              .clampPosition(_position * scaleComebackRatio, scale: minScale));
      return;
    }
    // get magnitude from gesture velocity
    final double magnitude = details.velocity.pixelsPerSecond.distance;

    // animate velocity only if there is no scale change and a significant magnitude
    if (_scaleBefore / _scale == 1.0 && magnitude >= 400.0) {
      final Offset direction = details.velocity.pixelsPerSecond / magnitude;
      animatePosition(_position,
          widget.delegate.clampPosition(_position + direction * 100.0));
    }

    widget.delegate.checkAndSetToInitialScaleState();
  }

  void animateScale(double from, double to) {
    _scaleAnimation = Tween<double>(
      begin: from,
      end: to,
    ).animate(_scaleAnimationController);
    _scaleAnimationController
      ..value = 0.0
      ..fling(velocity: 0.4);
  }

  void animatePosition(Offset from, Offset to) {
    _positionAnimation = Tween<Offset>(begin: from, end: to)
        .animate(_positionAnimationController);
    _positionAnimationController
      ..value = 0.0
      ..fling(velocity: 0.4);
  }

  void animateRotation(double from, double to) {
    _rotationAnimation = Tween<double>(begin: from, end: to)
        .animate(_rotationAnimationController);
    _rotationAnimationController
      ..value = 0.0
      ..fling(velocity: 0.4);
  }

  void onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.delegate.checkAndSetToInitialScaleState();
    }
  }

  _listener() {
    if (_videoPlayerController.value.position ==
        _videoPlayerController.value.duration) {
//      _videoPlayerController.seekTo(Duration(milliseconds: 0));
//      _videoPlayerController.pause();

      setState(() {
        _isOverlayVisible = true;
      });
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _scaleAnimationController = AnimationController(vsync: this)
      ..addListener(handleScaleAnimation);
    _scaleAnimationController.addStatusListener(onAnimationStatus);

    _positionAnimationController = AnimationController(vsync: this)
      ..addListener(handlePositionAnimate);

    _rotationAnimationController = AnimationController(vsync: this)
      ..addListener(handleRotationAnimation);
    widget.delegate.startListeners();
    widget.delegate.addAnimateOnScaleStateUpdate(animateOnScaleStateUpdate);

    // Init video player controller
    if (widget.videoPath != null) {
      _isOverlayVisible = true;
      _videoPlayerController = VideoPlayerController.file(File(widget.videoPath))
        ..initialize().then((_) {
          // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
          setState(() {
            _isVideoLoading = false;
            _didVideoLoaded = true;
          });
        });

      _videoPlayerController.addListener(_listener);
    }
  }

  Future<void> _loadLynouVideo() async {
    if (widget.lynouFile != null && (_isVideoLoading && !_didVideoLoaded)) {
      if (widget.lynouFile.type == TYPE_VIDEO) {
        _isOverlayVisible = true;
        var file = await _storageService.downloadVideo(widget.lynouFile.name);
        _videoPlayerController = VideoPlayerController.file(file)
          ..initialize().then((_) {
            // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
            setState(() {
            _isVideoLoading = false;
            _didVideoLoaded = true;
            });
          });

        _videoPlayerController.addListener(_listener);
      }
    }
  }

  void animateOnScaleStateUpdate(double prevScale, double nextScale) {
    animateScale(prevScale, nextScale);
    animatePosition(widget.delegate.controller.position, Offset.zero);
    animateRotation(widget.delegate.controller.rotation, 0.0);
  }

  @override
  void dispose() {
    _scaleAnimationController.removeStatusListener(onAnimationStatus);
    _scaleAnimationController.dispose();
    _positionAnimationController.dispose();
    _rotationAnimationController.dispose();
    widget.delegate.dispose();

    if (widget.videoPath != null) {
      _videoPlayerController.dispose();
    }

    super.dispose();
  }

  void onTapUp(TapUpDetails details) {
    widget.onTapUp(context, details, widget.delegate.controller.value);
  }

  void onTapDown(TapDownDetails details) {
    widget.onTapDown(context, details, widget.delegate.controller.value);
  }

  /// Displays overlay for images and photos
  Widget _displaysOverlay() {
    if (_isOverlayVisible) {
      if ((widget.videoPath != null ||
          (widget.lynouFile != null &&
              widget.lynouFile.type == TYPE_VIDEO))) {
        Widget videoOverlay = Material(
          color: Colors.black26,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                _isVideoLoading
                    ? Container()
                    : Center(
                        child: IconButton(
                          onPressed: () {
                            if (_videoPlayerController.value.position ==
                                _videoPlayerController.value.duration) {
                              _videoPlayerController.seekTo(Duration(milliseconds: 0));
                            }

                            if (!_videoPlayerController.value.isPlaying) {
                              _videoPlayerController.play();
                            } else {
                              _videoPlayerController.pause();
                            }

                            setState(() {});
                          },
                          icon: Icon(
                            _videoPlayerController.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            color: Colors.white,
                          ),
                          iconSize: 50,
                        ),
                      ),
                _isVideoLoading
                    ? Container()
                    : Container(
                        margin: EdgeInsets.only(left: 12, right: 12, bottom: 16),
                        child: Slider(
                          onChanged: (double value) {
                            _videoPlayerController
                                .seekTo(Duration(milliseconds: value.toInt()));

                            setState(() {});
                          },
                          value: _videoPlayerController
                              .value.position.inMilliseconds
                              .toDouble(),
                          min: 0,
                          max: _videoPlayerController.value.duration != null
                              ? _videoPlayerController
                                  .value.duration.inMilliseconds
                                  .toDouble()
                              : 0,
                          activeColor: _themeProvider.firstColor,
                        ),
                      ),
              ],
            ),
          ),
        );

        return videoOverlay;
      } else {
        Widget photoOverlay = Material(
          color: Colors.black26,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        );

        return photoOverlay;
      }
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    _themeProvider = Provider.of<ThemeProvider>(context, listen: true);
    _storageService = Provider.of<StorageService>(context, listen: true);
    _loadLynouVideo();

    return GestureDetector(
      onTap: () {
        this.setState(() {
          _isOverlayVisible = !_isOverlayVisible;
        });
      },
      child: Stack(
        children: <Widget>[
          StreamBuilder(
              stream: widget.delegate.controller.outputStateStream,
              initialData: widget.delegate.controller.prevValue,
              builder: (BuildContext context,
                  AsyncSnapshot<PhotoViewControllerValue> snapshot) {
                if (widget.lynouFile.name != null) {
                  if (widget.lynouFile.type == TYPE_VIDEO) {
                    return _buildHero();
                  } else {
                    return _buildImage(snapshot);
                  }
                } else if (widget.videoPath != null) {
                  return _buildHero();
                } else if (snapshot.hasData) {
                  return _buildImage(snapshot);
                } else {
                  return Container();
                }
              }),
          _displaysOverlay(),
        ],
      ),
    );
  }

  Widget _buildImage(AsyncSnapshot<PhotoViewControllerValue> snapshot) {
    // Displays photos
    final PhotoViewControllerValue value = snapshot.data;
    final matrix = Matrix4.identity()
      ..translate(value.position.dx, value.position.dy)
      ..scale(widget.delegate.scale);

    final rotationMatrix = Matrix4.identity()..rotateZ(value.rotation);
    final Widget customChildLayout = CustomSingleChildLayout(
      delegate: _CenterWithOriginalSizeDelegate(
          widget.delegate.scaleBoundaries.childSize,
          widget.delegate.basePosition),
      child: _buildHero(),
    );
    return GestureDetector(
      child: Container(
        child: Center(
            child: Transform(
          child: widget.enableRotation
              ? Transform(
                  child: customChildLayout,
                  transform: rotationMatrix,
                  alignment: Alignment.center,
                  origin: value.rotationFocusPoint,
                )
              : customChildLayout,
          transform: matrix,
          alignment: widget.delegate.basePosition,
        )),
        decoration: widget.backgroundDecoration ??
            const BoxDecoration(color: const Color.fromRGBO(0, 0, 0, 1.0)),
      ),
      onDoubleTap: widget.delegate.nextScaleState,
      onScaleStart: onScaleStart,
      onScaleUpdate: onScaleUpdate,
      onScaleEnd: onScaleEnd,
      onTapUp: widget.onTapUp == null ? null : onTapUp,
      onTapDown: widget.onTapDown == null ? null : onTapDown,
    );
  }

  Widget _buildHero() {
    return widget.heroTag != null
        ? Hero(
            tag: widget.heroTag,
            child: _buildChild(),
            transitionOnUserGestures: widget.transitionOnUserGestures,
          )
        : _buildChild();
  }

  Widget _buildVideoPlayer() {
    if (!_isVideoLoading) {
      return Container(
        color: Colors.black,
        child: Center(
          child: AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: VideoPlayer(_videoPlayerController),
          ),
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
                _themeProvider.firstColor),
          ),
        ),
      );
    }
  }

  Widget _buildChild() {
    if (widget.videoPath != null) {
      // Displays video
      return _buildVideoPlayer();
    } else {
      // Displays images
      if (widget.lynouFile.name == null) {
        // Displays local images
        return widget.customChild == null
            ? Image(
                image: widget.imageProvider,
                gaplessPlayback: widget.gaplessPlayback,
              )
            : widget.customChild;
      } else {
        // Displays firebase images
        if (widget.lynouFile.type == TYPE_VIDEO) {
          // Displays videos
          return _buildVideoPlayer();
        } else {
          // Displays photos
          return Center(
            child: CachedImage(
              boxFit: BoxFit.fitWidth,
              url: _storageService.getFileDownloadUrl(widget.lynouFile.name),
            ),
          );
        }
      }
    }
  }
}

class _CenterWithOriginalSizeDelegate extends SingleChildLayoutDelegate {
  const _CenterWithOriginalSizeDelegate(this.subjectSize, this.basePosition);

  final Size subjectSize;
  final Alignment basePosition;

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final double offsetX =
        ((size.width - subjectSize.width) / 2) * (basePosition.x + 1);
    final double offsetY =
        ((size.height - subjectSize.height) / 2) * (basePosition.y + 1);
    return Offset(offsetX, offsetY);
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    return BoxConstraints(
      maxWidth: subjectSize.width,
      maxHeight: subjectSize.height,
      minHeight: subjectSize.height,
      minWidth: subjectSize.width,
    );
  }

  @override
  bool shouldRelayout(SingleChildLayoutDelegate oldDelegate) {
    return true;
  }
}
