import 'dart:async';
import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/show_stats/popup_edit_stat.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/show_stats/popup_full_stats.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/timer_main.dart';
import 'package:itm_ichtrinkmehr_flutter/global_methods.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/delete_statements.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';
import 'package:lottie/lottie.dart';

class Category {
  final String title;
  bool isSelected;
  Category(this.title, this.isSelected);
}

SelectStatements selectStatements = SelectStatements();
DeleteStatements deleteStatements = DeleteStatements();
GlobalMethods globalMethods = GlobalMethods();

class Stats_main extends StatefulWidget {
  final User user;
  final Company company;
  const Stats_main(this.user, this.company, {Key? key}) : super(key: key);

  @override
  State<Stats_main> createState() => _Stats_mainState(user, company);
}

class _Stats_mainState extends State<Stats_main> {
  User user;
  Company company;

  _Stats_mainState(this.user, this.company);
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
    Widget CustomListTile(
      User user,
      Company company,
      Statistic statistic,
      int index,
    ) {
      Color color = const Color(0xFF4338CA);
      return Container(
          height: 80,
          color: Colors.white,
          child: Row(children: [
            SizedBox(
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
            SizedBox(
                width: (MediaQuery.of(context).size.width / 10) * 2,
                child: Center(
                    child: Column(children: [
                  SizedBox(height: 5),
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
                width: (MediaQuery.of(context).size.width / 10) * 4,
                child: Row(children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.amber,
                    child: IconButton(
                        color: Colors.black,
                        padding: const EdgeInsets.all(2),
                        iconSize: 20,
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showDialog<Dialog>(
                              context: context,
                              builder: (BuildContext context) =>
                                  EditStats(statistic, user, company));
                        }),
                  ),
                  SizedBox(width: 10),
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
                          updateWidget();
                        }),
                  ),
                  SizedBox(width: 10),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.amber,
                    child: IconButton(
                        color: Colors.black,
                        padding: const EdgeInsets.all(2),
                        iconSize: 20,
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          showDialog<Dialog>(
                              context: context,
                              builder: (BuildContext context) =>
                                  FullStats(statistic));
                        }),
                  ),
                ]))
          ]));
    }

    Widget spaltenCards(Category category) {
      return Container(
          height: 50,
          color: category.isSelected ? Colors.white : Colors.black,
          width: MediaQuery.of(context).size.width / spaltenNamen.length,
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
                    color: category.isSelected ? Colors.black : Colors.grey)),
            style: ButtonStyle(
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical: 10, horizontal: 5)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
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
              return Center(
                child: Text('An error occured'),
              );
            } else {
              currentStats = dataSnapshot.data as List<Statistic>;

              return Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Container(
                        height: 50,
                        color: Colors.black,
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
                        height: MediaQuery.of(context).size.height - 200,
                        child: Scrollbar(
                            child: ListView.builder(
                                itemCount: currentStats.length,
                                padding: EdgeInsets.all(5),
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                      padding: EdgeInsets.all(5),
                                      child: CustomListTile(user, company,
                                          currentStats[index], index));
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
    User user,
  ) async {
    try {
      List<Statistic> allDrinks =
          await selectStatements.selectStatsOfUserOnDate(user, company);

      return allDrinks;
    } catch (Exception) {
      print("Error while getting Data");
    }
  }

  deleteStatistic(User user, Statistic statistic, BuildContext context) {}
}
