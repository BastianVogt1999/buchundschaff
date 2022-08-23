import 'dart:async';

import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';
import 'package:sizer/sizer.dart';

import '../../values/company.dart';
import '../../values/user.dart';

SelectStatements selectStatements = SelectStatements();

class RunningProjects extends StatefulWidget {
  RunningProjects(this.company, this.user, {Key? key}) : super(key: key);
  Company company;
  UserBuS user;

  @override
  State<RunningProjects> createState() => _RunningProjectsState(company, user);
}

class _RunningProjectsState extends State<RunningProjects> {
  List<Statistic> running_projects = [];
  Company company;
  UserBuS user;
  _RunningProjectsState(this.company, this.user);

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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: currentStream.stream,
        builder: (context, snapshot) {
// Checking if future is resolved
          return snapshot.hasData
              ? Container(
                  padding: EdgeInsets.all(2.h),
                  child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 1.h),
                      itemCount: running_projects.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                            child: Text(running_projects[index].countedTime));
                      }))
              : const Center(
                  child: CircularProgressIndicator(),
                );
        });
  }

  _getStatsFromServer() async {
    try {
      List<Statistic> allStats =
          await selectStatements.selectAllRunningStats(company);

      currentStream.add(allStats);
      running_projects = allStats;
    } catch (Exception) {
      print("Error while getting Data");
    }
  }
}
