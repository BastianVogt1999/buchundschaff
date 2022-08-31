import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_admin/container_admin.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';

import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';

WhiteMode whiteMode = WhiteMode();

class AdminMenu extends StatefulWidget {
  final Company company;

  const AdminMenu(this.company, {Key? key}) : super(key: key);

  @override
  State<AdminMenu> createState() => _nameState(company);
}

class _nameState extends State<AdminMenu> {
  Company company;

  _nameState(this.company);

  onItemTapped(int index) {
    setState(() {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ContainerAdmin(company, index)));
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    text: 'Laufende Projekte',
                    icon: Icons.workspaces,
                    onClicked: () => onItemTapped(0),
                  ),
                  const SizedBox(height: 5),
                  MenuItem(
                    text: 'Gesamtstatistik',
                    icon: Icons.timeline,
                    onClicked: () => onItemTapped(1),
                  ),
                  const SizedBox(height: 5),
                  MenuItem(
                    text: 'User verwalten',
                    icon: Icons.supervised_user_circle,
                    onClicked: () => onItemTapped(2),
                  ),
                  const SizedBox(height: 5),
                  MenuItem(
                    text: 'Statistiken auslesen',
                    icon: Icons.table_chart,
                    onClicked: () => onItemTapped(3),
                  ),
                  const SizedBox(height: 8),
                  Divider(
                      color:
                          Theme.of(context).textSelectionTheme.selectionColor!),
                  const SizedBox(height: 8),
                  MenuItem(
                    text: 'Nachricht versenden',
                    icon: Icons.notification_add,
                    onClicked: () => onItemTapped(4),
                  ),
                  const SizedBox(height: 8),
                  MenuItem(
                    text: 'Einstellungen',
                    icon: Icons.settings,
                    onClicked: () => onItemTapped(5),
                  ),
                  Divider(
                      color:
                          Theme.of(context).textSelectionTheme.selectionColor!),
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
    return ListTile(
      leading: Icon(icon,
          color: Theme.of(context).textSelectionTheme.selectionColor!),
      title: Text(text,
          style: TextStyle(
              color: Theme.of(context).textSelectionTheme.selectionColor!)),
      hoverColor: Theme.of(context).colorScheme.secondary,
      onTap: onClicked,
    );
  }
}
