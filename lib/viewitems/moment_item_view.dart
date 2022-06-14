
import 'package:flutter/material.dart';
import 'package:wechat_redesign/data/vos/moment_vo.dart';
import 'package:wechat_redesign/resources/dimens.dart';
import 'package:wechat_redesign/resources/text_styles.dart';
import 'package:wechat_redesign/viewitems/media_view.dart';

import 'moment_action_view.dart';

class MomentItemView extends StatelessWidget {
  final MomentVO moment;
  final Function(int) onTapEdit;
  final Function(int) onTapDelete;
  final Function(int) onAddComment;
  final Function onTapMomentDetails;
  const MomentItemView({
    Key? key,
    required this.moment,
    required this.onTapEdit,
    required this.onTapDelete,
    required this.onAddComment,
    required this.onTapMomentDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          UserProfileAndNameView(
            profileUrl: moment.profilePicUrl ?? '',
            userName: moment.userName ?? '',
          ),
          GestureDetector(
            onTap: () {
              onTapMomentDetails();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CaptionView(
                  caption: moment.description ?? '',
                ),
                const SizedBox(height: kMarginMedium),
                MomentMediaView(moment: moment),
              ],
            ),
          ),
          const SizedBox(height: kMarginMedium),
          MomentActionView(
            isUserPost: moment.isUserMoment ?? false,
            onTapEdit: () {
              onTapEdit(moment.id ?? 0);
            },
            onTapDelete: () {
              onTapDelete(moment.id ?? 0);
            },
          ),
          const SizedBox(height: kMarginMedium),
          Column(
            children: [
              const GreyLineSeparator(),
              LikeViewAndCommentSectionView(
                onAddComment: () {
                  onAddComment(moment.id ?? 0);
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}

class MomentMediaView extends StatelessWidget {
  const MomentMediaView({
    Key? key,
    required this.moment,
  }) : super(key: key);

  final MomentVO moment;

  @override
  Widget build(BuildContext context) {
    return (moment.postImageUrl?.isNotEmpty ?? false)
        ? Container(
            width: double.infinity,
            height: kMomentMediaHeight,
            margin: const EdgeInsets.symmetric(vertical: kMarginMedium2),
            padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
            child: MediaView(
              isVideo: moment.isFileTypeVideo ?? false,
              mediaUrl: moment.postImageUrl,
             
            ),
          )
        : Container();
  }
}

class LikeViewAndCommentSectionView extends StatelessWidget {
  final Function onAddComment;
  const LikeViewAndCommentSectionView({
    required this.onAddComment,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onAddComment();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
            left: kMarginXXLarge,
            right: kMarginMedium2,
            top: kMarginMedium,
            bottom: kMarginMedium2),
        color: Colors.grey[200],
        child: Column(children: [
          Row(
            children: const [
              Icon(
                Icons.favorite,
                color: Colors.black87,
                size: 15,
              ),
              SizedBox(
                width: kMarginMedium,
              ),
              Text(
                'Nuno Rocha,Amie Deane, Alan Lu',
                style: TextStyle(color: Colors.black87),
              )
            ],
          ),
          Row(
            children: const [
              Icon(
                Icons.message,
                color: Colors.black87,
                size: 15,
              ),
              SizedBox(
                width: kMarginMedium,
              ),
              CommentView(),
            ],
          ),
        ]),
      ),
    );
  }
}

class CommentView extends StatelessWidget {
  const CommentView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Nuno Rocha',
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        Text(
          'I have read all his books',
          style: kMomentRegularTextStyle,
        )
      ],
    );
  }
}

class GreyLineSeparator extends StatelessWidget {
  const GreyLineSeparator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: kMarginSmall,
      color: Colors.grey,
    );
  }
}





class CaptionView extends StatelessWidget {
  final String caption;
  const CaptionView({
    Key? key,
    required this.caption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(left: kMarginXXLarge, right: kMarginMedium2),
      child: Text(
        caption,
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
        style: kMomentRegularTextStyle,
      ),
    );
  }
}

class UserProfileAndNameView extends StatelessWidget {
  final String profileUrl;
  final String userName;
  const UserProfileAndNameView({
    Key? key,
    required this.profileUrl,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Stack(children: [
        Positioned.fill(
          child: Container(
            color: Colors.grey[200],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            height: 40,
            color: Colors.white,
          ),
        ),
        const Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: kMarginMedium2, vertical: kMarginMedium3),
            child: Text(
              '3 mins ago',
              style: kMomentRegularTextStyle,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: kMarginMedium2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(profileUrl),
                ),
                const SizedBox(
                  width: kMarginMedium2,
                ),
                Text(
                  userName,
                  style: const TextStyle(
                      fontSize: kTextRegular3x, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
