

import 'package:flutter/material.dart';
import 'package:wechat_redesign/resources/dimens.dart';

class SpaceForAppBar extends StatelessWidget {
  const SpaceForAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height:  MediaQuery.of(context).viewPadding.top + kAppBarHeight,);
  }
}
