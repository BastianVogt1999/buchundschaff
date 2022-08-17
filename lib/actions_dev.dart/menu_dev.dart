import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_dev.dart/clear_stats.dart';
import 'package:itm_ichtrinkmehr_flutter/intro/unternehmens_eingabe.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';

WhiteMode whiteMode = WhiteMode();

class DevMenu extends StatefulWidget {
  const DevMenu();

  @override
  State<DevMenu> createState() => DevMenuState();
}

class DevMenuState extends State<DevMenu> {
  DevMenuState();

  onItemTapped(int index) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPage())),
        backgroundColor: whiteMode.abstractColor,
        label: const Text("Zurück zu Home"),
        icon: const Icon(Icons.home_filled),
      ),
      body: Material(
        color: whiteMode.backgroundColor,
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  ListTile(
                    leading:
                        Icon(Icons.delete_forever, color: whiteMode.textColor),
                    title: Text("Firma löschen",
                        style: TextStyle(color: whiteMode.textColor)),
                    hoverColor: whiteMode.abstractColor,
                  ),
                  Divider(color: whiteMode.textColor),
                  ListTile(
                    leading: Icon(Icons.dataset_linked_sharp,
                        color: whiteMode.textColor),
                    title: Text("Daten zurückgeben",
                        style: TextStyle(color: whiteMode.textColor)),
                    hoverColor: whiteMode.abstractColor,
                  ),
                  ListTile(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ClearStat())),
                    leading: Icon(Icons.star_outline_sharp,
                        color: whiteMode.textColor),
                    title: Text("Stats clearen",
                        style: TextStyle(color: whiteMode.textColor)),
                    hoverColor: whiteMode.abstractColor,
                  ),
                  Divider(color: whiteMode.textColor),
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

  const MenuItem({
    required this.text,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: whiteMode.textColor),
      title: Text(text, style: TextStyle(color: whiteMode.textColor)),
      hoverColor: whiteMode.abstractColor,
    );
  }
}
