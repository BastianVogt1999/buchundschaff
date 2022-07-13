import 'dart:async';

import "package:intl/intl.dart";

import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/global_methods.dart';
import 'package:lottie/lottie.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/stopwatchv2.dart';

import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/insert_statements.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/update_statements.dart';

StreamController<UpdateableStatistic> streamController =
    StreamController<UpdateableStatistic>();
Stream stream = streamController.stream.asBroadcastStream();

InsertStatements insertStatements = InsertStatements();
Statistic statistic = Statistic.empty();
UpdateStatements updateStatements = UpdateStatements();
GlobalMethods globalmethods = GlobalMethods();

int doubleChecker = 0;

class Timer_main extends StatefulWidget {
  User user;
  Company company;

  Timer_main(this.user, this.company);

  @override
  State<Timer_main> createState() => _Timer_mainState(user, company);
}

class _Timer_mainState extends State<Timer_main> {
  bool flag = true;
  late Stream<int> timerStream;
  late StreamSubscription<int> timerSubscription;
  User user;
  Company company;

  List<User> currentWorker = [];
  _Timer_mainState(this.user, this.company);

  String timerStart = "00:00:00";
  String startcopy = "00:00:00";
  final _formatter = DateFormat('HH:mm:ss');
  final _formatterDate = DateFormat('dd:MM:yyyy');

  bool firstStarted = true;

List<User> allUser = [];
  @override
  void initState() {
    super.initState();

    stream.listen((UpdateableStatistic) {
      setTimeAtStart(
          UpdateableStatistic.index, UpdateableStatistic.updateableStatistic);
    });
  }

  setStartTime(String startTime) {
    startcopy = startTime;
  }

  setTimeAtStart(int d, Statistic updateableStatistic) async {
    if (d == 1) {
      statistic.endTime = _formatter.format(DateTime.now());
      statistic.date = _formatterDate.format(DateTime.now());
      statistic.countedTime = globalmethods.substractTimeString(
          statistic.startTime, statistic.endTime);

      //  DateTime begin = DateTime.parse(statistic.endTime);

      //final difference = begin.difference(end).inSeconds;
      // statistic.countedTime = difference.toString();
      updateStatements.updateStatisticState(company, user, statistic);
      setState(() {
        timerStart = "00:00:00";
        startcopy = "00:00:00";
      });
    }
    if (d == 0) {
      setState(() {
        timerStart = _formatter.format(DateTime.now());
      });
      timerStart = _formatter.format(DateTime.now());
      /*setState(() {
        if (startcopy == "00:00:00") {
          timerStart = _formatter.format(DateTime.now());
        } else {
          timerStart = startcopy;
        }
      });*/

      statistic.startTime = timerStart;
      statistic.date = _formatterDate.format(DateTime.now());

      if (doubleChecker == 0) {
        statistic.statistic_id =
            insertStatements.insertNewStatistic(company, currentWorker, statistic);

        doubleChecker++;
      }
    }
    statistic.startTime = timerStart;
  }

  @override
  Widget build(BuildContext context) {

 int _value = 1;

if(firstStarted){
    currentWorker.add(user);
    firstStarted = false;
}


  
  showDialogAddWorker(){
   return Dialog(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
       
            boxShadow: [
              BoxShadow(
                  offset: const Offset(12, 26),
                  blurRadius: 50,
                  spreadRadius: 0,
                  color: Colors.grey.withOpacity(.6)),
            ]),
        child: 
    ListView.builder(
          itemCount: allUser.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(

      width: 200,
      child: Column(children: [
      AspectRatio(
        aspectRatio: 208 / 71,
        child: Container(
          decoration: BoxDecoration(boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 4),
                      color: Colors.blue,
                      spreadRadius: 4,
                    )
                ]),
          child: MaterialButton(
            onPressed: () {
              bool userInArray = false;
              for(int i = 0; i< currentWorker.length; i++){
                if(allUser[index].user_name == currentWorker[i].user_name){
                   userInArray = true;
                }
              }
              if(userInArray== false){
                     currentWorker.add(allUser[index]);
                           setState(() {}); 
              }
              else{
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    backgroundColor: Colors.red,
    content: Text("User bereits in Liste"),
    duration: Duration(milliseconds: 2500),
  ));
              }
          

                           
            },
            splashColor: Colors.lightBlue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(36)),
            padding: const EdgeInsets.all(0.0),
          
              child: Container(
                  constraints: const BoxConstraints(
                      minWidth: 88.0,
                      minHeight: 36.0), // min sizes for Material buttons
                  alignment: Alignment.center,
                  child:  Text(allUser[index].user_name,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w300)))),
            ),
          ),
          SizedBox(height:10),
          ],),
        );
      
          }),


  
     
      ),
    );
  }
    Widget addUserDisplay = Container(
      height: 380,
      child: ListView.builder(
          itemCount: currentWorker.length,
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Container(
                    height: 60,
                    color: Colors.white,
                    child: ListTile(
                      leading:     IconButton(
                            iconSize: 40,
                            onPressed: () {
                             // Call this in a function
showDialog<Dialog>(context: context, builder: (BuildContext context) => showDialogAddWorker());

                                },
                            icon: Icon(Icons.add_circle),
                            color: Colors.green,
                          ),
                      title: Row(children: [Text(currentWorker[index].user_name),
                      SizedBox(width: 10),
                    ]),
                      trailing: 
                          IconButton(
                            iconSize: 30,
                            onPressed: () {
                              currentWorker.removeAt(index);
                              setState(() {});
                            },
                            icon: Icon(Icons.delete),
                             color: Colors.red,
                          ),
            
                    ),
                ),
                SizedBox(height: 10),
              ],
            );
          }),
    );

    return FutureBuilder(
        future: _getStatsFromServer(user, company),
        builder: (context, dataSnapshot) {
    List<Widget> children;
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return globalmethods.loadingScreen();
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occured'),
              );
            } else {
              final data = dataSnapshot.data as Statistic;
              return SizedBox(
                height: double.infinity,
                child: Column(children: [
                  Divider(height: 20),
                  FutureBuilder(
        future: selectStatements.selectAllUserOfCompany(company),
        builder: (context, dataSnapshot) {

          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return globalmethods.loadingScreen();
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occured'),
              );
            } else {
              allUser = dataSnapshot.data as List<User>;
              return addUserDisplay;
            }}}),
                  Divider(height: 20),
                  SizedBox(
                      height: 80,
                      child: Scaffold(
                          body: Center(
                              child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Startzeit',
                            style: TextStyle(fontSize: 25),
                          ),
                          Text(
                            timerStart,
                            style: TextStyle(fontSize: 30),
                          )
                        ],
                      )))),
                  SizedBox(
                    height: 150,
                    child: StopwatchPage(streamController, user, company, data),
                  ),
                ]),
              );
            }
          }
        });
  }
}

_getStatsFromServer(User user, Company company) async {
  try {
    Statistic stat = await selectStatements.selectStatOfUserO(user, company);

    return stat;
  } catch (Exception) {
    print("Error while getting Data");
  }
}
