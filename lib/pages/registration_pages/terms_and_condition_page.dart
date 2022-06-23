import 'dart:io';

import 'package:flutter/material.dart';
import 'package:wechat_redesign/data/vos/user_vo.dart';
import 'package:wechat_redesign/pages/registration_pages/get_email_page.dart';
import 'package:wechat_redesign/resources/colors.dart';
import 'package:wechat_redesign/resources/dimens.dart';
import 'package:wechat_redesign/resources/strings.dart';
import 'package:wechat_redesign/resources/text_styles.dart';
import 'package:wechat_redesign/viewitems/primary_button.dart';

class TermsAndConditionPage extends StatefulWidget {
  final UserVO? user;
  final File? userProfile;
  const TermsAndConditionPage({Key? key, this.user, this.userProfile})
      : super(key: key);

  @override
  State<TermsAndConditionPage> createState() => _TermsAndConditionPageState();
}

class _TermsAndConditionPageState extends State<TermsAndConditionPage> {
  bool isAccept = false;

  void onTapAccept(newValue) {
    setState(() {
      isAccept = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: kRegistrationBlackColor,
      body: (widget.user == null)
          ? const SingleChildScrollView(child: TermsAndConditonView())
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Expanded(
                  child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: TermsAndConditonView()),
                ),
                Container(
                  width: double.infinity,
                  height: 120,
                  color: const Color.fromRGBO(15, 15, 15, 100),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Theme(
                            data: ThemeData(unselectedWidgetColor: Colors.grey),
                            child: Checkbox(
                              value: isAccept,
                              onChanged: (value) {
                                onTapAccept(value);
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(kMarginMedium2),
                              ),
                              activeColor: kPrimaryGreenColor,
                            ),
                          ),
                          const Text(
                            kLblTermsAndConditionAgree,
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                      PrimaryButton(
                        onTap: () {
                          if (isAccept) {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => GetEmailPage(
                                    user: widget.user!,
                                    file: widget.userProfile)));
                          }
                        },
                        text: kLblTermsAndConditionButtonLabel,
                        isDisable: !isAccept,
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}

class TermsAndConditonView extends StatelessWidget {
  const TermsAndConditonView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
      child: RichText(
        text: const TextSpan(
          children: [
            TextSpan(
                text: 'Terms and Conditions\n\n', style: kTandConTitleStyle),
            TextSpan(
                text: "Welcome to WeChat Redesign App\n\n",
                style: kTandConTextStyle),
            TextSpan(
                text:
                    "These terms and conditions outline the rules and regulations for the use of Company Name's Website, located at WeChatRedesign.com.\n\n",
                style: kTandConTextStyle),
            TextSpan(
                text:
                    "By accessing this website we assume you accept these terms and conditions. Do not continue to use Website Name if you do not agree to take all of the terms and conditions stated on this page.\n\n",
                style: kTandConTextStyle),
            TextSpan(
                text:
                    "The following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer Notice and all Agreements: “Client”, “You” and “Your” refers to you, the person log on this website and compliant to the Company's terms and conditions. “The Company”, “Ourselves”, “We”, “Our” and “Us”, refers to our Company. “Party”, “Parties”, or “Us”, refers to both the Client and ourselves. All terms refer to the offer, acceptance and consideration of payment necessary to undertake the process of our assistance to the Client in the most appropriate manner for the express purpose of meeting the Client's needs in respect of provision of the Company's stated services, in accordance with and subject to, prevailing law of Netherlands. Any use of the above terminology or other words in the singular, plural, capitalization and/or he/she or they, are taken as interchangeable and therefore as referring to same.\n\n",
                style: kTandConTextStyle),
            TextSpan(text: "Cookies\n\n", style: kTandConTitleStyle),
            TextSpan(
                text:
                    "We employ the use of cookies. By accessing Website Name, you agreed to use cookies in agreement with the Company Name's Privacy Policy.\n\n",
                style: kTandConTextStyle),
            TextSpan(
                text:
                    "Most interactive websites use cookies to let us retrieve the user's details for each visit. Cookies are used by our website to enable the functionality of certain areas to make it easier for people visiting our website. Some of our affiliate/advertising partners may also use cookies.\n\n",
                style: kTandConTextStyle),
            TextSpan(text: "License\n\n", style: kTandConTitleStyle),
            TextSpan(
                text:
                    "Unless otherwise stated, Company Name and/or its licensors own the intellectual property rights for all material on Website Name. All intellectual property rights are reserved. You may access this from Website Name for your own personal use subjected to restrictions set in these terms and conditions.\n\n",
                style: kTandConTextStyle),
            TextSpan(text: "You must not:\n\n", style: kTandConTextStyle),
            TextSpan(
                text:
                    "-Republish material from Website Name\n\n-Sell, rent or sub-license material from Website Name\n\n-Reproduce, duplicate or copy material from Website Name\n\n-Redistribute content from Website Name\n\n",
                style: kTandConTextStyle),
            TextSpan(
                text: "This Agreement shall begin on the date hereof.\n\n",
                style: kTandConTextStyle),
            TextSpan(
                text:
                    "Parts of this website offer an opportunity for users to post and exchange opinions and information in certain areas of the website. Company Name does not filter, edit, publish or review Comments prior to their presence on the website. Comments do not reflect the views and opinions of Company Name,its agents and/or affiliates. Comments reflect the views and opinions of the person who post their views and opinions. To the extent permitted by applicable laws, Company Name shall not be liable for the Comments or for any liability, damages or expenses caused and/or suffered as a result of any use of and/or posting of and/or appearance of the Comments on this website.\n\n",
                style: kTandConTextStyle),
            TextSpan(
                text: "You warrant and represent that:\n\n",
                style: kTandConTextStyle),
            TextSpan(
                text:
                    "-You are entitled to post the Comments on our website and have all necessary licenses and consents to do so;\n\n-The Comments do not invade any intellectual property right, including without limitation copyright, patent or trademark of any third party;\n\n-The Comments do not contain any defamatory, libelous, offensive, indecent or otherwise unlawful material which is an invasion of privacy\n\n-The Comments will not be used to solicit or promote business or custom or present commercial activities or unlawful activity.\n\n",
                style: kTandConTextStyle),
            TextSpan(
                text:
                    "You hereby grant Company Name a non-exclusive license to use, reproduce, edit and authorize others to use, reproduce and edit any of your Comments in any and all forms, formats or media.\n\n",
                style: kTandConTextStyle),
          ],
        ),
      ),
    );
  }
}
