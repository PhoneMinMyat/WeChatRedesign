import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wechat_redesign/bloc/add_new_moment_bloc.dart';
import 'package:wechat_redesign/data/vos/moment_vo.dart';
import 'package:wechat_redesign/resources/dimens.dart';
import 'package:wechat_redesign/resources/strings.dart';
import 'package:wechat_redesign/viewitems/custom_appbar_view.dart';
import 'package:wechat_redesign/viewitems/media_view.dart';
import 'package:wechat_redesign/widgets/loading_view.dart';
import 'package:wechat_redesign/widgets/space_for_app_bar.dart';

class AddMomentPage extends StatelessWidget {
  final MomentVO? editMomentId;
  const AddMomentPage({Key? key, this.editMomentId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AddNewMomentBloc(editMomentId),
      child: Scaffold(
        body: Consumer<AddNewMomentBloc>(
          builder: (context, bloc, child) => Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  child: Column(
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      const SpaceForAppBar(),
                      const Padding(
                        padding: EdgeInsets.all(kMarginMedium2),
                        child: UserProfileAndNameView(),
                      ),
                      const AddNewMomentTextFieldView(),
                      const PostDescriptionErrorView(),
                      const PostFileView(),
                      Visibility(
                        visible: bloc.isExpanded,
                        child: const SizedBox(
                          height: 300,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: CustomAppBarView(
                  title: (bloc.isEditMode) ? kLblEditMoment : kLblCreateMoment,
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                    ),
                  ),
                  action: GestureDetector(
                    onTap: () {
                      bloc.onTapPost().then((value) {
                        Navigator.pop(context);
                      });
                    },
                    child: const Text(
                      kLblPost,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: PostAttachSectionView(
                  onTapPhotoAndVideo: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();
                    if (result != null) {
                      File file = File(result.files.single.path ?? '');
                      PlatformFile detailFile = result.files.first;

                      bloc.onImageChosen(file, detailFile.extension ?? '');
                    }
                  },
                  onTapExpanded: () {
                    bloc.onTapExpanded();
                  },
                  isExpanded: bloc.isExpanded,
                ),
              ),
              Visibility(
                visible: bloc.isLoading,
                child: Container(
                  color: Colors.black12,
                  child: const Center(
                    child: LoadingView(),
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

class PostAttachSectionView extends StatelessWidget {
  final Function onTapPhotoAndVideo;
  final Function onTapExpanded;
  final bool isExpanded;
  const PostAttachSectionView({
    required this.onTapPhotoAndVideo,
    required this.onTapExpanded,
    required this.isExpanded,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (isExpanded) ? null : kHorizontalIconAndLabelViewHeight * 2,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                onTapExpanded();
              },
              child: SizedBox(
                height: kHorizontalIconAndLabelViewHeight,
                child: Icon(
                  (isExpanded) ? MdiIcons.menuDown : MdiIcons.menuUp,
                  color: Colors.black54,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                onTapPhotoAndVideo();
              },
              child: const HorizontalIconAndLabelView(
                icon: Icon(
                  Icons.photo,
                  color: Colors.green,
                ),
                text: 'Photo/Video',
              ),
            ),
            const HorizontalIconAndLabelView(
              icon: Icon(
                Icons.person,
                color: Colors.blue,
              ),
              text: 'Tag People',
            ),
            const HorizontalIconAndLabelView(
              icon: Icon(
                Icons.emoji_emotions,
                color: Colors.orange,
              ),
              text: 'Emoji',
            ),
            const HorizontalIconAndLabelView(
              icon: Icon(
                Icons.pin_drop,
                color: Colors.deepOrange,
              ),
              text: 'Location',
            ),
            const HorizontalIconAndLabelView(
              icon: Icon(
                Icons.video_camera_front,
                color: Colors.red,
              ),
              text: 'Live Video',
            ),
            const HorizontalIconAndLabelView(
              icon: Icon(
                Icons.font_download,
                color: Colors.green,
              ),
              text: 'Background Color',
            ),
            const HorizontalIconAndLabelView(
              icon: Icon(
                Icons.camera_alt,
                color: Colors.blue,
              ),
              text: 'Camera',
            ),
          ],
        ),
      ),
    );
  }
}

class PostFileView extends StatelessWidget {
  const PostFileView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewMomentBloc>(
      builder: (context, bloc, child) => SizedBox(
        width: double.infinity,
        height: (bloc.choseFile == null &&
                (bloc.fileUrl == null && (bloc.fileUrl?.isEmpty ?? true)))
            ? 0
            : 300,
        child: Stack(
          children: [
            Positioned.fill(
              child: (bloc.choseFile == null)
                  ? Container(
                      child: (bloc.isEditMode)
                          ? MediaView(
                              isVideo: bloc.isFileTypeVideo ?? false,
                              mediaUrl: bloc.fileUrl,
                            )
                          : Container(),
                    )
                  : SizedBox(
                      height: 300,
                      width: double.infinity,
                      child: Center(
                        child: MediaView(
                          isVideo: bloc.isFileTypeVideo ?? false,
                          mediaFile: bloc.choseFile,
                        ),
                      ),
                    ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Visibility(
                visible: bloc.choseFile != null ||
                    (bloc.fileUrl?.isNotEmpty ?? false),
                child: GestureDetector(
                  onTap: () {
                    bloc.onTapDeleteImage();
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: kMarginSmall),
                    child: Icon(
                      MdiIcons.delete,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PostDescriptionErrorView extends StatelessWidget {
  const PostDescriptionErrorView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewMomentBloc>(
      builder: (context, bloc, child) => Visibility(
        visible: bloc.isEmptyDescriptionError,
        child: const Text(
          "Post should not be empty",
          style: TextStyle(
            color: Colors.red,
            fontSize: kTextRegular,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class HorizontalIconAndLabelView extends StatelessWidget {
  final Widget icon;
  final String text;
  const HorizontalIconAndLabelView({
    Key? key,
    required this.icon,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: kHorizontalIconAndLabelViewHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: kMarginMedium2,
      ),
      decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(width: 0.5, color: Colors.black54))),
      child: Row(
        children: [
          icon,
          const SizedBox(
            width: kMarginMedium,
          ),
          Text(text)
        ],
      ),
    );
  }
}

class AddNewMomentTextFieldView extends StatelessWidget {
  const AddNewMomentTextFieldView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewMomentBloc>(
      builder: (context, bloc, child) => Container(
        padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
        height: kAddNewMomentTextFieldHeight,
        child: TextField(
          maxLines: 50,
          controller: TextEditingController(text: bloc.momentDescription),
          onChanged: (text) {
            bloc.onTextChanged(text);
          },
          onTap: () {
            bloc.onFocusTextField();
          },
          decoration: const InputDecoration(
            hintText: "What's on your mind?",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

class UserProfileAndNameView extends StatelessWidget {
  const UserProfileAndNameView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddNewMomentBloc>(
      builder: (context, bloc, child) => Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(bloc.profilePicUrl),
          ),
          const SizedBox(
            width: kMarginMedium,
          ),
          Padding(
            padding: const EdgeInsets.only(top: kMarginMedium),
            child: Text(
              bloc.userName,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
