import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/messages_user.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/show_stats/stats_main.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/timer_main.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/user_menu.dart';
import 'package:itm_ichtrinkmehr_flutter/common_actions/home_button.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';

import '../common_actions/settings.dart';

WhiteMode whiteMode = WhiteMode();

class ContainerUser extends StatefulWidget {
  final UserBuS user;
  final Company company;
  final int selectedIndex;

  const ContainerUser(this.user, this.company, this.selectedIndex);

  @override
  State<ContainerUser> createState() =>
      _ContainerUserState(user, company, selectedIndex);
}

class _ContainerUserState extends State<ContainerUser> {
  UserBuS user = UserBuS.empty();
  int selectedIndex;
  Company company;

  _ContainerUserState(this.user, this.company, this.selectedIndex);

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
      Timer_main(user, company),
      Stats_main(user, company),
      MessagesUser(company, user),
      Settings(user, company),
    ];

    return Scaffold(
      appBar: AppBar(
          actions: [HomeButton(context, user, company)],
          foregroundColor: Theme.of(context).textSelectionTheme.selectionColor!,
          backgroundColor: Theme.of(context).cardColor),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
        child: Container(
          child: _pages[selectedIndex],
        ),
      ),
      drawer: UserMenu(
        company,
        user,
      ),
    );
  }
}
