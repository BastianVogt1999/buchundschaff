import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_admin/admin_menu.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_admin/rebase_stats.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_admin/send_messages.dart';
import 'package:itm_ichtrinkmehr_flutter/common_actions/home_button.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';

import '../common_actions/settings.dart';
import 'all_user.dart';

import 'running_projects.dart';
import 'full_stats_admin.dart';

WhiteMode whiteMode = WhiteMode();

class ContainerAdmin extends StatefulWidget {
  Company company;

  int selectedIndex;
  ContainerAdmin(this.company, this.selectedIndex, {Key? key})
      : super(key: key);

  @override
  State<ContainerAdmin> createState() =>
      _ContainerAdminState(company, selectedIndex);
}

class _ContainerAdminState extends State<ContainerAdmin> {
  Company company;
  int selectedIndex;
  _ContainerAdminState(this.company, this.selectedIndex);

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
      RunningProjects(company),
      FullStatsAdmin(company),
      allUser(company),
      RebaseStats(company),
      SendMessages(company),
      Settings(company)
    ];

    return Scaffold(
        appBar: AppBar(
            actions: [HomeButton(context, company)],
            foregroundColor:
                Theme.of(context).textSelectionTheme.selectionColor!,
            backgroundColor: Theme.of(context).cardColor),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
          child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: _pages[selectedIndex]),
        ),
        drawer: AdminMenu(company));
  }
}
