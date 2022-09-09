import 'dart:async';

import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_admin/container_admin.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_admin/send_messages.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/container_user.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/messages_user.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/show_stats/pick_user.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/show_stats/stats_main.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/show_stats/stats_user_switcher.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/timer_main.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';

WhiteMode whiteMode = WhiteMode();

class UserMenu extends StatefulWidget {
  UserMenu(this.company);

  Company company;

  @override
  State<UserMenu> createState() => UserMenuState(company);
}

class UserMenuState extends State<UserMenu> {
  UserMenuState(this.company);

  Company company;

  onItemTapped(int index) {
    setState(
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ContainerUser(company, index)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List _pages = [
      Timer_main(company),
      //DayStats(),
      StateUserSwitcher(company),
      MessagesUser(company),
    ];

    return Drawer(
      child: Material(
        color: Theme.of(context).backgroundColor,
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const SizedBox(height: 12),
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
                  Divider(
                      color:
                          Theme.of(context).textSelectionTheme.selectionColor!),
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
                  Divider(
                      color:
                          Theme.of(context).textSelectionTheme.selectionColor!),
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
    return ListTile(
      leading: Icon(icon,
          color: Theme.of(context).textSelectionTheme.selectionColor!),
      title: Text(text,
          style: TextStyle(
              color: Theme.of(context).textSelectionTheme.selectionColor!)),
      hoverColor: Theme.of(context).textSelectionTheme.selectionColor!,
      onTap: onClicked,
    );
  }
}
