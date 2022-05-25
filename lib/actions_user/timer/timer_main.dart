import 'dart:async';

import "package:intl/intl.dart";

import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/global_methods.dart';
import 'package:lottie/lottie.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/stopwatchv2.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/switch_time.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/insert_statements.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/update_statements.dart';


  StreamController<UpdateableStatistic> streamController =StreamController<UpdateableStatistic>();
 Stream stream = streamController.stream.asBroadcastStream();

InsertStatements insertStatements = InsertStatements();
Statistic statistic = Statistic.empty();
UpdateStatements updateStatements = UpdateStatements();
GlobalMethods globalmethods = GlobalMethods();

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


    if (d == 1) {
      statistic.endTime = _formatter.format(DateTime.now());
      statistic.date = _formatterDate.format(DateTime.now());
      statistic.countedTime =
          globalmethods.substractTimeString(statistic.startTime, statistic.endTime);

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
       setState(() {
    timerStart = _formatter.format(DateTime.now());
      });
      timerStart = _formatter.format(DateTime.now());
      /*setState(() {
        if (startcopy == "00:00:00") {
          timerStart = _formatter.format(DateTime.now());
        } else {
          timerStart = startcopy;
        }
      });*/
      print("User input");
      statistic.startTime = timerStart;
      statistic.date = _formatterDate.format(DateTime.now());
      statistic.statistic_id =
          insertStatements.insertNewStatistic(company, user, statistic);
    }
    statistic.startTime = timerStart;
  }

  

  @override
  Widget build(BuildContext context) {
    
print("controllerMain: " + streamController.toString());
    return FutureBuilder(
        future: _getStatsFromServer(user, company),
        builder: (context, dataSnapshot) {
          List<Widget> children;
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
        return globalmethods.loadingScreen();
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
