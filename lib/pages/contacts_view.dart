import 'package:azlistview/azlistview.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wechat_redesign/bloc/contacts_bloc.dart';
import 'package:wechat_redesign/data/vos/user_vo.dart';
import 'package:wechat_redesign/pages/chat_page.dart';
import 'package:wechat_redesign/resources/colors.dart';
import 'package:wechat_redesign/resources/dimens.dart';
import 'package:wechat_redesign/resources/strings.dart';
import 'package:wechat_redesign/viewitems/contact_item_view.dart';
import 'package:wechat_redesign/viewitems/custom_appbar_view.dart';
import 'package:wechat_redesign/widgets/icon_and_label_section_view.dart';
import 'package:wechat_redesign/widgets/no_data_placeholder_view.dart';
import 'package:wechat_redesign/widgets/space_for_app_bar.dart';

class ContactsView extends StatelessWidget {
  const ContactsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ContactsBloc(),
      child: Stack(
        children: [
          Positioned.fill(
              child: Column(
            children: const [
              SpaceForAppBar(),
              SearchBarView(),
              UserActionGroupSectionView(),
              ContactListView()
            ],
          )),
          const Align(
            alignment: Alignment.topCenter,
            child: CustomAppBarView(
              //leading: Icon(MdiIcons.abTesting),
              title: kLblContacts,
              action: Icon(
                MdiIcons.notebookPlus,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ContactListView extends StatelessWidget {
  const ContactListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ContactsBloc>(
      builder: (context, bloc, child) => Expanded(
        child: (bloc.contactList == null)
            ? const Center(
                child: CircularProgressIndicator(
                color: kPrimaryGreenColor,
              ))
            : (bloc.contactList?.isEmpty ?? true)
                ? const Center(
                    child: NoDataPlaceHolder(
                        imagePath: 'assets/images/contacts.png',
                        text: kLblPlaceHolderForContactsView))
                : AzListView(
                    data: bloc.azItems ?? [],
                    itemCount: bloc.azItems?.length ?? 0,
                    itemBuilder: (context, index) {
                      return AZListItemView(
                        azItem: bloc.azItems?[index] ??
                            AZItem(
                              tag: '',
                              user: UserVO(),
                            ),
                      );
                    },
                    indexBarHeight: 100,
                    indexBarItemHeight: 10,
                    indexBarData: SuspensionUtil.getTagIndexList(bloc.azItems),
                    
                  ),
      ),
    );
  }
}

class AZListItemView extends StatelessWidget {
  const AZListItemView({
    Key? key,
    required this.azItem,
  }) : super(key: key);

  final AZItem azItem;

  @override
  Widget build(BuildContext context) {
    UserVO tempUserVO = azItem.user;
    final offStage = !azItem.isShowSuspension;
    return Column(
      children: [
        Offstage(
          offstage: offStage,
          child: Container(
            height: 40,
            color: Colors.grey[300],
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kMarginLarge),
              child: Text(azItem.getSuspensionTag()),
            ),
          ),
        ),
        GestureDetector(
          onTap: (() {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChatPage(
                      friendId: tempUserVO.id ?? '',
                    )));
          }),
          child: ContactAndChatItemView(
            userName: tempUserVO.userName ?? '',
            profilePictureUrl:
                tempUserVO.profilePictureUrl ?? NETWORK_PROFILE_PLACEHOLDER,
            lastMessage: '',
          ),
        )
      ],
    );
  }
}

//  UserVO tempUserVO = bloc.contactList?[index] ?? UserVO();
//                       return GestureDetector(
//                         onTap: (() {
//                           Navigator.of(context).push(MaterialPageRoute(
//                               builder: (context) => ChatPage(
//                                     friendId: tempUserVO.id ?? '',
//                                   )));
//                         }),
//                         child: ContactAndChatItemView(
//                           userName: tempUserVO.userName ?? '',
//                           profilePictureUrl: tempUserVO.profilePictureUrl ??
//                               NETWORK_PROFILE_PLACEHOLDER,
//                           lastMessage: '',
//                         ),
//                       )

class UserActionGroupSectionView extends StatelessWidget {
  const UserActionGroupSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: kUserActionGroupHeight,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey, width: 0.5),
        ),
      ),
      //color: Colors.grey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          IconAndLabelView(
            iconData: MdiIcons.accountPlusOutline,
            text: kLblNewFriends,
          ),
          IconAndLabelView(
            iconData: MdiIcons.accountMultipleOutline,
            text: kLblGroupChat,
          ),
          IconAndLabelView(
            iconData: MdiIcons.tagMultipleOutline,
            text: kLblTags,
          ),
          IconAndLabelView(
            iconData: MdiIcons.accountBoxMultipleOutline,
            text: kLblOfficalAcccounts,
          ),
        ],
      ),
    );
  }
}

class SearchBarView extends StatelessWidget {
  const SearchBarView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: kMarginMedium2, vertical: kMarginMedium),
      width: double.infinity,
      height: kSearchBarHeight,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(kMarginSmall),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.search,
              color: Colors.grey,
              size: kMarginMedium2,
            ),
            SizedBox(
              width: kMarginSmall,
            ),
            Text(
              kLblSearch,
              style: TextStyle(color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }
}
