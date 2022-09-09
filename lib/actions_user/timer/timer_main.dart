import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/new_timer.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/running_projects_user.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/global_methods.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/insert_statements.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/update_statements.dart';

import 'package:sizer/sizer.dart';

InsertStatements insertStatements = InsertStatements();
Statistic statistic = Statistic.empty();
UpdateStatements updateStatements = UpdateStatements();
SelectStatements selectStatements = SelectStatements();
GlobalMethods globalmethods = GlobalMethods();
WhiteMode whiteMode = WhiteMode();
bool timeAlreadyRunning = false;
bool addUserShown = true;
int doubleChecker = 0;
bool running = false;

class TabPair {
  final Tab tab;
  final Widget view;
  TabPair({required this.tab, required this.view});
}

class Timer_main extends StatefulWidget {
  Company company;

  Timer_main(this.company, {Key? key}) : super(key: key);

  @override
  State<Timer_main> createState() => _Timer_mainState(company);
}

class _Timer_mainState extends State<Timer_main>
    with SingleTickerProviderStateMixin {
  Company company;
  late TabController _tabController;

  _Timer_mainState(this.company);

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<TabPair> TabPairs = [
      TabPair(
        tab: const Tab(
          text: 'Laufende Projekte',
        ),
        view: Center(
          child: RunningProjects(company),
        ),
      ),
      TabPair(
        tab: const Tab(
          text: 'Neues Projekt',
        ),
        view: Center(
          child: NewTimer(company),
          // replace with your own widget here
        ),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(40),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          children: [
            // give the tab bar a height [can change height to preferred height]
            Container(
              height: 5.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  2.h,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6),
                child: TabBar(
                    controller: _tabController,
                    // give the indicator a decoration (color and border radius)
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        2.h,
                      ),
                      color: Theme.of(context).backgroundColor,
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    tabs: TabPairs.map((tabPair) => tabPair.tab).toList()),
              ),
            ),
            Expanded(
              child: TabBarView(
                  controller: _tabController,
                  children: TabPairs.map((tabPair) => tabPair.view).toList()),
            ),
          ],
        ),
      ),
    );
  }
}
