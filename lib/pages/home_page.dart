import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:wechat_redesign/pages/contacts_view.dart';
import 'package:wechat_redesign/pages/discover_view.dart';
import 'package:wechat_redesign/pages/wechat_message_list_view.dart';
import 'package:wechat_redesign/pages/profile_view.dart';
import 'package:wechat_redesign/resources/colors.dart';

enum PageName {
  weChatMessageView,
  contactsView,
  discoverView,
  profileView,
}

class HomePage extends StatefulWidget {
  final PageName? sentPage;
  const HomePage({Key? key, this.sentPage}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  

  int pageIndex = 0;
  List<Widget> pageList = [
    const WeChatMessageView(),
    const ContactsView(),
    const DiscoverView(),
    const ProfileView()
  ];

  @override
  void initState() {
    if(widget.sentPage != null){
      pageIndex = widget.sentPage?.index ?? 0;
    }
    super.initState();
  }

  void onTapBottomNavigationBarItem(int tapIndex) {
    setState(() {
      pageIndex = tapIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: pageList[pageIndex]),
      bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.grey[200],
          currentIndex: pageIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (newIndex) {
            onTapBottomNavigationBarItem(newIndex);
          },
          selectedItemColor: kPrimaryGreenColor,
          unselectedItemColor: Colors.black26,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(
                  MdiIcons.messageOutline,
                ),
                label: 'WeChat'),
            BottomNavigationBarItem(
                icon: Icon(
                  MdiIcons.contactsOutline,
                ),
                label: 'Contacts'),
            BottomNavigationBarItem(
                icon: Icon(
                  MdiIcons.compass,
                ),
                label: 'Discover'),
            BottomNavigationBarItem(
                icon: Icon(
                  MdiIcons.faceMan,
                ),
                label: 'Me'),
          ]),
    );
  }
}
