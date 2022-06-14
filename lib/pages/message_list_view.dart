import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wechat_redesign/bloc/message_list_bloc.dart';
import 'package:wechat_redesign/resources/dimens.dart';
import 'package:wechat_redesign/resources/strings.dart';
import 'package:wechat_redesign/viewitems/contact_item_view.dart';
import 'package:wechat_redesign/viewitems/custom_appbar_view.dart';
import 'package:wechat_redesign/widgets/IconAndLabelView.dart';
import 'package:wechat_redesign/widgets/space_for_app_bar.dart';

class MessageListView extends StatelessWidget {
  const MessageListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MessageListBloc(),
      builder: (context, child) => Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                const SpaceForAppBar(),
                Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const AlwaysScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 20,
                      itemBuilder: (context, index) =>
                          const ContactAndChatItemView(
                            isMessageView: true,
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
                            child: AddChatSectionView(),
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
