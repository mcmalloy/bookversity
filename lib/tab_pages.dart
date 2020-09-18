import 'package:bookversity/Constants/custom_colors.dart';
import 'package:bookversity/TabPages/profile_dashboard.dart';
import 'package:bookversity/TabPages/profile_page.dart';
import 'TabPages/chat_list_page.dart';
import 'TabPages/item_list_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TabPages extends StatefulWidget {
  @override
  _TabPagesState createState() => _TabPagesState();
}

class _TabPagesState extends State<TabPages> {
  int _selectedIndex = 0;

  void onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: menu(),
        body: TabBarView(
          children: [
            //ProfilePage(),
            ProfileDashBoard(),
            ItemList(),
            ChatList()
          ],
        ),
      ),
    );
  }

  Widget menu() {
    return TabBar(
      tabs: [
        Tab(
          icon: Icon(
            FontAwesomeIcons.user,
            color: CustomColors.materialDarkGreen,
          ),
        ),
        Tab(
          icon: Icon(
              Icons.dashboard,
              color: CustomColors.materialDarkGreen),
        ),
        Tab(
          icon: Icon(
              FontAwesomeIcons.facebookMessenger,
              color: CustomColors.materialDarkGreen),
        ),
      ],
    );
  }
}
