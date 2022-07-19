import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/timer_main.dart';
import 'package:itm_ichtrinkmehr_flutter/global_methods.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';

GlobalMethods globalmethods = GlobalMethods();

class UpdateStatements {
  updateStatisticState(Company company, User user, Statistic statistic) {
    var database = FirebaseFirestore.instance.collection(
        '/AllProjects/' + company.company_name + '/StatisticsInProject');

    database.doc(statistic.statistic_id).update(
      {
        'countedTime': statistic.countedTime,
        'endTime': statistic.endTime,
        'isrunning': "false",
      },
    ).catchError((error) => print("Failed to update drink: $error"));
  }

  updateStatistic(Company company, Statistic statistic) {
    var database = FirebaseFirestore.instance.collection(
        '/AllProjects/' + company.company_name + '/StatisticsInProject');

    statistic.countedTime = globalmethods.substractTimeString(
        statistic.startTime, statistic.endTime);
    database.doc(statistic.statistic_id).update(
      {
        'countedTime': statistic.countedTime,
        'date': statistic.date,
        'startTime': statistic.startTime,
        'endTime': statistic.endTime,
      },
    ).catchError((error) => print("Failed to update statistic: $error"));
  }

  updateUser(Company company, User user) {
    var database = FirebaseFirestore.instance
        .collection('/AllProjects/' + company.company_name + '/UserInProject');

    database.doc(user.user_name).update(
      {
        'user_name': user.user_name,
      },
    ).catchError((error) {
      print("Failed to update user: $error");
      return "1"; //if Operation failed
    });

    return "0"; //if Operation successful
  }

  updateUserAdminRight(Company company, User user) {
    var database = FirebaseFirestore.instance
        .collection('/AllProjects/' + company.company_name + '/UserInProject');

    if (user.is_admin == "true") {
      database.doc(user.user_name).update(
        {
          'isAdmin': "false",
        },
      ).catchError((error) {
        print("Failed to update user: $error");
      });
    } else {
      database.doc(user.user_name).update(
        {
          'isAdmin': "true",
        },
      ).catchError((error) {
        print("Failed to update user: $error");
      });
    }
  }
}
