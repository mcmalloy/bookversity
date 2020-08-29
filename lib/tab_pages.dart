import 'package:bookversity/Constants/custom_colors.dart';
import 'TabPages/chat_list.dart';
import 'TabPages/item_list.dart';
import 'file:///C:/Users/markm/AndroidStudioProjects/bookversity/lib/TabPages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TabPages extends StatefulWidget {
  @override
  _TabPagesState createState() => _TabPagesState();
}

class _TabPagesState extends State<TabPages> {
  int _selectedIndex = 0;
  static List<Widget> _focusedPage = <Widget>[ProfilePage(), ItemList(), ChatList()];

  void onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _focusedPage[_selectedIndex],
      backgroundColor: CustomColors.materialLightGreen,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: CustomColors.materialDarkGreen,
        onTap: onTabTapped,
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.user,
                color: CustomColors.materialYellow,
              ),
              title: Text("")),
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard, color: CustomColors.materialYellow),
              title: Text("")),
          BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.facebookMessenger,
                  color: CustomColors.materialYellow),
              title: Text("")),
        ],
      ),
    );
  }
}
