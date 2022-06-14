import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:wechat_redesign/bloc/discover_bloc.dart';
import 'package:wechat_redesign/data/vos/moment_vo.dart';
import 'package:wechat_redesign/pages/add_moment_page.dart';
import 'package:wechat_redesign/resources/strings.dart';
import 'package:wechat_redesign/viewitems/custom_appbar_view.dart';
import 'package:wechat_redesign/viewitems/moment_item_view.dart';
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
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: bloc.momentList?.length ?? 0,
                    itemBuilder: (context, index) => MomentItemView(
                      moment: bloc.momentList?[index] ?? MomentVO(),
                      onTapEdit: (id) {
                        Future.delayed(const Duration(milliseconds: 1000))
                            .then((value) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddMomentPage(
                                    editMomentId: id,
                                  )));
                        });
                      },
                      onTapDelete: (id) {
                        bloc.onTapPostDelete(id);
                      },
                      onAddComment: (id) {
                        //TODO
                      },
                    ),
                  ),
                ),
              ],
            )),
            Align(
              alignment: Alignment.topCenter,
              child: CustomAppBarView(
                //leading: Icon(MdiIcons.abTesting),
                title: kLblMoments,
                action: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AddMomentPage()));
                  },
                  child: const Icon(
                    MdiIcons.plus,
                    color: Colors.white,
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
