import 'dart:async';

import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';
import 'package:sizer/sizer.dart';
import '../values/company.dart';
import '../values/statistic.dart';

WhiteMode whiteMode = WhiteMode();
SelectStatements selectStatements = SelectStatements();

class RunningProjects extends StatefulWidget {
  RunningProjects(this.company);
  Company company;
  @override
  State<RunningProjects> createState() => _RunningProjectsState(company);
}

class _RunningProjectsState extends State<RunningProjects> {
  late StreamController<List<Statistic>> currentStream =
      StreamController<List<Statistic>>();
  Future<void> closeStream() => currentStream.close();

  List<Statistic> currentStats = [];
  List<bool> sizeOfContainer = [];

  Company company;
  _RunningProjectsState(this.company);

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

  @override
  Widget build(BuildContext context) {
    Widget decoratedBox(Statistic localStat, int index) {
      return SizedBox(
        height: sizeOfContainer[index] ? 22.8.h : 0.h,
        child: Column(
          children: [
            Container(
                height: 8.h,
                padding: EdgeInsets.all(0.5.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  border: Border.all(
                      width: 1, color: Theme.of(context).colorScheme.secondary),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                    child: Text(
                  localStat.stat_name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(),
                ))),
            SizedBox(height: 1.h),
            Container(
                padding: EdgeInsets.all(0.5.h),
                height: 12.h,
                width: 100.w,
                child: Row(
                  children: [
                    Flexible(
                      flex: 8,
                      child: Container(
                          padding: EdgeInsets.all(0.5.h),
                          width: 20.w,
                          height: 10.h,
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            border: Border.all(
                                width: 1,
                                color: Theme.of(context).colorScheme.secondary),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Container(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    "Startzeit",
                                    style: TextStyle(fontSize: 13.sp),
                                  ),
                                ),
                                SizedBox(height: 0.5.h),
                                Text(localStat.startTime)
                              ],
                            ),
                          )),
                    ),
                    Flexible(flex: 1, child: SizedBox(width: 2.w)),
                    Flexible(
                      flex: 8,
                      child: Container(
                        width: 20.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: Colors.red[100],
                          border: Border.all(
                              width: 1,
                              color: Theme.of(context).colorScheme.secondary),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.person,
                            size: 30.sp,
                          ),
                          onPressed: (() {
                            setState(() {
                              sizeOfContainer[index] = !sizeOfContainer[index];
                            });
                          }),
                        ),
                      ),
                    )
                  ],
                )),
          ],
        ),
      );
    }

    Widget moreUserBox(Statistic localStat, int index) {
      return SizedBox(
        height: sizeOfContainer[index] ? 0.h : 22.8.h,
        child: Stack(
          children: [
            Container(
                height: 8.h,
                padding: EdgeInsets.all(0.5.h),
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor.withOpacity(0.4),
                  border: Border.all(
                      width: 1,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.4)),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Center(
                    child: Text(
                  localStat.stat_name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Theme.of(context)
                          .textSelectionColor
                          .withOpacity(0.4)),
                ))),
            Column(
              children: [
                SizedBox(height: 4.h),
                AnimatedSize(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeIn,
                  child: Container(
                    height: sizeOfContainer[index] ? 0.h : 18.8.h,
                    padding: EdgeInsets.all(0.5.h),
                    decoration: BoxDecoration(
                      color: Theme.of(context).backgroundColor,
                      border: Border.all(
                          width: 1,
                          color: Theme.of(context).colorScheme.secondary),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: ListView.separated(
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(height: 1.h);
                      },
                      itemCount: localStat.user.length,
                      padding: EdgeInsets.all(2.sp),
                      itemBuilder: (BuildContext context, int indexR) {
                        return Container(
                            alignment: Alignment.center,
                            padding:
                                EdgeInsets.fromLTRB(1.h, 0.5.h, 1.h, 0.5.h),
                            height: 5.h,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondary,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.sp)),
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                    radius: 10.sp,
                                    backgroundColor:
                                        Theme.of(context).backgroundColor,
                                    child: Icon(
                                      Icons.person,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      size: 12.sp,
                                    )),
                                SizedBox(width: 2.w),
                                Text(
                                  localStat.user[indexR],
                                  style: TextStyle(
                                    color: Theme.of(context).backgroundColor,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ],
                            ));
                      },
                    ),
                  ),
                ),
              ],
            ),
            Container(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    Icons.cancel,
                    size: 3.h,
                  ),
                  onPressed: () {
                    print("sizeOfContainer[" +
                        index.toString() +
                        "] is now " +
                        sizeOfContainer[index].toString());
                    setState(() {
                      sizeOfContainer[index] = !sizeOfContainer[index];
                    });
                  },
                )),
          ],
        ),
      );
    }

    return StreamBuilder(
        stream: currentStream.stream,
        builder: (context, snapshot) {
          return Container(
            padding: EdgeInsets.all(2.h),
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: currentStats.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 22.h,
                    width: 50.w,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border.all(
                          width: 1,
                          color: Theme.of(context).colorScheme.secondary),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: sizeOfContainer[index]
                        ? decoratedBox(currentStats[index], index)
                        : moreUserBox(currentStats[index], index),
                  );
                }),
          );
        });
  }

  _getStatsFromServer() async {
    try {
      List<Statistic> allStats =
          await selectStatements.selectAllRunningStats(company);

      for (int i = 0; i < allStats.length; i++) {
        sizeOfContainer.add(true);
      }
      currentStats = allStats;
      currentStream.add(allStats);
    } catch (Exception) {
      print("Error while getting Data");
    }
  }
}

/*

                                */
