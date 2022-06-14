import 'package:flutter/material.dart';
import 'package:wechat_redesign/resources/dimens.dart';

class MomentActionView extends StatelessWidget {
  final bool isUserPost;
  final Function onTapEdit;
  final Function onTapDelete;
  final bool isHover;
  const MomentActionView({
    required this.isUserPost,
    Key? key,
    required this.onTapEdit,
    required this.onTapDelete,
    this.isHover = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: kMarginMedium2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Icon(
            Icons.favorite,
            color: Colors.red,
          ),
          const SizedBox(
            width: kMarginMedium,
          ),
          Icon(
            Icons.message_outlined,
            color: (isHover) ? Colors.white30 : Colors.black,
          ),
          (isUserPost)
              ? MoreButtonView(
                  onTapEdit: () {
                    onTapEdit();
                  },
                  onTapDelete: () {
                    onTapDelete();
                  },
                  isHover: isHover,
                )
              : Container(),
        ],
      ),
    );
  }
}

class MoreButtonView extends StatelessWidget {
  final Function onTapEdit;
  final Function onTapDelete;
  final bool isHover;
  const MoreButtonView(
      {Key? key, required this.onTapEdit, required this.onTapDelete, required this.isHover})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      icon: Icon(
        Icons.more_horiz_rounded,
        color: (isHover) ? Colors.white30 : Colors.black,
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            onTapEdit();
          },
          value: 1,
          child: const Text("Edit"),
        ),
        PopupMenuItem(
          onTap: () {
            onTapDelete();
          },
          value: 2,
          child: const Text("Delete"),
        )
      ],
    );
  }
}
