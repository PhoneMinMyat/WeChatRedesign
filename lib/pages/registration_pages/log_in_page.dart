import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wechat_redesign/bloc/registration_blocs/login_bloc.dart';
import 'package:wechat_redesign/pages/home_page.dart';
import 'package:wechat_redesign/resources/colors.dart';
import 'package:wechat_redesign/resources/dimens.dart';
import 'package:wechat_redesign/resources/strings.dart';
import 'package:wechat_redesign/utils/extension.dart';
import 'package:wechat_redesign/viewitems/primary_button.dart';
import 'package:wechat_redesign/widgets/label_and_text_field_view.dart';
import 'package:wechat_redesign/widgets/loading_view.dart';

class LogInPage extends StatelessWidget {
  const LogInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LogInBloc(),
      child: Scaffold(
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
        body: Consumer<LogInBloc>(
          builder: (context, bloc, child) => Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          kLblLogInTitle,
                          style: TextStyle(
                              color: Colors.white, fontSize: kTextRegular3x),
                        ),
                      ),
                      const SizedBox(
                        height: kMarginXLarge,
                      ),
                      LabelAndTextFieldView(
                        label: kLblAccount,
                        hintText: kLblInputHintTextForAccount,
                        onChangedText: (newText) {
                          bloc.onEmailChanged(newText);
                        },
                      ),
                      LabelAndTextFieldView(
                        label: kLblPassword,
                        hintText: kLblInputHintTextForPassword,
                        isPassword: true,
                        onChangedText: (newText) {
                          bloc.onPasswordChanged(newText);
                        },
                      ),
                      const SizedBox(
                        height: kMarginLarge,
                      ),
                      const Text(
                        kLblLogInViaMobileNo,
                        style: TextStyle(color: Colors.white70),
                      ),
                        SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                      ),
                      const Text(
                        kLblLogInPageUserMessage,
                        style: TextStyle(color: Colors.white54),
                      ),
                      const SizedBox(
                        height: kMarginMedium3,
                      ),
                      Center(
                        child: PrimaryButton(
                          onTap: () {
                            bloc
                                .onTapAccept()
                                .then((_) => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => const HomePage())))
                                .catchError((error) => showSnackBarWithMessage(
                                    context, error.toString()));
                          },
                          text: kLblLogInButtonMessage,
                          isDisable: false,
                        ),
                      ),
                      const SizedBox(
                        height: kMarginMedium2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            kLblUnableToLogIn,
                            style: TextStyle(color: Colors.white60),
                          ),
                          SizedBox(
                            width: kMarginMedium2,
                          ),
                          Text(
                            kLblMoreOptions,
                            style: TextStyle(color: Colors.white60),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: kMarginMedium3,
                      ),
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
