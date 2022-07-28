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
  UserBuS user;
  int selectedIndex;
  ContainerAdmin(this.company, this.user, this.selectedIndex);

  @override
  State<ContainerAdmin> createState() =>
      _ContainerAdminState(company, user, selectedIndex);
}

class _ContainerAdminState extends State<ContainerAdmin> {
  UserBuS user;
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
            actions: [HomeButton(context, user, company)],
            foregroundColor: whiteMode.textColor,
            backgroundColor: whiteMode.cardColor),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: whiteMode.backgroundColor),
          child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: _pages[selectedIndex]),
        ),
        drawer: AdminMenu(company, user));
  }
}
