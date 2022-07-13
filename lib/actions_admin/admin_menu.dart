import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_admin/container_admin.dart';

import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';

class AdminMenu extends StatefulWidget {
  AdminMenu(this.company, this.user);
  Company company;
  User user;
  @override
  State<AdminMenu> createState() => _nameState(company, user);
}

class _nameState extends State<AdminMenu> {
  _nameState(this.company, this.user);
  Company company;
  User user;

  onItemTapped(int index) {
    setState(
      () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ContainerAdmin(company, user, index)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    text: 'Tagesstatistik ausgewählter User',
                    icon: Icons.query_stats,
                    onClicked: () => onItemTapped(0),
                  ),
                  const SizedBox(height: 5),
                  MenuItem(
                    text: 'Gesamtstatistik',
                    icon: Icons.timeline,
                    onClicked: () => onItemTapped(1),
                  ),
                  /* const SizedBox(height: 5),
                    MenuItem(
                      text: 'Chat',
                      icon: Icons.chat_bubble,
                      onClicked: () => onItemTapped(2),
                    ),*/
                  const SizedBox(height: 5),
                  MenuItem(
                    text: 'User verwalten',
                    icon: Icons.supervised_user_circle,
                    onClicked: () => onItemTapped(2),
                  ),
                  const SizedBox(height: 8),
                  Divider(color: Colors.white70),
                       const SizedBox(height: 8),
                  MenuItem(
                    text: 'Nachricht versenden',
                    icon: Icons.notification_add,
                    onClicked: () => onItemTapped(3),
                  ),
                  const SizedBox(height: 8),
                  MenuItem(
                    text: 'Benachrichtigungen',
                    icon: Icons.notifications_outlined,
                    onClicked: () => onItemTapped(4),
                  ),
                  MenuItem(
                    text: 'Einstellungen',
                    icon: Icons.settings,
                    onClicked: () => onItemTapped(5),
                  ),
                  Divider(color: Colors.white70),
                  const SizedBox(height: 8),
                  MenuItem(
                    text: 'Über uns',
                    icon: Icons.info,
                    onClicked: () => onItemTapped(6),
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
