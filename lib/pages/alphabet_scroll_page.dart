import 'package:azlistview/azlistview.dart';
import 'package:flutter/material.dart';
import 'package:wechat_redesign/pages/qr_scan_page.dart';
import 'package:wechat_redesign/resources/colors.dart';
import 'package:wechat_redesign/resources/dimens.dart';

class _AZItem extends ISuspensionBean {
  final String title;
  final String tag;
  _AZItem({
    required this.title,
    required this.tag,
  });

  @override
  String getSuspensionTag() {
    return tag;
  }
}

class AlphabetScrollPage extends StatefulWidget {
  const AlphabetScrollPage({Key? key}) : super(key: key);

  @override
  State<AlphabetScrollPage> createState() => _AlphabetScrollPageState();
}

class _AlphabetScrollPageState extends State<AlphabetScrollPage> {
  List<String> items = [
    "Afghanistan",
    "Albania",
    "Algeria",
    "American Samoa",
    "Belize",
    "Benin",
    "Bermuda",
    "Bhutan",
    "Albania",
    "Algeria",
    "Bolivia",
    "Bosnia and Herzegowina",
    "Botswana",
    "Bouvet Island",
    "Brazil",
    "British Indian Ocean Territory",
    "Brunei Darussalam",
  ];

  List<_AZItem> azItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initList(items);
  }

  void initList(List<String> items) {
    setState(() {
      azItems = items
          .map((item) => _AZItem(title: item, tag: item[0].toUpperCase()))
          .toList();

      SuspensionUtil.sortListBySuspensionTag(azItems);
      SuspensionUtil.setShowSuspensionStatus(azItems);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AzListView(
        data: azItems,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: (){
              showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(kMarginMedium3),
                          ),
                          elevation: 0,
                          backgroundColor: kBlackHoverColor,
                          child: ContentBox(),
                        );
                      });
            },
            child: ListItemView(
              item: azItems[index],
            ),
          );
        },
        indexBarData: SuspensionUtil.getTagIndexList(azItems),
        indexHintBuilder: (context, hint) => Container(
          width: 50,
          height: 50,
          alignment: Alignment.center,
          color: kPrimaryGreenColor,
          child: Text(hint),
        ),
      ),
    );
  }
}

class ListItemView extends StatelessWidget {
  final _AZItem item;

  const ListItemView({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final offStage = !item.isShowSuspension;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Offstage(
          offstage: offStage,
          child: Container(
            height: 40,
            alignment: Alignment.centerLeft,
            child: Text(item.getSuspensionTag()),
          ),
        ),
        Container(
          height: 50,
          child: Text(item.title),
        ),
      ],
    );
  }
}
