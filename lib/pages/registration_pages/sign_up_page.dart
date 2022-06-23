import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:wechat_redesign/bloc/registration_blocs/sign_up_bloc.dart';
import 'package:wechat_redesign/pages/registration_pages/terms_and_condition_page.dart';
import 'package:wechat_redesign/resources/colors.dart';
import 'package:wechat_redesign/resources/dimens.dart';
import 'package:wechat_redesign/resources/strings.dart';
import 'package:wechat_redesign/viewitems/primary_button.dart';
import 'package:wechat_redesign/widgets/label_and_text_field_view.dart';
import 'package:wechat_redesign/widgets/modl_bottom_sheet_item.dart';
import 'package:wechat_redesign/widgets/separator_view.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignUpBloc(),
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
            child: Column(mainAxisSize: MainAxisSize.min, children: const [
              Center(
                child: Text(
                  kLblSignUpByPhoneNumber,
                  style:
                      TextStyle(color: Colors.white, fontSize: kTextRegular3x),
                ),
              ),
              SizedBox(
                height: kMarginMedium2,
              ),
              ProfileInputSectionView(),
              SizedBox(
                height: kMarginLarge,
              ),
              UserTextFiedSectionView(),
              SizedBox(
                height: kMarginXXLarge * 3,
              ),
              UserAgreementAndButtonSectionView(),
            ]),
          ),
        ),
      ),
    );
  }
}

class UserAgreementAndButtonSectionView extends StatelessWidget {
  const UserAgreementAndButtonSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpBloc>(
      builder: (context, bloc, child) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Theme(
                data: ThemeData(unselectedWidgetColor: Colors.grey),
                child: Checkbox(
                  value: bloc.isCheckTermsAndCondition,
                  onChanged: (value) {
                    bloc.onTapTermsAndCondition(value);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kMarginMedium2),
                  ),
                  activeColor: kPrimaryGreenColor,
                ),
              ),
              RichText(
                text: TextSpan(children: [
                  const TextSpan(
                    text: kLblReadAndAccept,
                    style: TextStyle(color: Colors.grey),
                  ),
                  const TextSpan(text: '\t\t'),
                  TextSpan(
                      text: kLblTermsOfService,
                      style: const TextStyle(color: kBlueColor),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const TermsAndConditionPage()));
                        })
                ]),
              ),
            ],
          ),
          const Text(
            kLblSignUpUserGrantee,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: kTextRegular),
          ),
          const SizedBox(
            height: kMarginMedium3,
          ),
          PrimaryButton(
              onTap: () {
                bloc.onTapAcceptButton().then((user) {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TermsAndConditionPage(
                        user: user,
                        userProfile: bloc.choseImageFile,
                      ),
                    ),
                  );
                });
              },
              isDisable: !bloc.isConfirmButtonAvailable,
              text: kLblSignUpButtonLabel),
          const SizedBox(
            height: kMarginMedium3,
          ),
        ],
      ),
    );
  }
}

class UserTextFiedSectionView extends StatelessWidget {
  const UserTextFiedSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpBloc>(
      builder: (context, bloc, child) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LabelAndTextFieldView(
              label: kLblName,
              onChangedText: (newText) {
                bloc.onChangeName(newText);
              },
              hintText: kLblHintName),
          LabelAndTextFieldView(
              label: kLblRegion,
              isRegion: true,
              onChangedText: (newText) {
                bloc.onChangeDialNumber(newText);
              },
              dialNumber: bloc.dialNumber,
              hintText: kLblHintName),
          LabelAndTextFieldView(
              label: kLblPhone,
              isPhoneNumber: true,
              onChangedText: (newText) {
                bloc.onChangePhoneNumber(newText);
              },
              hintText: kLblHintPhone),
          LabelAndTextFieldView(
              label: kLblPassword,
              onChangedText: (newText) {
                bloc.onChangePassword(newText);
              },
              isPassword: true,
              hintText: kLblInputHintTextForPassword),
        ],
      ),
    );
  }
}

class ProfileInputSectionView extends StatelessWidget {
  const ProfileInputSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpBloc>(
      builder: (context, bloc, child) => GestureDetector(
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
                      text: kLblPickFromGallery,
                      onTap: () async {
                        Navigator.pop(context);
                        Future.delayed(const Duration(milliseconds: 1000))
                            .then((value) async {
                          final ImagePicker picker = ImagePicker();
                          // Pick an image
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            bloc.onTapChoseImageFile(File(image.path));
                          }
                        });
                      },
                    ),
                    ModalBottomSheetItem(
                      text: kLblPickFromCamera,
                      onTap: () async {
                        Navigator.pop(context);
                        Future.delayed(const Duration(milliseconds: 1000))
                            .then((value) async {
                          final ImagePicker picker = ImagePicker();
                          // Pick an image
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera);
                          if (image != null) {
                            bloc.onTapChoseImageFile(File(image.path));
                          }
                        });
                      },
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
        child: Container(
          width: kProfileInputWeight,
          height: kProfileInputWeight,
          color: Colors.grey,
          child: (bloc.choseImageFile != null)
              ? Image.file(
                  bloc.choseImageFile ?? File(''),
                  fit: BoxFit.cover,
                )
              : Padding(
                  padding: const EdgeInsets.all(kMarginMedium),
                  child: Image.asset('assets/images/camera_icon.png'),
                ),
        ),
      ),
    );
  }
}
