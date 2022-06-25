import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:wechat_redesign/resources/dimens.dart';

class LoadingView extends StatelessWidget {
  final bool isTransparentColor;
  const LoadingView({
    Key? key,this.isTransparentColor = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color:(isTransparentColor)? Colors.transparent : Colors.black12,
      child: const Center(
        child: SizedBox(
          width: kMarginXXLarge,
          height: kMarginXXLarge,
          child: LoadingIndicator(
            indicatorType: Indicator.audioEqualizer,
            colors: [Colors.white],
            strokeWidth: 2,
            backgroundColor: Colors.transparent,
            pathBackgroundColor: Colors.black,
          ),
        ),
      ),
    );
  }
}
