import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wechat_redesign/bloc/wechat_message_list_bloc.dart';
import 'package:wechat_redesign/pages/chat_page.dart';
import 'package:wechat_redesign/pages/qr_scan_page.dart';
import 'package:wechat_redesign/resources/colors.dart';
import 'package:wechat_redesign/resources/dimens.dart';
import 'package:wechat_redesign/resources/strings.dart';
import 'package:wechat_redesign/utils/extension.dart';
import 'package:wechat_redesign/viewitems/contact_item_view.dart';
import 'package:wechat_redesign/viewitems/custom_appbar_view.dart';
import 'package:wechat_redesign/widgets/icon_and_label_section_view.dart';
import 'package:wechat_redesign/widgets/no_data_placeholder_view.dart';
import 'package:wechat_redesign/widgets/space_for_app_bar.dart';

class WeChatMessageView extends StatelessWidget {
  const WeChatMessageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WeChatMessageBloc(),
      builder: (context, child) => Consumer<WeChatMessageBloc>(
        builder: (context, bloc, child) => Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  const SpaceForAppBar(),
                  Expanded(
                    child: (bloc.conversationList == null)
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: kPrimaryGreenColor,
                            ),
                          )
                        : (bloc.conversationList?.isEmpty ?? true)
                            ? const Center(
                                child: NoDataPlaceHolder(
                                    imagePath: 'assets/images/no_message.png',
                                    text: kLblPlaceHolderForChatView),
                              )
                            : ListView.builder(
                                padding: EdgeInsets.zero,
                                physics: const AlwaysScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: bloc.conversationList?.length,
                                itemBuilder: (context, index) => Slidable(
                                      key: Key('Message$index'),
                                      endActionPane: ActionPane(
                                          motion: const DrawerMotion(),
                                          extentRatio: 0.25,
                                          children: [
                                            SlidableAction(
                                              flex: 1,
                                              onPressed: (context) {
                                                bloc.showConfirmDialog(bloc.conversationList?[index].userId ?? '');
                                              },
                                              backgroundColor:
                                                  Colors.grey[200] ??
                                                      Colors.grey,
                                              autoClose: true,
                                              icon: MdiIcons.closeCircle,
                                              foregroundColor: Colors.red,
                                            ),
                                          ]),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => ChatPage(
                                                friendId: bloc
                                                        .conversationList?[
                                                            index]
                                                        .userId ??
                                                    '',
                                              ),
                                            ),
                                          );
                                        },
                                        child: ContactAndChatItemView(
                                          isMessageView: true,
                                          profilePictureUrl: bloc
                                                  .conversationList?[index]
                                                  .profilePictureUrl ??
                                              NETWORK_PROFILE_PLACEHOLDER,
                                          userName: bloc
                                                  .conversationList?[index]
                                                  .name ??
                                              '',
                                          lastMessage: bloc
                                              .conversationList?[index]
                                              .getLastMessage(),
                                        ),
                                      ),
                                    )),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: CustomAppBarView(
                //leading: Icon(MdiIcons.abTesting),
                title: kLblWeChat,
                action: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(kMarginMedium)),
                              child: const AddChatSectionView(),
                            ));
                  },
                  child: const Icon(
                    MdiIcons.plus,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Visibility(
                visible: bloc.isConfirmDialogShow,
                child: const CustomDialogView(),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CustomDialogView extends StatelessWidget {
  const CustomDialogView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WeChatMessageBloc>(
      builder: (context, bloc, child) => Container(
        width: 300,
        padding: const EdgeInsets.symmetric(
            horizontal: kMarginXLarge, vertical: kMarginXLarge),
        decoration: BoxDecoration(
            color: kPrimaryGreenColor,
            borderRadius: BorderRadius.circular(kMarginLarge)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              kLblAskConfirm,
              style: TextStyle(fontSize: kTextHeading, color: Colors.white),
            ),
            const SizedBox(
              height: kMarginMedium2,
            ),
            const Text(
              kLblMessageDeleteConfirmText,
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(
              height: kMarginMedium,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Theme(
                  data: ThemeData(unselectedWidgetColor: Colors.white),
                  child: Checkbox(
                    value: bloc.deleteForAllUsers,
                    onChanged: (value) {
                      bloc.onTapCheckBox(value);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kMarginMedium2),
                    ),
                    activeColor: Colors.black,
                  ),
                ),
                const Text(
                  'Delete For All Users',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Spacer(),
                TextButton(
                  onPressed: () {
                    bloc.hideConfirmDialog();
                  },
                  style: TextButton.styleFrom(primary: Colors.white),
                  child: const Text(kLblCancel),
                ),
                TextButton(
                  onPressed: () {
                    bloc.onTapDelete();
                  },
                  style: TextButton.styleFrom(primary: Colors.white),
                  child: const Text(kLblConfirm),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// customAlertDialog(
//                                                           onTapCancel: () {
//                                                             Navigator.pop(
//                                                                 context);
//                                                           },
//                                                           onTapConfirm: () {
//                                                             bloc
//                                                                 .onTapDelete(bloc
//                                                                         .conversationList?[
//                                                                             index]
//                                                                         .userId ??
//                                                                     '')
//                                                                 .then((value) =>
//                                                                     Navigator.pop(
//                                                                         context));
//                                                           },
//                                                           checkBoxValue: bloc
//                                                               .deleteForAllUsers ,
//                                                           onTapCheckBox:
//                                                               (newValue) {
//                                                             bloc.onTapCheckBox(
//                                                                 newValue);
//                                                           }),

AlertDialog customAlertDialog(
    {required Function onTapCancel,
    required Function onTapConfirm,
    required bool checkBoxValue,
    required Function(bool?) onTapCheckBox}) {
  return AlertDialog(
    backgroundColor: kPrimaryGreenColor,
    title: const Text(
      kLblAskConfirm,
      style: TextStyle(fontSize: kTextHeading, color: Colors.white),
    ),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          kLblMessageDeleteConfirmText,
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(
          height: kMarginMedium,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Theme(
              data: ThemeData(unselectedWidgetColor: Colors.white),
              child: Checkbox(
                value: checkBoxValue,
                onChanged: (value) {
                  onTapCheckBox(value);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kMarginMedium2),
                ),
                activeColor: Colors.black,
              ),
            ),
            const Text(
              'Delete For All Users',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () {
          onTapCancel();
        },
        style: TextButton.styleFrom(primary: Colors.white),
        child: const Text(kLblCancel),
      ),
      TextButton(
        onPressed: () {
          onTapConfirm();
        },
        style: TextButton.styleFrom(primary: Colors.white),
        child: const Text(kLblConfirm),
      ),
    ],
  );
}

class AddChatSectionView extends StatelessWidget {
  const AddChatSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: kAddMessagePopUpWidth,
      height: kAddMessagePopUpHeight,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(kMarginMedium),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const IconAndLabelView(
              iconData: MdiIcons.messageProcessingOutline,
              text: kLblAddGroupChat),
          const IconAndLabelView(
              iconData: MdiIcons.accountPlusOutline, text: kLblAddContact),
          GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const QrScanPage()));
              },
              child: const IconAndLabelView(
                  iconData: MdiIcons.qrcodeScan, text: kLblScanQrCode)),
        ],
      ),
    );
  }
}
