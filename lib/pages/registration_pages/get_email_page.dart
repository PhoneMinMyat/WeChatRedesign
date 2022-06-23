import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_redesign/bloc/registration_blocs/get_email_bloc.dart';
import 'package:wechat_redesign/data/vos/user_vo.dart';
import 'package:wechat_redesign/pages/registration_pages/welcome_page.dart';
import 'package:wechat_redesign/resources/colors.dart';
import 'package:wechat_redesign/resources/dimens.dart';
import 'package:wechat_redesign/resources/strings.dart';
import 'package:wechat_redesign/utils/extension.dart';
import 'package:wechat_redesign/viewitems/primary_button.dart';
import 'package:wechat_redesign/widgets/label_and_text_field_view.dart';
import 'package:wechat_redesign/widgets/loading_view.dart';

class GetEmailPage extends StatelessWidget {
  final UserVO user;
  final File? file;
  const GetEmailPage({Key? key, required this.user, this.file})
      : super(key: key);

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
      body: ChangeNotifierProvider(
        create: (context) => GetEmailBloc(user, file),
        child: Consumer<GetEmailBloc>(
          builder: (context, bloc, child) => Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: kMarginMedium2),
                  child: Column(
                    children: [
                      const Center(
                        child: Text(
                          kLblEmailVerification,
                          style: TextStyle(
                              color: Colors.white, fontSize: kTextRegular3x),
                        ),
                      ),
                      const SizedBox(
                        height: kMarginLarge,
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: kMarginMedium),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom:
                                BorderSide(color: Colors.white12, width: 0.5),
                          ),
                        ),
                        child: const Text(
                          kLblEnterVerificationInformation,
                          style: TextStyle(
                              color: Colors.grey, fontSize: kTextSmall2),
                        ),
                      ),
                      LabelAndTextFieldView(
                          label: kLblEmail,
                          onChangedText: (newText) {
                            bloc.onChangeEmail(newText);
                          },
                          hintText: kLblHintTextForEmail),
                      const SizedBox(
                        height: 400,
                      ),
                      PrimaryButton(
                        onTap: () {
                          bloc
                              .onTapOk()
                              .then((value) => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const WelcomePage()),
                                  (route) => false))
                              .catchError((error) => showSnackBarWithMessage(
                                  context, error.toString()));
                        },
                        text: kLblOk,
                        isDisable: (bloc.email.isEmpty),
                      )
                    ],
                  ),
                ),
              ),
              Visibility(visible: bloc.isLoading, child: const LoadingView())
            ],
          ),
        ),
      ),
    );
  }
}
