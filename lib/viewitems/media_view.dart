import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaView extends StatefulWidget {
  final bool isVideo;
  final String? mediaUrl;
  final File? mediaFile;
  const MediaView({
    Key? key,
    required this.isVideo,
    this.mediaUrl,
    this.mediaFile,
  }) : super(key: key);

  @override
  State<MediaView> createState() => _MediaViewState();
}

class _MediaViewState extends State<MediaView> {
  ChewieController? _chewieController;
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    if (widget.mediaUrl != null && (widget.mediaUrl?.isNotEmpty ?? false)) {
      _videoPlayerController = VideoPlayerController.network(widget.mediaUrl!);
    } else if (widget.mediaFile != null) {
      _videoPlayerController = VideoPlayerController.file(widget.mediaFile!);
    } else {
      _videoPlayerController = null;
    }

    if (_videoPlayerController != null) {
      _chewieController = ChewieController(
          videoPlayerController: _videoPlayerController!,
          autoInitialize: true,
          aspectRatio: 16 / 9,
          autoPlay: false,
          looping: false,
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
            );
          });
    }

    super.initState();
  }

  Widget getMedia() {
    if (widget.isVideo) {
      if (_chewieController != null) {
        return Chewie(controller: _chewieController!);
      } else {
        return Container();
      }
    } else {
      if (widget.mediaUrl != null && (widget.mediaUrl?.isNotEmpty ?? false)) {
        return Image.network(
          widget.mediaUrl!,
          fit: BoxFit.scaleDown,
        );
      } else {
        if (widget.mediaFile != null) {
          return Image.file(
            widget.mediaFile!,
            fit: BoxFit.scaleDown,
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
