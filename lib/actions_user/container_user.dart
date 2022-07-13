import 'dart:async';

import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/day_stats.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/messages_user.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/show_stats/stats_main.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/timer_main.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/user_menu.dart';
import 'package:itm_ichtrinkmehr_flutter/common_actions/home_button.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';



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
        title: Text(user.user_name, style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff4338CA),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff4338CA), Color(0xff6D28D9)],
              stops: [0.5, 1.0],
            ),
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(children: [
          SizedBox(
            height: 650,
            child: Container(
              child: _pages[selectedIndex],
            ),
          ),
          Container(
            height: 50,
            alignment: Alignment.bottomRight,
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
