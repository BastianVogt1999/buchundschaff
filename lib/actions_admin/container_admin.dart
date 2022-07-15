import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_admin/admin_menu.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_admin/send_messages.dart';
import 'package:itm_ichtrinkmehr_flutter/common_actions/home_button.dart';
import 'package:itm_ichtrinkmehr_flutter/intro/unternehmens_eingabe.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';

import 'UserManagement/manage_user.dart';
import 'day_stats_admin.dart';
import 'full_stats_admin.dart';

WhiteMode whiteMode = WhiteMode();
class ContainerAdmin extends StatefulWidget {
  Company company;
  User user;
  int selectedIndex;
  ContainerAdmin(this.company, this.user, this.selectedIndex);

  @override
  State<ContainerAdmin> createState() =>
      _ContainerAdminState(company, user, selectedIndex);
}



class _ContainerAdminState extends State<ContainerAdmin> {
  
  User user;
  Company company;
  int selectedIndex;
  _ContainerAdminState(this.company, this.user, this.selectedIndex);





  onItemTapped(int index) {
    setState(
      () {
        selectedIndex = index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List _pages = [
  DayStatsAdmin(),
  FullStatsAdmin(user, company),
  UserManagement(company),
  SendMessages(company, user),
];

  return Scaffold(
      appBar: AppBar(
        foregroundColor: whiteMode.textColor,
        title: Text(user.user_name, style: TextStyle(color: whiteMode.textColor)),
        backgroundColor: whiteMode.cardColor
  
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
      color: whiteMode.backgroundColor
        ),
        child:  Column(children: [
            SizedBox(height: 650, child: _pages[selectedIndex]),
            Container(
              height: 50,
              alignment: Alignment.bottomRight,
              child: HomeButton(context, user, company),
            ),
          ]),
        ),
        drawer: AdminMenu(company, user));
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
