import 'package:flutter/material.dart';
import 'package:wechat_redesign/resources/dimens.dart';

class ContactAndChatItemView extends StatelessWidget {
  final bool isMessageView;
  const ContactAndChatItemView({
    Key? key,
    this.isMessageView = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: kContactItemHeight,
      padding: const EdgeInsets.only(
          left: kMarginMedium3, top: kMarginMedium2),
      child: Row(
        children: [
          const CircleAvatar(
            minRadius: 30,
            backgroundImage: NetworkImage(
                'https://media.istockphoto.com/photos/millennial-male-team-leader-organize-virtual-workshop-with-employees-picture-id1300972574?b=1&k=20&m=1300972574&s=170667a&w=0&h=2nBGC7tr0kWIU8zRQ3dMg-C5JLo9H2sNUuDjQ5mlYfo='),
          ),
          const SizedBox(
            width: kMarginMedium,
          ),
          Expanded(
            child: Container(
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
                      const Text(
                        'Alex Deane',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Spacer(),
                      (isMessageView)
                          ?const Padding(
                            padding:  EdgeInsets.only(right: kMarginMedium2),
                            child:  Text(
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
                  const Text(
                    'Cathay Pacific Airways Limited',
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
