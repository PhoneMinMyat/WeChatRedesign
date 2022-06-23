import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import 'package:wechat_redesign/bloc/chat_bloc.dart';
import 'package:wechat_redesign/data/vos/message_vo.dart';
import 'package:wechat_redesign/resources/colors.dart';
import 'package:wechat_redesign/resources/dimens.dart';
import 'package:wechat_redesign/resources/strings.dart';
import 'package:wechat_redesign/viewitems/custom_appbar_view.dart';
import 'package:wechat_redesign/viewitems/message_view.dart';
import 'package:wechat_redesign/widgets/icon_and_label_section_view.dart';
import 'package:wechat_redesign/widgets/space_for_app_bar.dart';

class ChatPage extends StatelessWidget {
  final String friendId;
  const ChatPage({
    Key? key,
    required this.friendId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChatBloc(friendId),
      child: Consumer<ChatBloc>(
        builder: (context, bloc, child) => Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                  child: Column(
                children: [
                  const SpaceForAppBar(),
                  Expanded(
                      child: (bloc.messageList == null)
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: kPrimaryGreenColor,
                              ),
                            )
                          : ListView.builder(
                              itemCount: bloc.messageList?.length,
                              shrinkWrap: true,
                              reverse: true,
                              itemBuilder: (context, index) => MessageView(
                                message:
                                    bloc.messageList?[index] ?? MessageVO(),
                                onTapImage: (fileUrl) {
                                  bloc.onTapImage(fileUrl);
                                },
                              ),
                            )),
                  const SizedBox(
                    height: 60,
                  )
                ],
              )),
              Align(
                alignment: Alignment.topCenter,
                child: CustomAppBarView(
                  //leading: Icon(MdiIcons.abTesting),
                  title: bloc.friendName,
                  isChatPage: true,
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Icon(
                          Icons.chevron_left,
                          color: Colors.white,
                        ),
                        Text(
                          'WeChat',
                          style: TextStyle(color: Colors.white70),
                        )
                      ],
                    ),
                  ),
                  action: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ),
              const Align(
                alignment: Alignment.bottomCenter,
                child: MessageInputSectionView(),
              ),
              Visibility(
                visible: bloc.isShowDetails,
                child: Positioned.fill(
                    child: Container(
                  color: kBlackHoverColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: double.infinity,
                          child: Image.network(bloc.fileUrlForShowDetail, fit: BoxFit.cover,)),
                      GestureDetector(
                        onTap: () {
                          bloc.closeDetails();
                        },
                        child: const Icon(
                          Icons.close,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MessageInputSectionView extends StatelessWidget {
  const MessageInputSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatBloc>(
      builder: (context, bloc, child) => SizedBox(
        height: bloc.isAttachViewExpanded
            ? null
            : (bloc.chosenFile != null)
                ? 210
                : 60,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              ChoseFileSectionView(),
              TextInputSectionView(),
              AddAttachmentView()
            ],
          ),
        ),
      ),
    );
  }
}

class ChoseFileSectionView extends StatelessWidget {
  const ChoseFileSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatBloc>(
      builder: (context, bloc, child) => (bloc.chosenFile == null)
          ? Container()
          : Container(
              color: Colors.white,
              height: 150,
              child: Stack(
                children: [
                  //Positioned.fill(child: Container(c))
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kMarginMedium2),
                      child: SizedBox(
                        width: 200,
                        height: 120,
                        child: (bloc.chosenFile != null && bloc.isFileTypeVideo)
                            ? Chewie(controller: bloc.chewieController!)
                            : Image.file(
                                bloc.chosenFile!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(kMarginMedium3),
                      child: GestureDetector(
                        onTap: () {
                          bloc.onTapDeleteChoseFile();
                        },
                        child: const Icon(
                          MdiIcons.closeCircle,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  )
                ],
              )),
    );
  }
}

class AddAttachmentView extends StatelessWidget {
  const AddAttachmentView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatBloc>(
      builder: (context, bloc, child) => Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
              left: kMarginLarge, right: kMarginLarge, bottom: kMarginMedium2),
          child: GridView(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4),
            children: [
              GestureDetector(
                onTap: () async {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    File file = File(result.files.single.path ?? '');
                    PlatformFile detailFile = result.files.first;

                    bloc.onTapChoseImageFile(file, detailFile.extension ?? '');
                  }
                },
                child: const IconAndLabelView(
                    iconData: Icons.image_outlined, text: kLblPhotosAndVideos),
              ),
              GestureDetector(
                onTap: () async {
                  Future.delayed(const Duration(milliseconds: 1000))
                      .then((value) async {
                    final ImagePicker picker = ImagePicker();
                    // Pick an image
                    final XFile? image =
                        await picker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      bloc.onTapChoseImageFile(File(image.path), 'jpg');
                    }
                  });
                },
                child: const IconAndLabelView(
                    iconData: Icons.camera_alt_outlined, text: kLblCamera),
              ),
              const IconAndLabelView(
                  iconData: Icons.camera_outlined, text: kLblSight),
              const IconAndLabelView(
                  iconData: Icons.video_call_outlined, text: kLblVideoCall),
              const IconAndLabelView(
                  iconData: MdiIcons.creditCardChipOutline,
                  text: kLblLuckMoney),
              const IconAndLabelView(
                  iconData: MdiIcons.swapHorizontal, text: kLblTransfer),
              const IconAndLabelView(
                  iconData: MdiIcons.heartCircleOutline, text: kLblFavourties),
              const IconAndLabelView(
                  iconData: MdiIcons.mapMarkerRadiusOutline,
                  text: kLblLocation),
            ],
          ),
        ),
      ),
    );
  }
}

class TextInputSectionView extends StatelessWidget {
  const TextInputSectionView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatBloc>(
      builder: (context, bloc, child) => Container(
        color: Colors.grey[300],
        padding: const EdgeInsets.symmetric(horizontal: kMarginMedium),
        height: 60,
        child: Row(
          children: [
            const Icon(
              Icons.mic_none,
              size: 30,
              color: Colors.black54,
            ),
            const SizedBox(
              width: kMarginMedium,
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: kMarginMedium),
                padding: const EdgeInsets.only(
                  // bottom: kMarginSmall,
                  left: kMarginMedium,
                ),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(kMarginMedium)),
                child: TextField(
                  onChanged: (value) {
                    bloc.onChangedMessage(value);
                  },
                  onSubmitted: (value) {
                    bloc.onSubmitted(value);
                  },
                  controller: TextEditingController(text: bloc.message),
                  decoration: InputDecoration(
                    suffixIcon: Icon(
                      Icons.emoji_emotions,
                      color: Colors.grey[700] ?? Colors.grey,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: kMarginMedium,
            ),
            GestureDetector(
              onTap: () {
                bloc.onTapAdd();
              },
              child: Icon(
                (bloc.isAttachViewExpanded) ? Icons.close : Icons.add,
                size: 35,
                color: Colors.black54,
              ),
            )
          ],
        ),
      ),
    );
  }
}
