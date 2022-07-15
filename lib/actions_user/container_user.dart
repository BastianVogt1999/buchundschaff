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
  final User user;
  final Company company;
  final int selectedIndex;
  


   ContainerUser(this.user, this.company, this.selectedIndex);

  @override
  State<ContainerUser> createState() =>
      _ContainerUserState(user, company, selectedIndex);
}

class _ContainerUserState extends State<ContainerUser> {

  User user = User.empty();
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
        child: Column(children: [
          SizedBox(
            height: 650,
            child: Container(
              child: _pages[selectedIndex],
            ),
          ),
          SizedBox(
        
            child: HomeButton(
              context,
              user,
              company,
            ),
          ),
        ]),
      ),
      drawer: UserMenu(
        company,
        user,
        
      ),
    );
  }
}

