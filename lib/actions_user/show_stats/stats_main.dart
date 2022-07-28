import 'dart:async';

import 'package:flutter/material.dart';

import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/timer_main.dart';
import 'package:itm_ichtrinkmehr_flutter/global_methods.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/delete_statements.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';
import 'package:sizer/sizer.dart';

class Category {
  final String title;
  bool isSelected;
  Category(this.title, this.isSelected);
}

SelectStatements selectStatements = SelectStatements();
DeleteStatements deleteStatements = DeleteStatements();
GlobalMethods globalMethods = GlobalMethods();

class Stats_main extends StatefulWidget {
  final UserBuS user;
  final Company company;
  const Stats_main(this.user, this.company, {Key? key}) : super(key: key);

  @override
  State<Stats_main> createState() => _Stats_mainState(user, company);
}

class _Stats_mainState extends State<Stats_main> {
  UserBuS user;
  Company company;

  List<bool> expandedInfos = [];

  _Stats_mainState(this.user, this.company);
  late StreamController<List<Statistic>> currentStream =
      StreamController<List<Statistic>>();
  Future<void> closeStream() => currentStream.close();

  @override
  void initState() {
    super.initState();
    currentStream = StreamController<List<Statistic>>();
  }

  @override
  void dispose() {
    super.dispose();
    closeStream();
  }

  List<Statistic> currentStats = [];
  Widget widgetBuilded = Container();
  updateWidget() {
    setState(() {});
  }

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
            color: whiteMode.backgroundColor,
            border: Border.all(width: 1, color: whiteMode.abstractColor),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: Text(
                  textName,
                  style: const TextStyle(fontSize: 10),
                ),
              ),
              Flexible(
                flex: 1,
                child: Text(
                  textInput,
                  style: const TextStyle(fontSize: 10),
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
                  color: whiteMode.backgroundColor,
                  border: Border.all(width: 2, color: whiteMode.abstractColor),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  children: [
                    Flexible(
                      flex: 1,
                      child: Column(
                        children: [
                          Flexible(
                              flex: 1,
                              child: expandedInfoTextRow(
                                  "Startzeit: ", localStat.startTime)),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 90),
                          Flexible(
                              flex: 1,
                              child: expandedInfoTextRow(
                                  "Stoppzeit: ", localStat.endTime)),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 90),
                          Flexible(
                              flex: 1,
                              child: expandedInfoTextRow(
                                "Zeitspanne: ",
                                statistic.countedTime != ""
                                    ? globalMethods.outputCountedTime(
                                        statistic.countedTime)
                                    : "...",
                              )),
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 90),
                          Flexible(
                              flex: 1,
                              child: expandedInfoTextRow(
                                  "Datum: ", localStat.date)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                        flex: 1,
                        child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: whiteMode.backgroundColor,
                              border: Border.all(
                                  width: 1, color: whiteMode.abstractColor),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                            ),
                            child: ListView.builder(
                                itemCount: localStat.user.length,
                                padding: const EdgeInsets.all(5),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      padding: const EdgeInsets.all(3),
                                      child: Text(
                                        localStat.user[index],
                                        style: const TextStyle(fontSize: 14),
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
            color: whiteMode.cardColor,
            border: Border.all(width: 2, color: whiteMode.abstractColor),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          padding: const EdgeInsets.only(left: 8, right: 8),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
                height: MediaQuery.of(context).size.height / 13,
                decoration: BoxDecoration(
                  color: whiteMode.backgroundColor,
                  border: Border.all(width: 2, color: whiteMode.abstractColor),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                width: (MediaQuery.of(context).size.width / 10) * 3,
                child: Center(
                    child: Column(children: const [
                  SizedBox(height: 5),
                  Text(
                    "Startzeit: ",
                    textScaleFactor: 1,
                  ),
                  Text(
                    "Stoppzeit: ",
                    textScaleFactor: 1,
                  ),
                  Text(
                    "Zeitspanne: ",
                    textScaleFactor: 1,
                  )
                ]))),
            SizedBox(width: MediaQuery.of(context).size.width / 30),
            Container(
                width: MediaQuery.of(context).size.width / 5,
                height: MediaQuery.of(context).size.height / 13,
                decoration: BoxDecoration(
                  color: whiteMode.backgroundColor,
                  border: Border.all(width: 2, color: whiteMode.abstractColor),
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
                    statistic.endTime,
                    textScaleFactor: 1,
                  ),
                  Text(
                    statistic.countedTime != ""
                        ? globalMethods.outputCountedTime(statistic.countedTime)
                        : "...",
                    textScaleFactor: 1,
                  )
                ]))),
            SizedBox(
                width: (MediaQuery.of(context).size.width / 3),
                child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.amber,
                    child: IconButton(
                        color: Colors.black,
                        padding: const EdgeInsets.all(2),
                        iconSize: 20,
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await deleteStatements.deleteStatistic(
                              company, user, statistic);

                          currentStats.removeAt(index);
                          expandedInfos.removeAt(index);
                          updateWidget();
                        }),
                  ),
                  const SizedBox(width: 10),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.amber,
                    child: IconButton(
                        color: Colors.black,
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
              ? whiteMode.backgroundColor
              : whiteMode.textColor,
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
                        ? whiteMode.textColor
                        : whiteMode.backgroundColor)),
            style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5)),
                shape: MaterialStateProperty.all(const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(2))))),
          ));
    }

    _getStatsFromServer();

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
                        color: whiteMode.textColor,
                        child: Row(
                          children: [
                            spaltenCards(spaltenNamen[0]),
                            spaltenCards(spaltenNamen[1]),
                            spaltenCards(spaltenNamen[2]),
                            spaltenCards(spaltenNamen[3]),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 80.h,
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
      case "Startzeit: ":
        break;
      case "Startzeit":
        break;
      case "Endzeit: ":
        break;
      case "Datum":
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
      List<Statistic> allDrinks =
          await selectStatements.selectStatsOfUserOnDate(user, company);

      for (int i = 0; i < allDrinks.length; i++) {
        expandedInfos.add(false);
      }
      currentStats = allDrinks;
      currentStream.add(allDrinks);
    } catch (Exception) {
      print("Error while getting Data");
    }
  }

  deleteStatistic(UserBuS user, Statistic statistic, BuildContext context) {}
}
