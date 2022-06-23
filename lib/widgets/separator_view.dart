
import 'package:flutter/material.dart';
import 'package:wechat_redesign/resources/dimens.dart';

class SeparatorView extends StatelessWidget {
  final Color? color;
  const SeparatorView({
    Key? key, required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kMarginSmall,
      width: double.infinity,
      color: color,
    );
  }
}