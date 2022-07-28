import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';

SelectStatements selectStatements = SelectStatements();

class DeleteStatements {
  deleteStatistic(Company company, UserBuS user, Statistic statistic) async {
    List<String> allUserInStat = await selectStatements.selectUserOfStat(
        statistic.statistic_id, company);

    var database = FirebaseFirestore.instance.collection('/AllProjects/' +
        company.company_name +
        '/StatisticsInProject' +
        statistic.statistic_id +
        "User");

    for (int i = 0; i < allUserInStat.length; i++) {
      database
          .doc(allUserInStat[i])
          .delete()
          .catchError((error) => print("Failed to delete Statistic : $error"));
    }

    database = FirebaseFirestore.instance.collection(
        '/AllProjects/' + company.company_name + '/StatisticsInProject');

    database
        .doc(statistic.statistic_id)
        .delete()
        .catchError((error) => print("Failed to delete Statistic : $error"));
  }

  deleteUser(Company company, UserBuS user) {
    var database = FirebaseFirestore.instance
        .collection('/AllProjects/' + company.company_name + '/UserInProject');
    database
        .doc(user.user_code)
        .delete()
        .catchError((error) => print("Failed to delete User: $error"));
  }

  deleteCompany(Company company) {
    var database = FirebaseFirestore.instance.collection('/AllProjects/');
    database
        .doc(company.company_name)
        .delete()
        .catchError((error) => print("Failed to delete Company: $error"));
  }
}
