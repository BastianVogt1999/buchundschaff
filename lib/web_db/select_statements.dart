import "package:intl/intl.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/timer_main.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/message.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';

class SelectStatements {

  Future<List<String>> selectUserOfStat(String statistic_id, Company company ) async {
    List<String> userList = <String>[];

      await FirebaseFirestore.instance.collection(
        '/AllProjects/' + company.company_name + '/StatisticsInProject' + statistic_id + "User")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        
        userList.add(doc["user_name"]);
      }
    });

    return userList;
  }


  Future<Company> selectCompany(String companyCode) async {
        Company company = Company.empty();

    await FirebaseFirestore.instance
        .collection('/AllProjects/' + company.company_name)
        .where('company_code', isEqualTo: companyCode)
        .get()
        .then((QuerySnapshot querySnapshot) {
         
      for (var doc in querySnapshot.docs) {
          company = Company(
          doc["company_name"],
          doc["company_code"],

        );
      }
    });
return company;
  }
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
        //  .where('user_name', isEqualTo: user.user_name)
        .get()
        .then((QuerySnapshot querySnapshot) async {
      for (var doc in querySnapshot.docs) {
        Statistic value = Statistic.empty();
        value.date = doc["date"];
        value.statistic_id = doc["statistic_id"];
        value.startTime = doc["startTime"];
        value.endTime = doc["endTime"];
        value.countedTime = doc["countedTime"];
        value.isrunning = doc["isrunning"];

        List<String> users = <String>[];

        await FirebaseFirestore.instance
            .collection('/AllProjects/' +
                company.company_name +
                '/StatisticsInProject/' +
                value.statistic_id +
                "/User")
            .get()
            .then((QuerySnapshot insideSnapshot) {
          for (var docS in insideSnapshot.docs) {
            String curValue = docS["user_name"];
            users.add(curValue);
          }
        });
        value.user = users;
        statisticList.add(value);
      }
    });

    return statisticList;
  }

  Future<List<Statistic>> selectAllStats(Company company) async {
    List<Statistic> statisticList = <Statistic>[];

    await FirebaseFirestore.instance
        .collection(
            '/AllProjects/' + company.company_name + '/StatisticsInProject')
        .orderBy("startTime")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Statistic value = Statistic.empty();
        value.date = doc["date"];
        value.statistic_id = doc["statistic_id"];
        value.startTime = doc["startTime"];
        value.endTime = doc["endTime"];
        value.countedTime = doc["countedTime"];
        value.isrunning = doc["isrunning"];

        List<String> users = <String>[];
        FirebaseFirestore.instance
            .collection('/AllProjects/' +
                company.company_name +
                '/StatisticsInProject/' +
                value.statistic_id +
                "/User")
            .get()
            .then((QuerySnapshot insideSnapshot) {
          for (var docS in insideSnapshot.docs) {
            users.add(docS["user_name"]);
          }
          value.user = users;
        });
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
        .where('isrunning', isEqualTo: "true")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Statistic value = Statistic.empty();
        value.statistic_id = doc["statistic_id"];
        value.date = doc["date"];
        value.startTime = doc["startTime"];
        value.endTime = doc["endTime"];
        value.countedTime = doc["countedTime"];
        value.isrunning = doc["isrunning"];

        List<String> users = <String>[];
        FirebaseFirestore.instance
            .collection('/AllProjects/' +
                company.company_name +
                '/StatisticsInProject/' +
                value.statistic_id +
                "/User")
            .get()
            .then((QuerySnapshot insideSnapshot) {
          for (var doc in insideSnapshot.docs) {
            print("Schnitzel");
            users.add(doc["user_name"]);
          }
          value.user = users;
        });
        statisticList.add(value);
      }
    });

    Statistic statFinal = Statistic.empty();
    for (int i = 0; i < statisticList.length; i++) {
      for (int j = 0; j < statisticList[i].user.length; j++) {
        if (statisticList[i].user[j] == user.user_name) {
          statFinal = statisticList[i];
        }
      }
    }

    print("run " + statFinal.isrunning);
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
    Future<User> selectOneUserOfCompany(Company company, String user_code) async {
    User user = User.empty();

    await FirebaseFirestore.instance
        .collection('/AllProjects/' + company.company_name + '/UserInProject')
        .where('user_code', isEqualTo: user_code)
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

  Future<List<Message>> selectAllMessages(Company company) async {
    List<Message> messageList = <Message>[];

    await FirebaseFirestore.instance
        .collection(
            '/AllProjects/' + company.company_name + '/Messages')
        .orderBy("time")
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        Message value = Message.empty();
        value.message_id= doc["message_id"];
        value.user_name = doc["user_name"];
        value.message_text = doc["message_text"];
        value.date = doc["date"];
        value.time = doc["time"];

        messageList.add(value);
      }
    });

    return messageList;
  }
  
}

