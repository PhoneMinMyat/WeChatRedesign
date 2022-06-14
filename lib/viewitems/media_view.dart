import 'dart:io';

import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:wechat_redesign/resources/dimens.dart';

class MediaView extends StatefulWidget {
  final bool isVideo;
  final String? mediaUrl;
  final File? mediaFile;
  final FlickManager? flickManager;
  const MediaView(
      {Key? key,
      required this.isVideo,
      this.mediaUrl,
      this.mediaFile,
      this.flickManager})
      : super(key: key);

  @override
  State<MediaView> createState() => _MediaViewState();
}

class _MediaViewState extends State<MediaView> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (widget.isVideo)
          ? (widget.flickManager != null)
              ? FlickVideoPlayer(flickManager: widget.flickManager!,)
              : Container()
          : (widget.mediaUrl != null ||
                  (widget.mediaUrl?.isNotEmpty ?? false))
              ? Image.network(
                  widget.mediaUrl ?? '',
                  fit: BoxFit.cover,
                )
              : Image.file(widget.mediaFile ?? File(''), fit: BoxFit.cover,),
    );
  }
}
