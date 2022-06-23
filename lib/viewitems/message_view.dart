import 'package:flutter/material.dart';
import 'package:wechat_redesign/data/vos/message_vo.dart';
import 'package:wechat_redesign/resources/dimens.dart';
import 'package:wechat_redesign/resources/strings.dart';
import 'package:wechat_redesign/viewitems/media_view.dart';

class MessageView extends StatelessWidget {
  final MessageVO message;
  final Function(String) onTapImage;
  const MessageView({
    Key? key,
    required this.message,
    required this.onTapImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
        margin: const EdgeInsets.only(bottom: kMarginMedium2),
        width: double.infinity,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: (message.isUserMessage ?? false)
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  (message.isUserMessage ?? false)
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(right: kMarginMedium),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(
                                message.sentUserProfileUrl ??
                                    NETWORK_PROFILE_PLACEHOLDER),
                            radius: 18,
                          ),
                        ),
                  MessageBubble(
                      message: message,
                      onTapImage: (imageUrl) {
                        onTapImage(imageUrl);
                      })
                ]),
          ],
        ));
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.message,
    required this.onTapImage,
  }) : super(key: key);

  final MessageVO message;
  final Function(String) onTapImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kMarginMedium2),
          color: Colors.grey[300]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: (message.isUserMessage ?? false)
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          (message.fileUrl?.isEmpty ?? true)
              ? Container()
              : (message.isFileTypeVideo ?? false)
                  ?
                  // Video View
                  Container(
                      constraints: const BoxConstraints(
                        maxHeight: 200,
                        maxWidth: 200,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(kMarginMedium2),
                          topRight: const Radius.circular(kMarginMedium2),
                          bottomLeft: (message.message?.isEmpty ?? true)
                              ? const Radius.circular(kMarginMedium2)
                              : Radius.zero,
                          bottomRight: (message.message?.isEmpty ?? true)
                              ? const Radius.circular(kMarginMedium2)
                              : Radius.zero,
                        ),
                        child: MediaView(
                          isVideo: message.isFileTypeVideo ?? false,
                          mediaUrl: message.fileUrl,
                          isPhotoFill: true,
                        ),
                      ),
                    )
                  :
                  // Image View
                  GestureDetector(
                      onTap: () {
                        onTapImage(
                            message.fileUrl ?? NETWORK_PROFILE_PLACEHOLDER);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(kMarginMedium2),
                          topRight: const Radius.circular(kMarginMedium2),
                          bottomLeft: (message.message?.isEmpty ?? true)
                              ? const Radius.circular(kMarginMedium2)
                              : Radius.zero,
                          bottomRight: (message.message?.isEmpty ?? true)
                              ? const Radius.circular(kMarginMedium2)
                              : Radius.zero,
                        ),
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: Image.network(
                            message.fileUrl ?? NETWORK_PROFILE_PLACEHOLDER,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
          (message.message?.isEmpty ?? true)
              ? Container()
              : Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kMarginMedium, vertical: kMarginMedium),
                  child: Text(
                    message.message ?? '',
                  ),
                ),
        ],
      ),
    );
  }
}
