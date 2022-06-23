import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wechat_redesign/bloc/profile_bloc.dart';
import 'package:wechat_redesign/pages/qr_page.dart';
import 'package:wechat_redesign/pages/registration_pages/welcome_page.dart';
import 'package:wechat_redesign/resources/colors.dart';
import 'package:wechat_redesign/resources/dimens.dart';
import 'package:wechat_redesign/resources/strings.dart';
import 'package:wechat_redesign/widgets/icon_and_label_section_view.dart';
import 'package:wechat_redesign/widgets/separator_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProfileBloc(),
      child: Consumer<ProfileBloc>(
        builder: (context, bloc, child) => (bloc.loggedInProfile == null)
            ? const CircularProgressIndicator(
                color: kPrimaryGreenColor,
              )
            : Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).viewPadding.top,
                    color: kPrimaryGreenColor,
                  ),
                  const TopUserView(),
                  const ButtonGroupSectionView(),
                  SeparatorView(
                    color: Colors.grey[400],
                  ),
                  const LogOutButtonView()
                ],
              ),
      ),
    );
  }
}

class LogOutButtonView extends StatelessWidget {
  const LogOutButtonView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileBloc>(
      builder: (context, bloc, child) => Expanded(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            border: const Border(
              bottom: BorderSide(color: Colors.grey, width: 0.5),
            ),
          ),
          child: Center(
            child: GestureDetector(
              onTap: () {
                bloc.onTapLogOut().then((value) => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const WelcomePage(),
                      ),
                    ));
              },
              child: Container(
                width: kLogOutButtonWidth,
                height: kLogOutButtonHeight,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.circular(kLogOutButtonHeight / 2),
                ),
                child: const Center(
                    child: Text(
                  kLblLogOut,
                  style: TextStyle(
                    fontSize: kTextRegular2X,
                  ),
                )),
              ),
            ),
          ),
        ),
      ),
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
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      children: const [
        IconAndLabelView(
            iconData: MdiIcons.imageOutline,
            text: kLblPhoto,
            isBorderExist: true),
        IconAndLabelView(
            iconData: MdiIcons.viewCarouselOutline,
            text: kLblFavourties,
            isBorderExist: true),
        IconAndLabelView(
            iconData: MdiIcons.walletOutline,
            text: kLblWallet,
            isBorderExist: true),
        IconAndLabelView(
            iconData: MdiIcons.creditCardOutline,
            text: kLblCards,
            isBorderExist: true),
        IconAndLabelView(
            iconData: MdiIcons.stickerEmoji,
            text: kLblStickers,
            isBorderExist: true),
        IconAndLabelView(
            iconData: MdiIcons.cogOutline,
            text: kLblSettings,
            isBorderExist: true),
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
    return Consumer<ProfileBloc>(
      builder: (context, bloc, child) => SizedBox(
        height: 240,
        width: double.infinity,
        child: Stack(children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: double.infinity,
              height: 120,
              color: kPrimaryGreenColor,
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: ProfilePictureView(
              profileUrl: bloc.loggedInProfile?.profilePictureUrl ??
                  NETWORK_PROFILE_PLACEHOLDER,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: UserNameAndKeyView(
              userId: bloc.loggedInProfile?.id ?? '',
              userName: bloc.loggedInProfile?.userName ?? '',
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(kMarginMedium2),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const QrViewPage(),
                    ),
                  );
                },
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
          ),
          Positioned(
            bottom: 20,
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
                ]),
              ),
            ),
          )
        ]),
      ),
    );
  }
}

class UserNameAndKeyView extends StatelessWidget {
  final String userName;
  final String userId;
  const UserNameAndKeyView({
    Key? key,
    required this.userName,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: kMarginMedium2,
        ),
        Text(
          userName,
          style: const TextStyle(
              color: Colors.white,
              fontSize: kTextRegular3x,
              fontWeight: FontWeight.w500),
        ),
        Text(
          userId,
          style: const TextStyle(
            color: Colors.white60,
            fontSize: kTextRegular,
          ),
        ),
      ],
    );
  }
}

class ProfilePictureView extends StatelessWidget {
  final String profileUrl;
  const ProfilePictureView({
    Key? key,
    required this.profileUrl,
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
              image: NetworkImage(profileUrl), fit: BoxFit.cover),
          color: kPrimaryGreenColor),
    );
  }
}
