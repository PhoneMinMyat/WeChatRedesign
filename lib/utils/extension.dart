import 'package:flutter/material.dart';
import 'package:wechat_redesign/resources/colors.dart';
import 'package:wechat_redesign/resources/dimens.dart';

extension NavigationUtility on Widget {
  void showCustomDialog(
      {required BuildContext context, required Widget contentBox}) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kMarginMedium3),
            ),
            elevation: 0,
            backgroundColor: kPrimaryGreenColor,
            child: contentBox,
          );
        });
  }

  void showSnackBarWithMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}
