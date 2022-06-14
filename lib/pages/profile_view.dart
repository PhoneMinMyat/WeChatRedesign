import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:wechat_redesign/resources/colors.dart';
import 'package:wechat_redesign/resources/dimens.dart';
import 'package:wechat_redesign/resources/strings.dart';
import 'package:wechat_redesign/widgets/IconAndLabelView.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).viewPadding.top,
          color: kPrimaryGreenColor,
        ),
        const TopUserView(),
        const ButtonGroupSectionView()
      ],
    );
  }
}

class ButtonGroupSectionView extends StatelessWidget {
  const ButtonGroupSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      children: [
        IconAndLabelView(iconData: Icons.photo, text: 'Photos'),
      ],
    );
  }
}

class TopUserView extends StatelessWidget {
  const TopUserView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 280,
      width: double.infinity,
      child: Stack(children: [
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: double.infinity,
            height: 140,
            color: kPrimaryGreenColor,
          ),
        ),
        const Align(
          alignment: Alignment.center,
          child: ProfilePictureView(),
        ),
        const Align(
          alignment: Alignment.topCenter,
          child: UserNameAndKeyView(),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(kMarginMedium2),
            child: Row(mainAxisSize: MainAxisSize.min, children: const [
              Icon(
                MdiIcons.qrcode,
                color: Colors.white,
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white,
              )
            ]),
          ),
        ),
        Positioned(
          bottom: 50,
          left: 10,
          right: 10,
          child: Center(
            child: RichText(
                text: TextSpan(children: [
              TextSpan(
                text: 'SQUR',
                style: const TextStyle(color: Colors.black54),
              ),
              const TextSpan(text: '\t\t'),
              TextSpan(
                  text: 'Edit',
                  style: const TextStyle(color: kBlueColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      print('Edit');
                    })
            ])),
          ),
        )
      ]),
    );
  }
}

class UserNameAndKeyView extends StatelessWidget {
  const UserNameAndKeyView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: kMarginMedium2,
        ),
        Text(
          'Phone Min Myat',
          style: TextStyle(
              color: Colors.white,
              fontSize: kTextRegular3x,
              fontWeight: FontWeight.w500),
        ),
        Text(
          'asdfasf',
          style: TextStyle(
            color: Colors.white60,
            fontSize: kTextRegular,
          ),
        ),
      ],
    );
  }
}

class ProfilePictureView extends StatelessWidget {
  const ProfilePictureView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            width: 4,
            color: Colors.white,
          ),
          image: DecorationImage(
              image: NetworkImage(
                tempProfileLink,
              ),
              fit: BoxFit.cover)),
    );
  }
}
