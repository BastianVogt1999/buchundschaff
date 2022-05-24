import 'dart:async';

import "package:intl/intl.dart";

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/stopwatchv2.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/switch_time.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/insert_statements.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/update_statements.dart';

StreamController<UpdateableStatistic> streamController =
    StreamController<UpdateableStatistic>();
Stream stream = streamController.stream.asBroadcastStream();

InsertStatements insertStatements = InsertStatements();
Statistic statistic = Statistic.empty();
UpdateStatements updateStatements = UpdateStatements();

class Timer_main extends StatefulWidget {
  User user;
  Company company;
  Timer_main(this.user, this.company);

  @override
  State<Timer_main> createState() => _Timer_mainState(user, company);
}

class _Timer_mainState extends State<Timer_main> {
  bool flag = true;
  late Stream<int> timerStream;
  late StreamSubscription<int> timerSubscription;
  User user;
  Company company;

  _Timer_mainState(this.user, this.company);

  String timerStart = "00:00:00";
  String startcopy = "00:00:00";
  final _formatter = DateFormat('HH:mm:ss');
  final _formatterDate = DateFormat('dd:MM:yyyy');

  @override
  void initState() {
    super.initState();

    stream.listen((UpdateableStatistic) {
      setTimeAtStart(
          UpdateableStatistic.index, UpdateableStatistic.updateableStatistic);
    });
  }

  setStartTime(String startTime) {
    startcopy = startTime;
  }

  setTimeAtStart(int d, Statistic updateableStatistic) async {
    print("Poggers");

    if (d == 1) {
      statistic.endTime = _formatter.format(DateTime.now());
      statistic.date = _formatterDate.format(DateTime.now());
      statistic.countedTime =
          substractTimeString(statistic.startTime, statistic.endTime);

      //  DateTime begin = DateTime.parse(statistic.endTime);

      //final difference = begin.difference(end).inSeconds;
      // statistic.countedTime = difference.toString();
      updateStatements.updateStatisticState(company, user, statistic);
      setState(() {
        timerStart = "00:00:00";
        startcopy = "00:00:00";
      });
    }
    if (d == 0) {
      timerStart = _formatter.format(DateTime.now());
      /*setState(() {
        if (startcopy == "00:00:00") {
          timerStart = _formatter.format(DateTime.now());
        } else {
          timerStart = startcopy;
        }
      });*/
      statistic.startTime = timerStart;
      statistic.date = _formatterDate.format(DateTime.now());
      statistic.statistic_id =
          insertStatements.insertNewStatistic(company, user, statistic);
    }
    statistic.startTime = timerStart;
  }

  String substractTimeString(String startTime, String endTime) {
    print("startTime: " + startTime);
    print("endTime: " + endTime);
    String result = "";

    List<String> startTimeArrayString = statistic.startTime.split(":");
    List<String> endTimeArrayString = statistic.endTime.split(":");

    List<int> startTimeArrayInt = <int>[];
    List<int> endTimeArrayInt = <int>[];

//parse all String to int
    for (int i = 0; i < 3; i++) {
      startTimeArrayInt.add(int.parse(startTimeArrayString[i]));
      endTimeArrayInt.add(int.parse(endTimeArrayString[i]));
    }

//substract Seconds

    int seconds = endTimeArrayInt[2] - startTimeArrayInt[2];

    int minutes = (endTimeArrayInt[1] - startTimeArrayInt[1]) * 60;

    int hours = (endTimeArrayInt[0] - startTimeArrayInt[0]) * 3600;

    if (seconds < 0) {
      seconds = seconds + 60;
      minutes - 1;
    }
    if (minutes < 0) {
      minutes = minutes + 60;
      hours - 1;
    }
    if (hours < 0) {
      hours = 0;
    }

    result = (seconds + minutes + hours).toString();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getStatsFromServer(user, company),
        builder: (context, dataSnapshot) {
          List<Widget> children;
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Lottie.asset("assets/worker.json"),
                  ),
                )
              ],
            );
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occured'),
              );
            } else {
              final data = dataSnapshot.data as Statistic;

              return SizedBox(
                height: double.infinity,
                child: Column(children: [
                  Divider(height: 20),
                  SizedBox(
                    height: 355,
                    child: TabBarAndTabViews(timeSwitchFunction: setStartTime),
                  ),
                  SizedBox(
                      height: 80,
                      child: Scaffold(
                          body: Center(
                              child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Startzeit',
                            style: TextStyle(fontSize: 25),
                          ),
                          Text(
                            timerStart,
                            style: TextStyle(fontSize: 30),
                          )
                        ],
                      )))),
                  SizedBox(
                    height: 150,
                    child: StopwatchPage(streamController, user, company, data),
                  ),
                ]),
              );
            }
          }
        });
  }
}

_getStatsFromServer(User user, Company company) async {
  try {
    Statistic stat = await selectStatements.selectStatOfUserO(user, company);

    return stat;
  } catch (Exception) {
    print("Error while getting Data");
  }
}
