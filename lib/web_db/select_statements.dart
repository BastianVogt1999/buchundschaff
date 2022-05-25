import "package:intl/intl.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';

class SelectStatements {
  Future<List<Statistic>> selectStatsOfUserOnDate(
      User user, Company company) async {
    List<Statistic> statisticList = <Statistic>[];
    final _formatter = DateFormat('HH:mm:ss');
    final _formatterDate = DateFormat('dd:MM:yyyy');

    String currentTime = _formatter.format(DateTime.now());
    String currentDate = _formatterDate.format(DateTime.now());

    await FirebaseFirestore.instance
        .collection(
            '/AllProjects/' + company.company_name + '/StatisticsInProject')
        .where('date', isEqualTo: currentDate)
        .where('user_name', isEqualTo: user.user_name)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Statistic value = Statistic(
          doc["statistic_id"],
          doc["user_name"],
          doc["startTime"],
          doc["endTime"],
          doc["countedTime"],
          doc["date"],
          doc["isrunning"],
        );
        statisticList.add(value);
      }
    });

    return statisticList;
  }

  Future<Statistic> selectStatOfUserO(User user, Company company) async {
    List<Statistic> statisticList = <Statistic>[];

    await FirebaseFirestore.instance
        .collection(
            '/AllProjects/' + company.company_name + '/StatisticsInProject')
        .where('user_name', isEqualTo: user.user_name)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        print(doc["user_name"]);
        Statistic value = Statistic(
          doc["statistic_id"],
          doc["user_name"],
          doc["startTime"],
          doc["endTime"],
          doc["countedTime"],
          doc["date"],
          doc["isrunning"],
        );
        statisticList.add(value);
      }
    });

    Statistic statFinal = Statistic.empty();
    for (int i = 0; i < statisticList.length; i++) {
      if (statisticList[i].isrunning == "true") {
        statFinal = statisticList[i];
      }
    }

    return statFinal;
  }

  Future<List<User>> selectAllUserOfCompany(Company company) async {
    List<User> userList = <User>[];

    company.company_code = company.company_code.toString();
    company.company_name = company.company_name.toString();

    await FirebaseFirestore.instance
        .collection('/AllProjects/' + company.company_name + '/UserInProject')
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        User value = User(
          doc["user_name"],
          doc["user_code"],
          doc["isAdmin"],
        );
        userList.add(value);
      }
    });

    return userList;
  }
    Future<User> selectOneUserOfCompany(Company company, String user_name) async {
    User user = User.empty();

    await FirebaseFirestore.instance
        .collection('/AllProjects/' + company.company_name + '/UserInProject')
        .where('user_name', isEqualTo: user_name)
        .get()
        .then((QuerySnapshot querySnapshot) {
         
      for (var doc in querySnapshot.docs) {
          user = User(
          doc["user_name"],
          doc["user_code"],
          doc["isAdmin"],
        );
      }
    });
return user;
  }
}

