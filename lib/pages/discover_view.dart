import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wechat_redesign/bloc/discover_bloc.dart';
import 'package:wechat_redesign/data/vos/moment_vo.dart';
import 'package:wechat_redesign/pages/add_moment_page.dart';
import 'package:wechat_redesign/resources/colors.dart';
import 'package:wechat_redesign/resources/dimens.dart';
import 'package:wechat_redesign/resources/strings.dart';
import 'package:wechat_redesign/viewitems/custom_appbar_view.dart';
import 'package:wechat_redesign/viewitems/media_view.dart';
import 'package:wechat_redesign/viewitems/moment_action_view.dart';
import 'package:wechat_redesign/viewitems/moment_item_view.dart';
import 'package:wechat_redesign/widgets/no_data_placeholder_view.dart';
import 'package:wechat_redesign/widgets/space_for_app_bar.dart';

class DiscoverView extends StatelessWidget {
  const DiscoverView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DiscoverBloc(),
      child: Consumer<DiscoverBloc>(
        builder: (context, bloc, child) => Stack(
          children: [
            Positioned.fill(
              child: Column(
                children: [
                  const SpaceForAppBar(),
                  Expanded(
                    child: (bloc.momentList == null)
                        ? const Center(
                            child: CircularProgressIndicator(
                                color: kPrimaryGreenColor),
                          )
                        : (bloc.momentList?.isEmpty ?? true)
                            ? const Center(
                                child: NoDataPlaceHolder(
                                imagePath: 'assets/images/sorry.png',
                                text: kLblPlaceHolderForDiscoverView,
                              ))
                            : ListView.builder(
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: bloc.momentList?.length ?? 0,
                                itemBuilder: (context, index) => MomentItemView(
                                  moment: bloc.momentList?[index] ?? MomentVO(),
                                  onTapEdit: (id) {
                                    Future.delayed(
                                            const Duration(milliseconds: 1000))
                                        .then((value) {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => AddMomentPage(
                                            editMomentId:
                                                bloc.momentList?[index] ??
                                                    MomentVO(),
                                          ),
                                        ),
                                      );
                                    });
                                  },
                                  onTapDelete: (id) {
                                    bloc.onTapPostDelete(id);
                                  },
                                  onAddComment: (id) {
                                    bloc.onTapAddComment(id);
                                  },
                                  onTapMomentDetails: () {
                                    bloc.onTapMomentDetails(
                                        bloc.momentList?[index] ?? MomentVO());
                                  },
                                ),
                              ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: CustomAppBarView(
                //leading: Icon(MdiIcons.abTesting),
                title: kLblMoments,
                action: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const AddMomentPage()));
                  },
                  child: const Icon(
                    MdiIcons.plus,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Positioned.fill(
              child: AddCommentSection(),
            ),
            const Positioned.fill(child: MomentDetailsView())
          ],
        ),
      ),
    );
  }
}

class MomentDetailsView extends StatelessWidget {
  const MomentDetailsView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DiscoverBloc>(
      builder: (context, bloc, child) => Visibility(
        visible: bloc.isMomentDetailsShow,
        child: Container(
          color: kBlackHoverColor,
          padding: const EdgeInsets.symmetric(horizontal: kMarginMedium2),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: kMarginXXLarge,
                  ),
                  Text(
                    bloc.choseMomentToShowDetails?.userName ?? '',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: kMarginMedium2,
                  ),
                  Text(
                    bloc.choseMomentToShowDetails?.description ?? '',
                    style: const TextStyle(
                        color: Colors.white54, fontSize: kTextRegular),
                  ),
                  const SizedBox(
                    height: kMarginMedium2,
                  ),
                  SizedBox(
                    // height: (bloc.choseMomentToShowDetails?.postImageUrl
                    //             ?.isNotEmpty ??
                    //         false)
                    //     ? 300
                    //     : null,
                    width: double.infinity,
                    child: MediaView(
                      isVideo: bloc.choseMomentToShowDetails?.isFileTypeVideo ??
                          false,
                      mediaUrl: bloc.choseMomentToShowDetails?.postImageUrl,
                    ),
                  ),
                  const SizedBox(
                    height: kMarginMedium2,
                  ),
                  MomentActionView(
                    isUserPost: true,
                    isHover: true,
                    onTapEdit: (id) {
                      Future.delayed(const Duration(milliseconds: 1000))
                          .then((value) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddMomentPage(
                              editMomentId: id,
                            ),
                          ),
                        );
                      });
                    },
                    onTapDelete: (id) {
                      bloc.onTapPostDelete(id);
                    },
                  ),
                  Center(
                    child: IconButton(
                      onPressed: () {
                        bloc.onTapCloseMomentDetails();
                      },
                      icon: const Icon(
                        MdiIcons.chevronDown,
                        color: Colors.grey,
                        size: 50,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AddCommentSection extends StatelessWidget {
  const AddCommentSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DiscoverBloc>(
      builder: (context, bloc, child) => Visibility(
        visible: bloc.isAddCommentShow,
        child: Container(
          color: kBlackHoverColor,
          padding: const EdgeInsets.only(
              left: kMarginXXLarge,
              right: kMarginMedium2,
              bottom: kMarginMedium3),
          child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: kMarginXLarge),
                  child: GestureDetector(
                    onTap: () {
                      bloc.onTapCommentSectionClose();
                    },
                    child: const Icon(
                      Icons.chevron_right,
                      color: kPrimaryGreenColor,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: kPrimaryGreenColor),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text(
                          'Phone Min Myat',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: kTextSmall2),
                        ),
                        SizedBox(
                          width: kMarginMedium,
                        ),
                        Expanded(
                          child: TextField(
                            maxLines: 2,
                            style: TextStyle(
                                color: Colors.white60, fontSize: kTextSmall),
                            cursorColor: kPrimaryGreenColor,
                            cursorHeight: 20,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.emoji_emotions,
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
