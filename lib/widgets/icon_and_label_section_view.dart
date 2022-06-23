import 'package:flutter/material.dart';
import 'package:wechat_redesign/resources/dimens.dart';

class IconAndLabelView extends StatelessWidget {
  final IconData iconData;
  final String text;
  final bool isBorderExist;
  const IconAndLabelView({
    Key? key,
    required this.iconData,
    required this.text,
    this.isBorderExist = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: (isBorderExist)
          ? BoxDecoration(
              border: Border.all(width: 0.1, color: Colors.grey),
            )
          : null,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: kMarginMedium2,
            ),
            Icon(
              iconData,
              color: Colors.grey,
              size: 35,
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
        ),
      ),
    );
  }
}
