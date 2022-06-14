import 'package:flutter/material.dart';
import 'package:wechat_redesign/resources/colors.dart';
import 'package:wechat_redesign/resources/dimens.dart';
import 'package:wechat_redesign/resources/text_styles.dart';

class CustomAppBarView extends StatelessWidget {
  final String title;
  final Widget? leading;
  final Widget? action;
  const CustomAppBarView(
      {Key? key, required this.title, this.leading, this.action})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).viewPadding.top + kAppBarHeight,
      color: kPrimaryGreenColor,
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).viewPadding.top,
            left: kMarginMedium2,
            right: kMarginMedium2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (leading != null)
                ? leading ?? Container()
                : Container(
                    width: kMarginXLarge,
                  ),
            const Spacer(),
            Text(
              title,
              style: kLabelextStyle,
            ),
            const Spacer(),
            (action != null) ? action ?? Container() : Container(),
          ],
        ),
      ),
    );
  }
}
