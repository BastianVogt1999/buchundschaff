import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';

class InsertStatements {
  void insertNewUser(Company company, User user) {
    var databaseUser = FirebaseFirestore.instance
        .collection('/AllProjects/' + company.company_name + '/UserInProject');

    Random random = Random();
    int userId = random.nextInt(10000);
    databaseUser
        .doc(user.user_name)
        .set(
          {
            'user_name': user.user_name,
            'user_code': userId.toString(),
            'isAdmin': user.is_admin,
          },
        )
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  insertNewCompany(Company company) async {
    var database = FirebaseFirestore.instance.collection('/AllProjects/');

    //generate new Invite Code
    bool codeIsNew = false;

    database.doc(company.company_name).set({
      //doc(project_name).set() -> individuelle ID
      'company_name': company.company_name,

      // 'UserInProject'
    });
  }

  insertNewStatistic(Company company, User user, Statistic statistic) {
    var databaseUser = FirebaseFirestore.instance.collection(
        '/AllProjects/' + company.company_name + '/StatisticsInProject');

    Random random = Random();
    int statisticId = random.nextInt(10000);

    databaseUser
        .doc(statisticId.toString())
        .set(
          {
            'statistic_id': statisticId.toString(),
            'startTime': statistic.startTime,
            'endTime': statistic.endTime,
            'countedTime': statistic.countedTime,
            'date': statistic.date,
            'isrunning': "true",
          },
        )
        .then((value) => print("Stat Added"))
        .catchError((error) => print("Failed to add user: $error"));

    var database = FirebaseFirestore.instance.collection('/AllProjects/' +
        company.company_name +
        '/StatisticsInProject/' +
        statisticId.toString() +
        '/User');

    database.doc(user.user_name).set({
      'user_name': user.user_name,
    });
    return statisticId.toString();
  }
}
