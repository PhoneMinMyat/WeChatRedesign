import 'package:flutter/material.dart';
import 'package:wechat_redesign/resources/dimens.dart';

class NoDataPlaceHolder extends StatelessWidget {
  final String imagePath;
  final String text;
  const NoDataPlaceHolder(
      {Key? key, required this.imagePath, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
         SizedBox(
          height: 100,
          width: 100,
          child: Image.asset(imagePath),
        ),
        const SizedBox(
          height: kMarginMedium2,
        ),
        Text(
          text,
          style: const TextStyle( fontSize: kTextRegular),
        )
      ],
    );
  }
}
