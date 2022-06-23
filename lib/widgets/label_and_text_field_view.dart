import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:wechat_redesign/resources/colors.dart';
import 'package:wechat_redesign/resources/dimens.dart';

class LabelAndTextFieldView extends StatelessWidget {
  final String label;
  final String hintText;
  final bool isRegion;
  final bool isPassword;
  final bool isPhoneNumber;
  final Function(String) onChangedText;
  final String dialNumber;
  const LabelAndTextFieldView({
    Key? key,
    this.isRegion = false,
    this.dialNumber = '+95',
    this.isPassword = false,
    this.isPhoneNumber = false,
    required this.label,
    required this.onChangedText,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border:
              Border(bottom: BorderSide(color: Colors.white12, width: 0.5))),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(
            width: (isRegion) ? kMarginMedium2 : kMarginLarge,
          ),
          (isRegion)
              ? Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CountryCodePicker(
                        barrierColor: kRegistrationBlackColor,
                        padding: const EdgeInsets.all(0),
                        textStyle: const TextStyle(
                            color: Colors.white, fontSize: kTextRegular2X),
                        showFlag: false,
                        dialogBackgroundColor: Colors.black45,
                        dialogTextStyle: const TextStyle(
                            color: Colors.white, fontSize: kTextRegular2X),
                        searchStyle: const TextStyle(
                            color: Colors.white, fontSize: kTextRegular2X),
                        showOnlyCountryWhenClosed: true,
                        initialSelection: 'myanmar',
                        onChanged: (countryCode) {
                          onChangedText(countryCode.dialCode ?? '');
                        },
                      ),
                      Text(
                        '($dialNumber)',
                        style: const TextStyle(
                            color: Colors.white, fontSize: kTextRegular2X),
                      )
                    ],
                  ),
                )
              : Expanded(
                  child: TextField(
                  onChanged: ((value) {
                    onChangedText(value);
                  }),
                  keyboardType: (isPhoneNumber)
                      ? TextInputType.phone
                      : TextInputType.emailAddress,
                  obscureText: isPassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      color: Colors.white30,
                    ),
                  ),
                )),
        ],
      ),
    );
  }
}
