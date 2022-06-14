import 'package:country_code_picker/country_code.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wechat_redesign/bloc/login_bloc.dart';
import 'package:wechat_redesign/pages/home_page.dart';

import 'package:wechat_redesign/resources/colors.dart';
import 'package:wechat_redesign/resources/dimens.dart';
import 'package:wechat_redesign/resources/strings.dart';
import 'package:wechat_redesign/resources/text_styles.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  String selectedCountyDialCode = '+95';

  void changeCountryDialCode(String newDialCode) {
    setState(() {
      selectedCountyDialCode = newDialCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LogInBloc(),
      builder: (context, child) => Selector<LogInBloc, bool>(
        selector: (context, bloc) => bloc.isSignUp,
        builder: (context, isSignUp, child) => Scaffold(
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              const LogoSectionView(),
              CountryChoseSectoinView(
                selectCountry: (dialCode) {
                  changeCountryDialCode(dialCode);
                },
              ),
              TextFieldWithIcons(
                phoneNumber: selectedCountyDialCode,
                trailIcon: Icons.close,
              ),
              const TextFieldWithIcons(
                leadIcon: Icons.lock,
                trailIcon: Icons.help,
                isPassword: true,
              ),
              const SizedBox(
                height: kMarginMedium3,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Container(
                  width: kLogInButtonWidth,
                  height: kLogInButtonHeight,
                  decoration: const BoxDecoration(
                    color: kPrimaryGreenColor,
                  ),
                  child:  Center(
                      child: Text(
                  (isSignUp)?  kLblLogIn : kLblSignUp,
                    style:const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: kTextRegular2X),
                  )),
                ),
              ),
              const Spacer(),
              TextButton(
                  onPressed: () {
                    LogInBloc bloc = Provider.of(context, listen: false);
                    bloc.onTapSwitchLogIn();
                  },
                  child: Text(
                   (isSignUp)? kLblSignUp : kLblLogIn,
                    style:const TextStyle(color: kPrimaryGreenColor),
                  ))
            ]),
          ),
        ),
      ),
    );
  }
}

class TextFieldWithIcons extends StatelessWidget {
  final String? phoneNumber;
  final IconData? leadIcon;
  final bool isPassword;
  final IconData trailIcon;
  const TextFieldWithIcons({
    Key? key,
    this.phoneNumber,
    this.leadIcon,
    this.isPassword = false,
    required this.trailIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          (phoneNumber != null)
              ? SizedBox(
                  width: 70,
                  child: Text(
                    phoneNumber ?? '',
                    textAlign: TextAlign.end,
                    style: kInputTextStyle,
                  ),
                )
              : Container(
                  padding: const EdgeInsets.only(left: kMarginXXLarge),
                  width: 70,
                  child: Icon(
                    leadIcon ?? Icons.person,
                    color: Colors.grey,
                  )),
          const SizedBox(
            width: kMarginMedium,
          ),
          Expanded(
              child: TextField(
            obscureText: isPassword,
            style: kInputTextStyle,
            decoration: const InputDecoration(border: InputBorder.none),
          )),
          const SizedBox(
            width: kMarginMedium,
          ),
          Icon(
            trailIcon,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}

class CountryChoseSectoinView extends StatelessWidget {
  final Function(String) selectCountry;
  const CountryChoseSectoinView({
    Key? key,
    required this.selectCountry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(right: kMarginMedium2, left: kMarginMedium),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12))),
      child: Row(
        children: [
          CountryCodePicker(
            showDropDownButton: true,
            barrierColor: kPrimaryGreenColor,
            padding: const EdgeInsets.all(0),
            showFlag: false,
            showOnlyCountryWhenClosed: true,
            initialSelection: 'myanmar',
            onChanged: (countryCode) {
              selectCountry(countryCode.dialCode ?? '');
            },
          ),
          const Spacer(),
          const Icon(
            Icons.more_horiz,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}

class LogoSectionView extends StatelessWidget {
  const LogoSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: kLogInIconHeight,
      child: Image.asset('assets/images/wechat.png'),
    );
  }
}
