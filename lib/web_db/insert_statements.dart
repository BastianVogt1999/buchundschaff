import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';

import '../values/company_access.dart';
import '../values/message.dart';

class InsertStatements {
  void insertNewUser(Company company, UserBuS user) {
    var databaseUser = FirebaseFirestore.instance
        .collection('/AllProjects/' + company.company_name + '/UserInProject');

    Random random = Random();
    int userId = random.nextInt(10000);
    databaseUser
        .doc(userId.toString())
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

  insertNewStatistic(
      Company company, List<UserBuS> userList, Statistic statistic) {
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
            'stat_name': statistic.stat_name,
          },
        )
        .then((value) => print("Stat Added"))
        .catchError((error) => print("Failed to add user: $error"));

    var database = FirebaseFirestore.instance.collection('/AllProjects/' +
        company.company_name +
        '/StatisticsInProject/' +
        statisticId.toString() +
        '/User');

    for (int i = 0; i < userList.length; i++) {
      print(userList[i].user_name);
      database.doc(userList[i].user_name).set({
        'user_name': userList[i].user_name,
      });
    }
    return statisticId.toString();
  }

  void insertNewMessage(Company company, Message message) {
    var databaseUser = FirebaseFirestore.instance
        .collection('/AllProjects/' + company.company_name + '/Messages');

    Random random = Random();
    int messageId = random.nextInt(10000);
    databaseUser
        .doc(messageId.toString())
        .set(
          {
            'message_id': messageId.toString(),
            'user_name': message.user_name,
            'message_text': message.message_text,
            'date': message.date,
            'time': message.time,
          },
        )
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  insertNewCompanyAccess(CompanyAccess companyAccess) {
    var database = FirebaseFirestore.instance.collection('/Company_accesses/');

    database
        .doc()
        .set(
          {
            'company_name': companyAccess.company_name,
            'company_connection': companyAccess.company_connection,
            'mail_address': companyAccess.mail_address,
            'number_of_user': companyAccess.number_of_user,
            'is_authentificated': companyAccess.is_authentificated,
          },
        )
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }
}
