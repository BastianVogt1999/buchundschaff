import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itm_ichtrinkmehr_flutter/global_methods.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/update_statements.dart';
import 'package:sizer/sizer.dart';

import '../../values/company.dart';
import '../../values/user.dart';

SelectStatements selectStatements = SelectStatements();

class RunningProjects extends StatefulWidget {
  RunningProjects(this.company, {Key? key}) : super(key: key);
  Company company;

  @override
  State<RunningProjects> createState() => _RunningProjectsState(company);
}

class _RunningProjectsState extends State<RunningProjects> {
  List<Statistic> running_projects = [];
  List<bool> projectExpanded = [];
  List<bool> addUserShown = [];
  Company company;

  _RunningProjectsState(this.company);

  late StreamController<List<Statistic>> currentStream =
      StreamController<List<Statistic>>();
  Future<void> closeStream() => currentStream.close();

  @override
  void initState() {
    super.initState();
    _getStatsFromServer();
    start();
    currentStream = StreamController<List<Statistic>>();
  }

  @override
  void dispose() {
    super.dispose();
    closeStream();
  }

  @override
  Widget build(BuildContext context) {
    Widget expandedInfoTextRow(String textName, String textInput) {
      //text row in expanded Container
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
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  textName,
                  style: TextStyle(fontSize: 9.sp),
                ),
              ),
              Spacer(),
              Container(
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
            ],
          ));
    }

    addUserShownContainer(Statistic localStat, int index) {
      return Container(
        width: 100.w,
        child: Column(children: [
          Container(
            child: IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  addUserShown[index] = false;
                });
              },
            ),
          )
        ]),
      );
      //Container if "addUser" is pressed
    }

    normalListContainer(Statistic localStat, int index) {
      //Container if "addUser" not pressed
      return Column(
        children: [
          Flexible(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  addUserShown[index] = !addUserShown[index];
                });
              },
              child: Container(
                  padding: EdgeInsets.all(0.5.h),
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 119, 151, 234),
                    border: Border.all(
                        width: 2,
                        color: Theme.of(context).colorScheme.secondary),
                    borderRadius: BorderRadius.all(Radius.circular(8.sp)),
                  ),
                  child: Row(children: [
                    CircleAvatar(
                        radius: 8.sp,
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        child: Icon(
                          Icons.add,
                          size: 2.h,
                          color: Theme.of(context).backgroundColor,
                        )),
                    SizedBox(width: 2.w),
                    Text(
                      "User",
                      style: const TextStyle(fontSize: 14),
                    ),
                  ])),
            ),
          ),
          Divider(
            height: 1.h,
            color: Colors.black,
            thickness: 2,
          ),
          Flexible(
            flex: 7,
            child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(height: 0.2.h),
                itemCount: localStat.user.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      padding: EdgeInsets.all(0.5.h),
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        border: Border.all(
                            width: 2,
                            color: Theme.of(context).colorScheme.secondary),
                        borderRadius: BorderRadius.all(Radius.circular(8.sp)),
                      ),
                      child: Row(children: [
                        CircleAvatar(
                            radius: 8.sp,
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            child: Icon(
                              Icons.person,
                              size: 2.h,
                              color: Theme.of(context).backgroundColor,
                            )),
                        SizedBox(width: 2.w),
                        Text(
                          localStat.user[index],
                          style: TextStyle(fontSize: 7.sp),
                        ),
                      ]));
                }),
          ),
        ],
      );
    }

    Widget expandedInfoContainer(Statistic localStat, int index) {
      //container of expanded infos
      return SizedBox(
          height: projectExpanded[index] ? 22.h : 0,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                height: 20.h,
                width: 80.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  border: Border.all(
                      width: 2, color: Theme.of(context).colorScheme.secondary),
                ),
                child: Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: Column(
                        children: [
                          Flexible(
                              flex: 6,
                              child: expandedInfoTextRow(
                                  "Name: ", localStat.stat_name)),
                          Flexible(
                            flex: 1,
                            child: SizedBox(height: 0.5.h),
                          ),
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
                                  GlobalMethods().outputCountedTime(
                                      localStat.countedTime))),
                          Flexible(
                            flex: 1,
                            child: SizedBox(height: 0.5.h),
                          ),
                          Flexible(
                              flex: 6,
                              child: expandedInfoTextRow(
                                  "Datum: ", localStat.date)),
                        ],
                      ),
                    ),
                    Flexible(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0.5.h, 0.5.h, 1.h, 0.h),
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            border: Border.all(
                                width: 1,
                                color: Theme.of(context).colorScheme.secondary),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: addUserShown[index]
                              ? addUserShownContainer(localStat, index)
                              : normalListContainer(localStat, index),
                        ))
                  ],
                ),
              ),
              SizedBox(height: 1.h),
            ],
          ));
    }

    return StreamBuilder(
        stream: currentStream.stream,
        builder: (context, snapshot) {
// Checking if future is resolved
          return snapshot.hasData
              ? Container(
                  padding: EdgeInsets.all(2.h),
                  child: Column(
                    children: [
                      Container(
                        height: 60.h,
                        child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 1.h),
                            itemCount: running_projects.length,
                            itemBuilder: (BuildContext context, int index) {
                              return AnimatedSize(
                                curve: projectExpanded[index]
                                    ? Curves.easeOut
                                    : Curves.linear,
                                duration: const Duration(seconds: 1),
                                child: SizedBox(
                                    height:
                                        !projectExpanded[index] ? 12.h : 32.h,
                                    child: Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).cardColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          height: 10.h,
                                          padding: EdgeInsets.fromLTRB(
                                              2.h, 0.5.h, 2.h, 0.5.h),
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                child: Icon(Icons.stop,
                                                    size: 6.h,
                                                    color: Colors.red),
                                                onTap: () {
                                                  running_projects[index]
                                                      .isrunning = "false";
                                                  UpdateStatements()
                                                      .updateStatisticRunning(
                                                          company,
                                                          running_projects[
                                                              index]);

                                                  running_projects
                                                      .removeAt(index);
                                                  setState(() {});
                                                },
                                              ),
                                              const Spacer(),
                                              Text(
                                                GlobalMethods()
                                                    .outputCountedTime(
                                                        running_projects[index]
                                                            .countedTime),
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    fontSize: 2.h),
                                              ),
                                              const Spacer(),
                                              Text(
                                                running_projects[index]
                                                            .stat_name !=
                                                        ""
                                                    ? running_projects[index]
                                                        .stat_name
                                                    : "-Kein Name-",
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary,
                                                    fontSize: 2.h),
                                              ),
                                              const Spacer(),
                                              GestureDetector(
                                                child: Icon(
                                                    !projectExpanded[index]
                                                        ? Icons.menu
                                                        : Icons.close,
                                                    size: 4.h,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary),
                                                onTap: () {
                                                  setState(() {
                                                    projectExpanded[index] =
                                                        !projectExpanded[index];
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        expandedInfoContainer(
                                            running_projects[index], index)
                                      ],
                                    )),
                              );
                            }),
                      ),
                      Container(
                        height: 10.h,
                        color: Colors.black,
                      ),
                    ],
                  ))
              : const Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  void start() {
    Timer.periodic(Duration(seconds: 1), (Timer t) {
      for (int i = 0; i < running_projects.length; i++) {
        setState(() {
          running_projects[i].countedTime =
              (int.parse(running_projects[i].countedTime) + 1).toString();
        });
      }
    });
  }

  _getStatsFromServer() async {
    try {
      List<Statistic> allStats =
          await selectStatements.selectAllRunningStats(company);

      currentStream.add(allStats);

      for (int i = 0; i < allStats.length; i++) {
        projectExpanded.add(false);
        addUserShown.add(false);
      }

      setState(() {
        running_projects = allStats;
      });
    } catch (Exception) {
      print("Error while getting Data");
    }
  }
}
