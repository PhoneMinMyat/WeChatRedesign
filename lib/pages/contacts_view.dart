import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:wechat_redesign/resources/dimens.dart';
import 'package:wechat_redesign/resources/strings.dart';
import 'package:wechat_redesign/viewitems/contact_item_view.dart';
import 'package:wechat_redesign/viewitems/custom_appbar_view.dart';
import 'package:wechat_redesign/widgets/IconAndLabelView.dart';
import 'package:wechat_redesign/widgets/space_for_app_bar.dart';

class ContactsView extends StatelessWidget {
  const ContactsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
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
    );
  }
}

class ContactListView extends StatelessWidget {
  const ContactListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          dragStartBehavior: DragStartBehavior.start,
          itemCount: 15,
          itemBuilder: (context, index) => const ContactAndChatItemView()),
    );
  }
}

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
