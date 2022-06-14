import 'package:flutter/material.dart';
import 'package:wechat_redesign/viewitems/media_view.dart';

class VideoTest extends StatelessWidget {
  const VideoTest({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: double.infinity,
          height: 200,
          child: MediaView(
              isVideo: true,
              mediaUrl:
                  'https://miro.medium.com/max/1400/1*H_MI5719mfSQUqy6ITU82g@2x.jpeg'),
        ),
      ),
    );
  }
}
