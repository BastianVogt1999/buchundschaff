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
        backgroundColor: Theme.of(context).colorScheme.secondary,
        label: const Text("Zurück zu Home"),
        icon: const Icon(Icons.home_filled),
      ),
      body: Material(
        color: Theme.of(context).backgroundColor,
        child: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  ListTile(
                    leading: Icon(Icons.delete_forever,
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionColor!),
                    title: Text("Firma löschen",
                        style: TextStyle(
                            color: Theme.of(context)
                                .textSelectionTheme
                                .selectionColor!)),
                    hoverColor: Theme.of(context).colorScheme.secondary,
                  ),
                  Divider(
                      color:
                          Theme.of(context).textSelectionTheme.selectionColor!),
                  ListTile(
                    leading: Icon(Icons.dataset_linked_sharp,
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionColor!),
                    title: Text("Daten zurückgeben",
                        style: TextStyle(
                            color: Theme.of(context)
                                .textSelectionTheme
                                .selectionColor!)),
                    hoverColor: Theme.of(context).colorScheme.secondary,
                  ),
                  ListTile(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ClearStat())),
                    leading: Icon(Icons.star_outline_sharp,
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionColor!),
                    title: Text("Stats clearen",
                        style: TextStyle(
                            color: Theme.of(context)
                                .textSelectionTheme
                                .selectionColor!)),
                    hoverColor: Theme.of(context).colorScheme.secondary,
                  ),
                  Divider(
                      color:
                          Theme.of(context).textSelectionTheme.selectionColor!),
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
      leading: Icon(icon,
          color: Theme.of(context).textSelectionTheme.selectionColor!),
      title: Text(text,
          style: TextStyle(
              color: Theme.of(context).textSelectionTheme.selectionColor!)),
      hoverColor: Theme.of(context).colorScheme.secondary,
    );
  }
}
