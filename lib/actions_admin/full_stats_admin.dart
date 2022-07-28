import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/global_methods.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/delete_statements.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';

import '../actions_user/show_stats/stats_main.dart';

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
  UserBuS user;
  Company company;
  List<bool> expandedInfos = [];

  _FullStatsAdminState(this.user, this.company);

  List<Statistic> currentStats = [];
  Widget widgetBuilded = Container();
  updateWidget() {
    setState(() {
      currentStats = currentStats;
    });
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
          height:
              expandedInfos[index] ? MediaQuery.of(context).size.height / 4 : 0,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 40),
              Container(
                padding: const EdgeInsets.all(5),
                height: MediaQuery.of(context).size.height / 5,
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
                                localStat.countedTime != ""
                                    ? globalMethods.outputCountedTime(
                                        localStat.countedTime)
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
                    backgroundColor: whiteMode.abstractColor,
                    child: IconButton(
                        color: whiteMode.backgroundColor,
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
                    backgroundColor: whiteMode.abstractColor,
                    child: IconButton(
                        color: whiteMode.backgroundColor,
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
          width: (MediaQuery.of(context).size.width / spaltenNamen.length) - 6,
          child: OutlinedButton(
            onPressed: () {
//currentStats.sort((a, b) => a.countedTime.length.compareTo(b.countedTime.length));
              updateWidget();

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

    widgetBuilded = FutureBuilder(
        future: _getStatsFromServer(company, user),
        builder: (context, dataSnapshot) {
          List<Widget> children;
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return globalmethods.loadingScreen(context);
          } else {
            if (dataSnapshot.error != null) {
              return const Center(
                child: Text('An error occured'),
              );
            } else {
              currentStats = dataSnapshot.data as List<Statistic>;

              return SizedBox(
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
                        height: MediaQuery.of(context).size.height / 1.25,
                        child: Scrollbar(
                            child: ListView.builder(
                                itemCount: currentStats.length,
                                padding: const EdgeInsets.all(5),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      padding: const EdgeInsets.all(5),
                                      child: Column(children: [
                                        CustomListTile(user, company,
                                            currentStats[index], index),
                                        AnimatedSize(
                                            curve: Curves.easeIn,
                                            duration:
                                                const Duration(seconds: 1),
                                            child: expandedInfoContainer(
                                                currentStats[index], index)),
                                      ]));
                                })),
                      )
                    ],
                  ));
            }
          }
        });

    return widgetBuilded;
  }

  _getStatsFromServer(
    Company company,
    UserBuS user,
  ) async {
    try {
      List<Statistic> allDrinks =
          await selectStatements.selectAllStats(company);

      for (int i = 0; i < allDrinks.length; i++) {
        expandedInfos.add(false);
      }
      return allDrinks;
    } catch (Exception) {
      print("Error while getting Data");
    }
  }

  deleteStatistic(UserBuS user, Statistic statistic, BuildContext context) {}
}
