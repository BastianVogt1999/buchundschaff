import 'dart:async';

import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/day_stats.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/messages_user.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/show_stats/stats_main.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/timer_main.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/user_menu.dart';
import 'package:itm_ichtrinkmehr_flutter/common_actions/home_button.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';

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
