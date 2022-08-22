import 'dart:async';

import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/global_methods.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/delete_statements.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';
import 'package:sizer/sizer.dart';
import '../actions_user/show_stats/stats_main.dart';
import "package:intl/intl.dart";

SelectStatements selectStatements = SelectStatements();
DeleteStatements deleteStatements = DeleteStatements();
GlobalMethods globalmethods = GlobalMethods();
WhiteMode whiteMode = WhiteMode();

class FullStatsAdmin extends StatefulWidget {
  FullStatsAdmin(this.user, this.company);
  UserBuS user;
  Company company;
  @override
  State<FullStatsAdmin> createState() => _FullStatsAdminState(user, company);
}

class _FullStatsAdminState extends State<FullStatsAdmin> {
  _FullStatsAdminState(this.user, this.company);
  UserBuS user;
  Company company;
  bool checkBoxCurrentDateSelected = false;
  List<bool> expandedInfos = [];
  final _formatterDate = DateFormat('dd:MM:yyyy');

  late StreamController<List<Statistic>> currentStream =
      StreamController<List<Statistic>>();
  Future<void> closeStream() => currentStream.close();

  @override
  void initState() {
    super.initState();
    _getStatsFromServer();
    currentStream = StreamController<List<Statistic>>();
  }

  @override
  void dispose() {
    super.dispose();
    closeStream();
  }

  List<Statistic> currentStats = [];
  List<Statistic> currentStatsCopy =
      []; //for use by selecting checkbox without having to get data from Server
  Widget widgetBuilded = Container();

  List<Category> spaltenNamen = [
    Category("Startzeit", true),
    Category("Endzeit", false),
    Category("Datum", false),
    Category("Zeitspanne", false),
  ];

  @override
  Widget build(BuildContext context) {
    Widget expandedInfoTextRow(String textName, String textInput) {
      return Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            border: Border.all(
                width: 1, color: Theme.of(context).colorScheme.secondary),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 5,
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    textName,
                    style: TextStyle(fontSize: 9.sp),
                  ),
                ),
              ),
              Flexible(
                flex: 2,
                child: Container(
                  alignment: Alignment.centerRight,
                  child: textInput != "..."
                      ? Text(
                          textInput,
                          style: TextStyle(fontSize: 9.sp),
                        )
                      : CircleAvatar(
                          radius: 30.sp,
                          backgroundColor:
                              Theme.of(context).colorScheme.secondary,
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.green,
                            size: 10.sp,
                          ),
                        ),
                ),
              ),
            ],
          ));
    }

    Widget expandedInfoContainer(Statistic localStat, int index) {
      return SizedBox(
          height: expandedInfos[index] ? 30.h : 0,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 40),
              Container(
                padding: const EdgeInsets.all(5),
                height: 22.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border.all(
                      width: 2, color: Theme.of(context).colorScheme.secondary),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                        children: [
                          Flexible(
                              flex: 6,
                              child: expandedInfoTextRow(
                                  "Startzeit: ", localStat.startTime)),
                          Flexible(
                            flex: 1,
                            child: SizedBox(height: 0.5.h),
                          ),
                          Flexible(
                              flex: 6,
                              child: expandedInfoTextRow(
                                  "Stoppzeit: ", localStat.endTime)),
                          Flexible(
                            flex: 1,
                            child: SizedBox(height: 0.5.h),
                          ),
                          Flexible(
                              flex: 6,
                              child: expandedInfoTextRow(
                                "Zeitspanne: ",
                                localStat.countedTime != ""
                                    ? globalMethods.outputCountedTime(
                                        localStat.countedTime)
                                    : "...",
                              )),
                          Flexible(
                            flex: 1,
                            child: SizedBox(height: 0.5.h),
                          ),
                          Flexible(
                              flex: 6,
                              child: expandedInfoTextRow(
                                  "Datum: ", localStat.date)),
                          Flexible(
                            flex: 1,
                            child: SizedBox(height: 0.5.h),
                          ),
                          Flexible(
                              flex: 6,
                              child: expandedInfoTextRow(
                                  "Name des Eintrags: ", localStat.stat_name)),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.sp),
                    Flexible(
                        flex: 1,
                        child: Container(
                            padding: EdgeInsets.all(4.sp),
                            decoration: BoxDecoration(
                              color: Theme.of(context).backgroundColor,
                              border: Border.all(
                                  width: 1,
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: ListView.separated(
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 2.sp),
                                itemCount: localStat.user.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      height: 6.h,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).cardColor,
                                        border: Border.all(
                                            width: 2,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.sp)),
                                      ),
                                      child: ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: -4.sp, horizontal: 6.sp),
                                        dense: true,
                                        leading: CircleAvatar(
                                            radius: 12.sp,
                                            backgroundColor: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            child: Icon(
                                              Icons.person,
                                              color: Theme.of(context)
                                                  .backgroundColor,
                                            )),
                                        title: Text(
                                          localStat.user[index],
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ));
                                })))
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 40),
            ],
          ));
    }

    Widget CustomListTile(
      UserBuS user,
      Company company,
      Statistic statistic,
      int index,
    ) {
      Color color = const Color(0xFF4338CA);
      return Container(
          height: MediaQuery.of(context).size.height / 10,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            border: Border.all(
                width: 2, color: Theme.of(context).colorScheme.secondary),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
                height: MediaQuery.of(context).size.height / 13,
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  border: Border.all(
                      width: 2, color: Theme.of(context).colorScheme.secondary),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                width: (MediaQuery.of(context).size.width / 10) * 3,
                child: Center(
                    child: Column(children: [
                  SizedBox(height: 0.5.h),
                  const Text(
                    "Startzeit: ",
                    textScaleFactor: 1,
                  ),
                  const Text(
                    "Name des Eintrags: ",
                    textScaleFactor: 0.9,
                  ),
                  const Text(
                    "Datum: ",
                    textScaleFactor: 1,
                  )
                ]))),
            SizedBox(width: MediaQuery.of(context).size.width / 30),
            Container(
                width: MediaQuery.of(context).size.width / 5,
                height: MediaQuery.of(context).size.height / 13,
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  border: Border.all(
                      width: 2, color: Theme.of(context).colorScheme.secondary),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                    child: Column(children: [
                  const SizedBox(height: 5),
                  Text(
                    statistic.startTime,
                    textScaleFactor: 1,
                  ),
                  Text(
                    statistic.stat_name,
                    textScaleFactor: 1,
                  ),
                  Text(
                    statistic.date,
                    textScaleFactor: 1,
                  )
                ]))),
            SizedBox(
                width: (MediaQuery.of(context).size.width / 3),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: IconButton(
                        color: Theme.of(context).backgroundColor,
                        padding: const EdgeInsets.all(2),
                        iconSize: 20,
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await deleteStatements.deleteStatistic(
                              company, user, statistic);

                          currentStats.removeAt(index);
                          expandedInfos.removeAt(index);
                        }),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    child: IconButton(
                        color: Theme.of(context).backgroundColor,
                        padding: const EdgeInsets.all(2),
                        iconSize: 40,
                        icon: expandedInfos[index] == false
                            ? const Icon(Icons.arrow_drop_down_sharp)
                            : const Icon(Icons.arrow_right),
                        onPressed: () {
                          setState(() {
                            expandedInfos[index]
                                ? expandedInfos[index] = false
                                : expandedInfos[index] = true;
                          });
                        }),
                  ),
                ]))
          ]));
    }

    Widget spaltenCards(Category category) {
      return Container(
          height: 50,
          color: category.isSelected
              ? Theme.of(context).backgroundColor
              : Theme.of(context).textSelectionTheme.selectionColor!,
          width: 24.w,
          child: OutlinedButton(
            onPressed: () {
              sortList(category.title);

              setState(() {
                for (int i = 0; i < spaltenNamen.length; i++) {
                  if (spaltenNamen[i].title != category.title) {
                    spaltenNamen[i].isSelected = false;
                  }
                  category.isSelected = true;
                }
              });
            },
            child: Text(category.title,
                style: TextStyle(
                    color: category.isSelected
                        ? Theme.of(context).textSelectionTheme.selectionColor!
                        : Theme.of(context).backgroundColor)),
            style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5)),
                shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2))))),
          ));
    }

//main frontend

    return widgetBuilded = StreamBuilder(
        stream: currentStream.stream,
        builder: (context, snapshot) {
// Checking if future is resolved
          return snapshot.hasData
              ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 6, right: 6),
                        height: MediaQuery.of(context).size.height / 12,
                        color: Theme.of(context)
                            .textSelectionTheme
                            .selectionColor!,
                        child: Row(
                          children: [
                            spaltenCards(spaltenNamen[0]),
                            spaltenCards(spaltenNamen[1]),
                            spaltenCards(spaltenNamen[2]),
                            spaltenCards(spaltenNamen[3]),
                          ],
                        ),
                      ),
                      Container(
                        width: 80.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor.withOpacity(0.6),
                          border: Border.all(
                              width: 1,
                              color: Theme.of(context).colorScheme.secondary),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: ListTile(
                          onTap: () {
                            print("today: " +
                                _formatterDate.format(DateTime.now()));
                            List<Statistic> copyStats = [];
                            if (checkBoxCurrentDateSelected == false) {
                              for (int i = 0; i < currentStats.length; i++) {
                                if (currentStats[i].date ==
                                    _formatterDate.format(DateTime.now())) {
                                  copyStats.add(currentStats[i]);
                                }
                              }
                              setState(() {
                                currentStats = copyStats;
                              });
                            } else {
                              setState(() {
                                currentStats = currentStatsCopy;
                              });
                            }

                            setState(() {
                              checkBoxCurrentDateSelected
                                  ? checkBoxCurrentDateSelected = false
                                  : checkBoxCurrentDateSelected = true;
                            });
                          },
                          title: const Text(
                            "Ausschließlich heute",
                            style: TextStyle(fontSize: 20),
                          ),
                          trailing: Icon(checkBoxCurrentDateSelected
                              ? Icons.check_box
                              : Icons.crop_square_sharp),
                        ),
                      ),
                      SizedBox(
                        height: 70.h,
                        child: Scrollbar(
                            child: ListView.builder(
                                itemCount: currentStats.length,
                                padding: const EdgeInsets.all(5),
                                itemBuilder: (BuildContext context, int index) {
                                  return AnimatedSize(
                                      curve: Curves.easeIn,
                                      duration: const Duration(seconds: 1),
                                      child: Container(
                                          height: expandedInfos[index]
                                              ? 42.h
                                              : 12.h,
                                          padding: const EdgeInsets.all(5),
                                          child: Column(children: [
                                            CustomListTile(user, company,
                                                currentStats[index], index),
                                            expandedInfoContainer(
                                                currentStats[index], index),
                                          ])));
                                })),
                      )
                    ],
                  ))
              : const Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  sortList(String sortValue) {
    switch (sortValue) {
      case "Startzeit":
        var copyStats = currentStats;

        copyStats.sort((b, a) => a.startTime.compareTo(b.startTime));

        setState(() {
          currentStats = copyStats;
        });
        break;
      case "Endzeit: ":
        var copyStats = currentStats;

        copyStats.sort((a, b) => a.endTime.compareTo(b.endTime));

        setState(() {
          currentStats = copyStats;
        });
        break;
      case "Datum":
        var copyStats = currentStats;

        copyStats.sort((a, b) =>
            int.parse(a.countedTime).compareTo(int.parse(b.countedTime)));

        setState(() {
          currentStats = copyStats;
        });
        break;
      case "Zeitspanne":
        var copyStats = currentStats;

        copyStats.sort((a, b) =>
            int.parse(a.countedTime).compareTo(int.parse(b.countedTime)));

        setState(() {
          currentStats = copyStats;
        });

        break;
    }
  }

  _getStatsFromServer() async {
    try {
      List<Statistic> allStats =
          await selectStatements.selectStatsOfUserOnDate(user, company);

      for (int i = 0; i < allStats.length; i++) {
        expandedInfos.add(false);
      }
      currentStats = allStats;
      currentStatsCopy = allStats;
      currentStream.add(allStats);
    } catch (Exception) {
      print("Error while getting Data");
    }
  }

  deleteStatistic(UserBuS user, Statistic statistic, BuildContext context) {}
}
