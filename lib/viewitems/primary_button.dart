import 'package:flutter/material.dart';
import 'package:wechat_redesign/resources/colors.dart';
import 'package:wechat_redesign/resources/dimens.dart';

class PrimaryButton extends StatelessWidget {
  final bool isGreen;
  final Function onTap;
  final String text;
  final bool isDisable;
  const PrimaryButton({
    Key? key,
    this.isGreen = true,
    required this.onTap,
    required this.text,
    this.isDisable = false,
  }) : super(key: key);

  Color getBackGroundColor() {
    if (isDisable) {
      return Colors.grey[800] ?? Colors.grey;
    }

    if(isGreen && !isDisable){
      return kPrimaryGreenColor;
    }else{
      return Colors.grey[850] ?? Colors.grey;
    }
  }

  Color getTextColor(){
    if(isDisable){
      return Colors.grey[700] ?? Colors.grey;
    }else{
      return Colors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap();
      },
      child: Container(
        height: kPrimaryButtonHeight,
        width: kPrimaryButtonWidth,
        decoration: BoxDecoration(
            color: getBackGroundColor(),
            borderRadius: BorderRadius.circular(kMarginMedium)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: getTextColor(), fontSize: kTextRegular2X),
          ),
        ),
      ),
    );
  }
}
