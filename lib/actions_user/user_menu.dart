import 'dart:async';

import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_admin/container_admin.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_admin/send_messages.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/container_user.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/messages_user.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/show_stats/stats_main.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/timer_main.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';

class UserMenu extends StatefulWidget {
  UserMenu(this.company, this.user);


  Company company;
  User user;
  @override
  State<UserMenu> createState() => UserMenuState(company, user);
}

class UserMenuState extends State<UserMenu> {
  UserMenuState(this.company, this.user);

  Company company;
  User user;

  onItemTapped(int index) {
    setState(
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ContainerUser(user, company, index)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List _pages = [
      Timer_main(user, company),
      //DayStats(),
      Stats_main(user, company),
      MessagesUser(company, user),
   
    ];

    return Drawer(
      child: Material(
        color: Color(0xff4338CA),
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  SearchFieldDrawer(),
                  const SizedBox(height: 12),
                  MenuItem(
                    text: 'Timer starten',
                    icon: Icons.timer,
                    onClicked: () => onItemTapped(0),
                  ),
                  const SizedBox(height: 5),
                  MenuItem(
                    text: 'Tagesstatistik',
                    icon: Icons.timeline,
                    onClicked: () => onItemTapped(1),
                  ),

                  /* const SizedBox(height: 5),
                    MenuItem(
                      text: 'Chat',
                      icon: Icons.chat_bubble,
                      onClicked: () => onItemTapped(2),
                    ),*/
                  const SizedBox(height: 8),
                  Divider(color: Colors.white70),
                  const SizedBox(height: 8),
                  MenuItem(
                    text: 'Benachrichtigungen',
                    icon: Icons.notifications_outlined,
                    onClicked: () => onItemTapped(2),
                  ),
                  MenuItem(
                    text: 'Einstellungen',
                    icon: Icons.settings,
                    onClicked: () => onItemTapped(3),
                  ),
                  Divider(color: Colors.white70),
                  const SizedBox(height: 8),
                  MenuItem(
                    text: 'Über uns',
                    icon: Icons.info,
                    onClicked: () => onItemTapped(5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onClicked;

  const MenuItem({
    required this.text,
    required this.icon,
    required this.onClicked,
  });

  @override
  Widget build(BuildContext context) {
    const color = Colors.white;
    const hoverColor = Colors.white70;

    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(text, style: TextStyle(color: color)),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }
}

class SearchFieldDrawer extends StatelessWidget {
  const SearchFieldDrawer();

  @override
  Widget build(BuildContext context) {
    const color = Colors.white;

    return TextField(
      style: TextStyle(color: color, fontSize: 14),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        hintText: 'Search',
        hintStyle: TextStyle(color: color),
        prefixIcon: Icon(
          Icons.search,
          color: color,
          size: 20,
        ),
        filled: true,
        fillColor: Colors.white12,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: color.withOpacity(0.7)),
        ),
      ),
    );
  }
}
