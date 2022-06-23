import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class MediaView extends StatefulWidget {
  final bool isVideo;
  final String? mediaUrl;
  final File? mediaFile;
  final bool isPhotoFill;
  const MediaView({
    Key? key,
    required this.isVideo,
    this.mediaUrl,
    this.mediaFile,
    this.isPhotoFill = false,
  }) : super(key: key);

  @override
  State<MediaView> createState() => _MediaViewState();
}

class _MediaViewState extends State<MediaView> {
  ChewieController? _chewieController;
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    initVideoPlayer();
    super.initState();
  }

  void initVideoPlayer() {
    // print('Receive isVideo ===> ${widget.isVideo}');
    // print('Receive media url ===> ${widget.mediaUrl}');
    if (widget.mediaUrl != null && (widget.mediaUrl?.isNotEmpty ?? false)) {
      // print('Chewie Controller Network');
      _videoPlayerController = VideoPlayerController.network(widget.mediaUrl!);
    } else if (widget.mediaFile != null) {
      // print('Chewie Controller File');
      _videoPlayerController = VideoPlayerController.file(widget.mediaFile!);
    } else {
      // print('Chewie Controller Null');
      _videoPlayerController = null;
    }

    if (_videoPlayerController != null) {
      _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!,
          autoInitialize: true,
          autoPlay: false,
          looping: true,
          // aspectRatio: _videoPlayerController?.value.aspectRatio,
          deviceOrientationsOnEnterFullScreen: [DeviceOrientation.portraitUp],
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
            );
          });
    }
  }

  Widget getMedia() {
    if (widget.isVideo) {
      //  print('Return Video');
      if (_chewieController != null) {
        // print('Return Chewie');
        return Expanded(child: Chewie(controller: _chewieController!));
      } else {
        // print('Return Container');
        return Container();
      }
    } else {
      //print('Return Image');
      if (widget.mediaUrl != null && (widget.mediaUrl?.isNotEmpty ?? false)) {
        //print('Return Network Image');
        return Image.network(
          widget.mediaUrl!,
          fit: (widget.isPhotoFill) ? BoxFit.fill : BoxFit.cover,
        );
      } else {
        if (widget.mediaFile != null) {
          return Image.file(
            widget.mediaFile!,
            fit: (widget.isPhotoFill) ? BoxFit.fill : BoxFit.cover,
          );
        } else {
          return Container();
        }
      }
    }
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getMedia();
  }
}
