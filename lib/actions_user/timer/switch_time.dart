import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/choose_date.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/current_date.dart';

class TabPair {
  final Tab tab;
  final int view;
  TabPair({required this.tab, required this.view});
}

late TabController _tabController;
late String startTime_switch;

class TabBarAndTabViews extends StatefulWidget {
  TabBarAndTabViews({required this.timeSwitchFunction});
  setStartTimeSwitchFunction timeSwitchFunction;

  @override
  TabBarAndTabViewsState createState() =>
      TabBarAndTabViewsState(timeSwitchFunction);
}

class TabBarAndTabViewsState extends State<TabBarAndTabViews>
    with SingleTickerProviderStateMixin {
  TabBarAndTabViewsState(this.timeSwitchFunction);

  setStartTimeSwitchFunction timeSwitchFunction;

  setStartTimeSwitch(String startTime) {
    startTime_switch = startTime;

    timeSwitchFunction(startTime_switch);
  }

  List<TabPair> TabPairs = [
    TabPair(
        tab: Tab(
          text: 'Datum automatisch',
        ),
        view: 1),
    TabPair(
        tab: Tab(
          text: 'Datum auswählen',
        ),
        view: 0),
  ];

  Widget switchWidgets(int indexSwitch) {
    if (indexSwitch == 0) {
      return SizedBox(
          height: 200, child: ChooseDate(settedStartTime: setStartTimeSwitch));
    } else {
      return SizedBox(height: 200, child: AutomatedDate(setStartTimeSwitch));
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: TabPairs.length, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          // give the tab bar a height [can change height to preferred height]
          Container(
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                25.0,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(6),
              child: TabBar(
                  controller: _tabController,
                  // give the indicator a decoration (color and border radius)
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      25.0,
                    ),
                    color: Color(0xff4338CA),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  tabs: TabPairs.map((tabPair) => tabPair.tab).toList()),
            ),
          ),
          Expanded(
            child: TabBarView(
                controller: _tabController,
                children: TabPairs.map((tabPair) => switchWidgets(tabPair.view))
                    .toList()),
          ),
        ],
      ),
    );
  }
}

typedef setStartTimeSwitchFunction = void Function(String startTime);
