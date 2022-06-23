import 'package:flutter/material.dart';
import 'package:wechat_redesign/pages/registration_pages/log_in_page.dart';
import 'package:wechat_redesign/pages/registration_pages/sign_up_page.dart';
import 'package:wechat_redesign/resources/colors.dart';
import 'package:wechat_redesign/resources/dimens.dart';
import 'package:wechat_redesign/resources/strings.dart';
import 'package:wechat_redesign/viewitems/primary_button.dart';
import 'package:wechat_redesign/widgets/modl_bottom_sheet_item.dart';
import 'package:wechat_redesign/widgets/separator_view.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/moonlight.jpg'),
                  fit: BoxFit.cover)),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Padding(
              padding: const EdgeInsets.all(kMarginMedium2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  PrimaryButton(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LogInPage()));
                    },
                    text: kLblLogIn,
                  ),
                  PrimaryButton(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.grey[800],
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(kMarginMedium2),
                                  topRight: Radius.circular(kMarginMedium2))),
                          builder: (context) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ModalBottomSheetItem(
                                  text: kLblSignUpWithMobile,
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const SignUpPage()));
                                  },
                                ),
                                ModalBottomSheetItem(
                                  text: kLblSignUpWithFacebook,
                                  onTap: () {},
                                ),
                                SeparatorView(
                                  color: Colors.grey[850],
                                ),
                                ModalBottomSheetItem(
                                  text: kLblCancel,
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                )
                              ],
                            );
                          });
                    },
                    text: kLblSignUp,
                    isGreen: false,
                  ),
                ],
              ),
            )
          ])),
    );
  }
}


