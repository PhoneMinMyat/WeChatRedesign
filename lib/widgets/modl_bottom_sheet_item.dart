import 'package:flutter/material.dart';
import 'package:wechat_redesign/resources/dimens.dart';

class ModalBottomSheetItem extends StatelessWidget {
  final String text;
  final Function onTap;
  const ModalBottomSheetItem({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() {
        onTap();
      }),
      child: Container(
        height: kModalBottomSheetHeight,
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black45, width: 0.5),
          ),
        ),
        child: Center(
            child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        )),
      ),
    );
  }
}