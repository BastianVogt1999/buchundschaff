import 'dart:async';
import "package:intl/intl.dart";
import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/timer_main.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';

SelectStatements selectStatements = SelectStatements();

class IconValues {
  IconData icon_value;
  int itemIndex;

  Color color;
  IconValues(this.icon_value, this.itemIndex, this.color);
}

class StopwatchPage extends StatefulWidget {
  Statistic statisticInput;
  StreamController<UpdateableStatistic> streamSetStartTime;
  StopwatchPage(
      this.streamSetStartTime, this.user, this.company, this.statisticInput);
  User user;
  Company company;
  @override
  _StopwatchPageState createState() =>
      _StopwatchPageState(streamSetStartTime, user, company, statisticInput);
}

class _StopwatchPageState extends State<StopwatchPage> {
  Statistic statisticInput;
  User user;
  Company company;
  late Timer _timer;
  int buttonIndex = 0;
  final _formatter = DateFormat('HH:mm:ss');
  StreamController<UpdateableStatistic> streamSetStartTime;

  var StartTime = 0;
  var NowTime = 0;
  var RunState = 0; // 0:stop, 1:run

  _StopwatchPageState(
      this.streamSetStartTime, this.user, this.company, this.statisticInput);
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      Duration(milliseconds: 123),
      (_t) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Statistic data = await _getStatsFromServer(user, company);

    List<IconValues> buttonIcons = [
      IconValues(Icons.play_circle, 0, Colors.green),
      IconValues(Icons.stop, 1, Colors.red),
    ];

    if (RunState == 1) {
      NowTime = DateTime.now().millisecondsSinceEpoch.toInt();
    }

    _StartStopButton(Statistic statistic) {
      //switch button index: 0 (not running)
      if (buttonIndex == 0) {
        //Veränderung Button

        print("Timer started");
        setState(() {
          buttonIndex = 1;
        });
        //Veränderung Text-Status
        setState(() {
          StartTime = DateTime.now().millisecondsSinceEpoch.toInt();
          NowTime = DateTime.now().millisecondsSinceEpoch.toInt();
          RunState = 1;
        });
        streamSetStartTime.add(UpdateableStatistic(0, statistic));
      } else {
        print("Timer stopped");
        //Veränderung Button
        buttonIndex = 0;
        setState(() {
          buttonIndex = 0;
        });
        //Veränderung Text-Status
        setState(() {
          RunState = 0;
          StartTime = 0;
          NowTime = 0;
        });
        streamSetStartTime.add(UpdateableStatistic(1, statistic));
      }
    }

    var DiffTime =
        DateTime.fromMillisecondsSinceEpoch(NowTime - StartTime).toUtc();

    Widget buttonWidget(Statistic statistic) {
      return GestureDetector(
        onTap: // buttonIcons[buttonIndex].startStopFunction
            () {
          _StartStopButton(statistic);
        },
        child: Icon(
          buttonIcons[buttonIndex].icon_value,
          size: 45,
          color: buttonIcons[buttonIndex].color,
        ),
      );
    }

//if Timer is already running
    if (statistic.statistic_id != "") {
      buttonIndex = 1;
      setState(() {
        buttonIndex = 1;
      });
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatter.format(DiffTime),
                  style: TextStyle(fontSize: 30),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          color: Colors.white,
          width: double.infinity,
          height: 50,
          child: buttonWidget(statisticInput),
        )
      ],
    );
  }
}
