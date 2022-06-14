import 'package:flutter/material.dart';
import 'package:wechat_redesign/resources/dimens.dart';

class IconAndLabelView extends StatelessWidget {
  final IconData iconData;
  final String text;
  final bool isRightBorderExist;
  const IconAndLabelView({
    Key? key,
    required this.iconData,
    required this.text,
    this.isRightBorderExist = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(
          height: kMarginMedium2,
        ),
        Icon(
          iconData,
          color: Colors.grey,
        ),
        const SizedBox(
          height: kMarginMedium,
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        )
      ],
    );
  }
}