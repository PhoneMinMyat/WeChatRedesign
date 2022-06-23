import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wechat_redesign/bloc/wechat_message_list_bloc.dart';
import 'package:wechat_redesign/pages/chat_page.dart';
import 'package:wechat_redesign/resources/colors.dart';
import 'package:wechat_redesign/resources/dimens.dart';
import 'package:wechat_redesign/resources/strings.dart';
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
        builder: (context, bloc, child) => Container(
          child: Stack(
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
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: bloc.conversationList?.length,
                                  itemBuilder: (context, index) => Slidable(
                                        key: Key('Message' + index.toString()),
                                        endActionPane: ActionPane(
                                            motion: const DrawerMotion(),
                                            extentRatio: 0.25,
                                            children: [
                                              SlidableAction(
                                                flex: 1,
                                                onPressed: (context) {
                                                  bloc.onTapDelete(bloc
                                                          .conversationList?[
                                                              index]
                                                          .userId ??
                                                      '');
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
                                                    builder: (context) =>
                                                        ChatPage(
                                                          friendId: bloc
                                                                  .conversationList?[
                                                                      index]
                                                                  .userId ??
                                                              '',
                                                        )));
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
            ],
          ),
        ),
      ),
    );
  }
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
        children: const [
          IconAndLabelView(
              iconData: MdiIcons.messageProcessingOutline,
              text: kLblAddGroupChat),
          IconAndLabelView(
              iconData: MdiIcons.accountPlusOutline, text: kLblAddContact),
          IconAndLabelView(iconData: MdiIcons.qrcodeScan, text: kLblScanQrCode),
        ],
      ),
    );
  }
}
