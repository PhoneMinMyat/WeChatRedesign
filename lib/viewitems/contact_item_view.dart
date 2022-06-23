import 'package:flutter/material.dart';
import 'package:wechat_redesign/resources/dimens.dart';

class ContactAndChatItemView extends StatelessWidget {
  final bool isMessageView;
  final String userName;
  final String? lastMessage;
  final String profilePictureUrl;
  const ContactAndChatItemView({
    Key? key,
    this.isMessageView = false,
    required this.userName,
    this.lastMessage,
    required this.profilePictureUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      height: kContactItemHeight,
      padding: const EdgeInsets.only(left: kMarginMedium3, top: kMarginMedium2),
      child: Row(
        children: [
          CircleAvatar(
            minRadius: 30,
            backgroundImage: NetworkImage(profilePictureUrl),
          ),
          const SizedBox(
            width: kMarginMedium,
          ),
          Expanded(
            child: Container(
              padding: (isMessageView)? EdgeInsets.only(top: kMarginMedium) : EdgeInsets.zero,
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.black26),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: (isMessageView)
                    ? MainAxisAlignment.start
                    : MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      (isMessageView)
                          ? const Padding(
                              padding: EdgeInsets.only(right: kMarginMedium2),
                              child: Text(
                                '12/08/22',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: kTextRegular),
                              ),
                            )
                          : Container()
                    ],
                  ),
                  const SizedBox(
                    height: kMarginSmall,
                  ),
                  Text(
                    lastMessage ?? '',
                    style: TextStyle(color: Colors.grey, fontSize: kTextSmall),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
