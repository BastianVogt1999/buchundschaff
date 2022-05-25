import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/timer_main.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';

class DeleteStatements {
  deleteStatistic(Company company, User user, Statistic statistic) {
    var database = FirebaseFirestore.instance.collection(
        '/AllProjects/' + company.company_name + '/StatisticsInProject');


    database
        .doc(statistic.statistic_id)
        .delete()
        .catchError((error) => print("Failed to delete Statistic : $error"));
  }

  deleteUser(Company company, User user) {
    var database = FirebaseFirestore.instance.collection(
        '/AllProjects/' + company.company_name + '/UserInProject');
    database
        .doc(user.user_name)
        .delete()
        .catchError((error) => print("Failed to delete User: $error"));
  }

    deleteCompany(Company company) {
    var database = FirebaseFirestore.instance.collection(
        '/AllProjects/');
    database
        .doc(company.company_name)
        .delete()
        .catchError((error) => print("Failed to delete Company: $error"));
  }
}
