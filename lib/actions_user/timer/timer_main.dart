import "package:intl/intl.dart";
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/global_methods.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';
import 'package:sizer/sizer.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/insert_statements.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/update_statements.dart';

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

class IconValues {
  IconData icon_value;
  int itemIndex;

  Color color;
  IconValues(this.icon_value, this.itemIndex, this.color);
}

class Timer_main extends StatefulWidget {
  UserBuS user;
  Company company;

  Timer_main(this.user, this.company);

  @override
  State<Timer_main> createState() => _Timer_mainState(user, company);
}

class _Timer_mainState extends State<Timer_main> {
  UserBuS user;
  Company company;

  bool addUserButtonAble = true;
  double sizeOfUserFieldFull = 9;
  List<UserBuS> currentWorker = [];
  _Timer_mainState(this.user, this.company);

  String timerStart = "00:00:00";
  String startcopy = "00:00:00";
  final _formatterDate = DateFormat('dd:MM:yyyy');

  bool firstStarted = true;

  final _formatter = DateFormat('HH:mm:ss');
  var startTime = 0;
  var nowTime = 0;

  late StopWatchTimer _stopWatchTimer;
  var displayTime = "00:00:00";

  List<UserBuS> allUser = [];

  @override
  void initState() {
    _stopWatchTimer = StopWatchTimer(
      mode: StopWatchMode.countUp,
      onChange: (value) => displayTime = StopWatchTimer.getDisplayTime(value),
      onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
      onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
    );
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose(); // Need to call dispose function.
  }

  setStartTime(String startTime) {
    startcopy = startTime;
  }

  setTimeAtStart(int d, Statistic updateableStatistic) async {
    if (d == 1) {
      statistic.endTime = _formatter.format(DateTime.now());
      statistic.date = _formatterDate.format(DateTime.now());
      statistic.countedTime = globalmethods.substractTimeString(
          statistic.startTime, statistic.endTime);

      //  DateTime begin = DateTime.parse(statistic.endTime);

      //final difference = begin.difference(end).inSeconds;
      // statistic.countedTime = difference.toString();
      updateStatements.updateStatisticState(company, user, statistic);
      /*setState(() {
        timerStart = "00:00:00";
        startcopy = "00:00:00";
      });*/

      doubleChecker = 0;
    } else if (d == 0) {
      timerStart = _formatter.format(DateTime.now());
      /*setState(() {
        if (startcopy == "00:00:00") {
          timerStart = _formatter.format(DateTime.now());
        } else {
          timerStart = startcopy;
        }
      });*/
      if (startcopy == "00:00:00") {
        timerStart = _formatter.format(DateTime.now());
      } else {
        timerStart = startcopy;
      }

      statistic.startTime = timerStart;
      statistic.date = _formatterDate.format(DateTime.now());

      if (doubleChecker == 0) {
        statistic.statistic_id = insertStatements.insertNewStatistic(
            company, currentWorker, statistic);

        doubleChecker++;
      }
    }

    statistic.startTime = timerStart;
  }

  @override
  Widget build(BuildContext context) {
    timeAlreadyRunning = false;

    String formatTime(String formatTime) {
      int time = int.parse(formatTime);
      if (time <= 60) {
        int seconds = time % 60;
        if (seconds.toString().length > 1) {
          return "00:00" ":" + formatTime;
        } else {
          return "00:00" ":0" + formatTime;
        }
      } else if (time <= 3600) {
        int minute = time ~/ 60;
        int seconds = time % 60;
        if (minute.toString().length > 1 && seconds.toString().length > 1) {
          return "00:" + minute.toString() + ":" + seconds.toString();
        } else if (minute.toString().length == 1 &&
            seconds.toString().length > 1) {
          return "00:0" + minute.toString() + ":" + seconds.toString();
        } else if (minute.toString().length > 1 &&
            seconds.toString().length == 1) {
          return "00:" + minute.toString() + ":0" + seconds.toString();
        } else {
          return "00:" + minute.toString() + ":" + seconds.toString();
        }
      } else if (time > 3600) {
        int minute = time ~/ 3600;
        int seconds = time % 3600;
        int hours = time ~/ 60;

        return hours.toString() +
            ":" +
            minute.toString() +
            ":" +
            seconds.toString();
      }
      return "";
    }

    var DiffTime =
        DateTime.fromMillisecondsSinceEpoch(nowTime - startTime).toUtc();

    int _value = 1;

    if (firstStarted) {
      currentWorker.add(user);
      firstStarted = false;
    }
    _StartStopButton(Statistic statistic) {
      //switch button index: 0 (not running)

      if (!running) {
        print("Timer started");
        setState(() {
          //Veränderung Button
          addUserButtonAble = false;
          running = true;
        });
        //Veränderung Text-Status
        setState(() {
          startTime = DateTime.now().millisecondsSinceEpoch.toInt();
          nowTime = DateTime.now().millisecondsSinceEpoch.toInt();
        });
        _stopWatchTimer.onExecute.add(StopWatchExecute.start);
        setTimeAtStart(0, statistic);
      } else {
        print("Timer stopped");
        //Veränderung Button

        setState(() {
          //Veränderung Text-Status
          running = false;
          addUserButtonAble = true;
          startTime = 0;
          nowTime = 0;
        });
        _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
        _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
        setTimeAtStart(1, statistic);

        currentWorker = [];
        currentWorker.add(user);
        setState(() {
          sizeOfUserFieldFull = 9;
        });
        setState(() {});
      }
    }

    Widget buttonWidget() {
      return Container(
          color: running
              ? const Color.fromARGB(255, 241, 151, 151)
              : const Color.fromARGB(255, 157, 240, 171),
          height: MediaQuery.of(context).size.height / 16,
          width: MediaQuery.of(context).size.width,
          child: GestureDetector(
            onTap: () {
              _StartStopButton(statistic);
            },
            child: Icon(
              running ? Icons.stop_circle : Icons.play_circle_fill,
              size: 45,
              color: running ? Colors.red : Colors.green,
            ),
          ));
    }

    showAddUser() {
      return SizedBox(
        height: addUserShown ? 0.h : 20.h,
        width: 80.w,
        child: ListView.separated(
            separatorBuilder: (context, index) => Container(height: 1.h),
            itemCount: allUser.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  height: 8.h,
                  padding: const EdgeInsets.all(1),
                  color: whiteMode.cardColor,
                  child: ListTile(
                      title: Text(allUser[index].user_name),
                      onTap: () {
                        bool userInArray = false;
                        for (int i = 0; i < currentWorker.length; i++) {
                          if (allUser[index].user_name ==
                              currentWorker[i].user_name) {
                            userInArray = true;
                          }
                        }
                        if (userInArray == false) {
                          currentWorker.add(allUser[index]);

                          setState(() {
                            addUserShown = true;
                          });
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text("User bereits in Liste"),
                            duration: Duration(milliseconds: 2500),
                          ));
                        }
                      }));
            }),
      );
    }

    Widget addUserDisplay = AnimatedSize(
        curve: Curves.decelerate,
        duration: const Duration(seconds: 1),
        child: SizedBox(
            height: addUserShown ? 30.h : 10.h,
            child: ListView.separated(
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 10);
                },
                itemCount: currentWorker.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: MediaQuery.of(context).size.height / 13,
                      color: whiteMode.cardColor,
                      child: ListTile(
                        title: Row(children: [
                          Text(
                            currentWorker[index].user_name,
                            style: TextStyle(color: whiteMode.abstractColor),
                          ),
                        ]),
                        trailing: IconButton(
                          iconSize: 40,
                          onPressed: () {
                            if (!running) {
                              if (currentWorker.length > 1) {
                                if (addUserButtonAble) {
                                  currentWorker.removeAt(index);
                                  setState(() {
                                    currentWorker = currentWorker;
                                  });

                                  if (sizeOfUserFieldFull > 9) {
                                    setState(() {
                                      sizeOfUserFieldFull =
                                          sizeOfUserFieldFull - 1.8;
                                    });
                                  } else {
                                    setState(() {
                                      sizeOfUserFieldFull = 9;
                                    });
                                  }
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  backgroundColor: Colors.red,
                                  content: Text(
                                      "Es muss mindestens ein User ausgewählt sein"),
                                  duration: Duration(milliseconds: 2500),
                                ));
                              }
                            }
                          },
                          icon: const Icon(Icons.remove_circle),
                          color: addUserButtonAble
                              ? Colors.red
                              : whiteMode.backgroundColor,
                        ),
                      ));
                })));

    Widget stopWatch() {
      return FutureBuilder(
          future: _getStatsFromServer(user, company),
          builder: (context, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Container();
            } else {
              if (dataSnapshot.error != null) {
                return const Center(
                  child: Text('An error occured'),
                );
              } else {
                var data = dataSnapshot.data as Statistic;

                if (data.isrunning != "") {
                  setState(() {
                    timeAlreadyRunning = true;
                    running = true;
                  });
                  _StartStopButton(data);
                }

                return SizedBox(
                    height: 15.h,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        StreamBuilder<int>(
                          stream: _stopWatchTimer.secondTime,
                          initialData: 0,
                          builder: (context, snap) {
                            final value = snap.data;

                            print('Listen every minute. $value');
                            return Column(
                              children: <Widget>[
                                Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4),
                                          child: Text(
                                            formatTime(value.toString()),
                                            style: TextStyle(
                                                fontSize: 30,
                                                color: running
                                                    ? whiteMode.abstractColor
                                                    : whiteMode.backgroundColor,
                                                fontFamily: 'Helvetica',
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ));
              }
            }
          });
    }

//main Frontend

    return Container(
      padding: const EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height,
      child: Column(children: [
        Divider(
          height: MediaQuery.of(context).size.height / 30,
        ),
        AnimatedSize(
          curve: Curves.decelerate,
          duration: const Duration(seconds: 1),
          child: SizedBox(
            width: 100.w,
            height: addUserShown ? 10.h : 30.h,
            child: Column(
              children: [
                Container(
                  width: 100.w,
                  color: addUserButtonAble
                      ? whiteMode.abstractColor
                      : Colors.grey.withOpacity(0.2),
                  child: IconButton(
                    iconSize: 45,
                    onPressed: () {
                      if (!running) {
                        setState(() {
                          addUserShown
                              ? addUserShown = false
                              : addUserShown = true;
                        });
                      }
                    },
                    icon: Icon(
                        addUserShown ? Icons.add_circle : Icons.close_sharp),
                    color: addUserButtonAble
                        ? whiteMode.backgroundColor
                        : Colors.grey,
                  ),
                ),
                showAddUser()
              ],
            ),
          ),
        ),
        Divider(
          height: MediaQuery.of(context).size.height / 30,
        ),
        addUserDisplay,
        Divider(
          height: MediaQuery.of(context).size.height / 30,
        ),
        Container(
            color: whiteMode.abstractColor,
            height: MediaQuery.of(context).size.height / 8,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Startzeit',
                  style: TextStyle(
                      fontSize: 25,
                      color: running
                          ? whiteMode.backgroundColor
                          : whiteMode.abstractColor),
                ),
                Text(
                  timerStart,
                  style: TextStyle(
                      fontSize: 30,
                      color: running
                          ? whiteMode.backgroundColor
                          : whiteMode.abstractColor),
                )
              ],
            ))),
        SizedBox(
          height: 15.h,
          child: stopWatch(),
        ),
        buttonWidget(),
      ]),
    );
  }

  _getStatsFromServer(UserBuS user, Company company) async {
    try {
      Statistic stat = await selectStatements.selectStatOfUserO(user, company);
      allUser = await selectStatements.selectAllUserOfCompany(company);

      return stat;
    } catch (Exception) {
      print("Error while getting Data");
    }
  }
}
