import 'dart:async';

import "package:intl/intl.dart";
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/stopwatch.dart';
import 'package:itm_ichtrinkmehr_flutter/global_methods.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';
import 'package:lottie/lottie.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/stopwatchv2.dart';

import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/insert_statements.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/update_statements.dart';


InsertStatements insertStatements = InsertStatements();
Statistic statistic = Statistic.empty();
UpdateStatements updateStatements = UpdateStatements();
SelectStatements selectStatements = SelectStatements();
GlobalMethods globalmethods = GlobalMethods();
bool timeAlreadyRunning = false;
int doubleChecker = 0;
 bool running = false;


class IconValues {
  IconData icon_value;
  int itemIndex;

  Color color;
  IconValues(this.icon_value, this.itemIndex, this.color);
}


class Timer_main extends StatefulWidget {
  User user;
  Company company;

  Timer_main(this.user, this.company);

  @override
  State<Timer_main> createState() => _Timer_mainState(user, company);
}

class _Timer_mainState extends State<Timer_main> {

  User user;
  Company company;


  List<User> currentWorker = [];
  _Timer_mainState(this.user, this.company);

  String timerStart = "00:00:00";
  String startcopy = "00:00:00";
  final _formatterDate = DateFormat('dd:MM:yyyy');

  bool firstStarted = true;
     

  final _formatter = DateFormat('HH:mm:ss');
    var StartTime = 0;
  var NowTime = 0;
late StopWatchTimer _stopWatchTimer;
 var displayTime = "00:00:00";


List<User> allUser = [];

 @override
  void initState() {
    _stopWatchTimer = StopWatchTimer(
  mode: StopWatchMode.countUp,
  onChange: (value) => displayTime = StopWatchTimer.getDisplayTime(value),
  onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
  onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
);
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();  // Need to call dispose function.
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
      /*setState(() {
        timerStart = "00:00:00";
        startcopy = "00:00:00";
      });*/

      doubleChecker = 0;
    }
    else if (d == 0) {

      timerStart = _formatter.format(DateTime.now());
      /*setState(() {
        if (startcopy == "00:00:00") {
          timerStart = _formatter.format(DateTime.now());
        } else {
          timerStart = startcopy;
        }
      });*/
      if (startcopy == "00:00:00") {
          timerStart = _formatter.format(DateTime.now());
        } else {
          timerStart = startcopy;
        }

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
   
    timeAlreadyRunning = false;
  
  String formatTime(String formatTime){
    int time = int.parse(formatTime);
    if(time<=60){
      int seconds = time%60;
      if(seconds.toString().length > 1){
return "00:00"+ ":"+formatTime;
      }
      else{
        return "00:00"+ ":0"+formatTime;
      }
      
    }
    else if(time<=3600){
      int minute = time~/60;
      int seconds = time%60;
      if(minute.toString().length > 1 && seconds.toString().length > 1){
return "00:"+ minute.toString() + ":" + seconds.toString();
      }
      else if(minute.toString().length == 1 && seconds.toString().length > 1){
return "00:0"+ minute.toString() + ":" + seconds.toString();
      }
         else if(minute.toString().length > 1 && seconds.toString().length == 1){
return "00:"+ minute.toString() + ":0" + seconds.toString();
      }
      else{
        return "00:"+ minute.toString() + ":" + seconds.toString();
      }
      
    }
    else if(time>3600){
       int minute = time~/3600;
      int seconds = time%3600;
      int hours = time~/60;

      return hours.toString() + ":" + minute.toString() + ":" + seconds.toString();
    }
    return "";
    
  }
    var DiffTime =
        DateTime.fromMillisecondsSinceEpoch(NowTime - StartTime).toUtc();

    //if Timer is already running
    
    /* if (statisticInput.isrunning != "") {
      buttonIndex = 1;
      setState(() {
        buttonIndex = 1;
      });
    }
    else{
       buttonIndex = 0;
      setState(() {
        buttonIndex = 0;
      });
    }*/

  
 int _value = 1;

if(firstStarted){
    currentWorker.add(user);
    firstStarted = false;
}
    _StartStopButton(Statistic statistic) {
      //switch button index: 0 (not running)

      if (!running) {
        
        print("Timer started");
       setState(() {

        //Veränderung Button

         running = true;
        });
        //Veränderung Text-Status
      setState(() {  
          StartTime = DateTime.now().millisecondsSinceEpoch.toInt();
          NowTime = DateTime.now().millisecondsSinceEpoch.toInt();
          
        });
      _stopWatchTimer.onExecute.add(StopWatchExecute.start);
        setTimeAtStart(0, statistic);
      } else {
        print("Timer stopped");
        //Veränderung Button
        
        setState(() {

        //Veränderung Text-Status
        running = false;
          
          StartTime = 0;
          NowTime = 0;
        });
     _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
     _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
       setTimeAtStart(1, statistic);
      }
    }

       Widget buttonWidget() {
      return Container(
        color: running ? Color.fromARGB(255, 241, 151, 151) : Color.fromARGB(255, 229, 241, 233),
        height: 50, width: MediaQuery.of(context).size.width, child:
      GestureDetector(
        onTap: 
            () {
          _StartStopButton(statistic);
        },
        child: Icon(
          running ? Icons.stop_circle : Icons.play_circle_fill,
          size: 45,
          color: running ? Colors.red : Colors.green,
        ),
      ));
    }


  
  showDialogAddWorker(){
   return Dialog(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        height: MediaQuery.of(context).size.height / 2.2,
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

      width: MediaQuery.of(context).size.width,
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
      height: MediaQuery.of(context).size.height / 2.6,
      child: 
   
             ListView.builder(
          itemCount: currentWorker.length,
          itemBuilder: (BuildContext context, int index) {
            return SingleChildScrollView(child:
            Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height /13,
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
                              setState(() {currentWorker = currentWorker;});
                            },
                            icon: Icon(Icons.delete),
                             color: Colors.red,
                        ),
            
                    ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height/ 30),
              ],
            ));
          }));
           

Widget stopWatch(){
            return  FutureBuilder(
        future: _getStatsFromServer(user, company),
        builder: (context, dataSnapshot) {

          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Container();
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occured'),
              );
            } else {
          
                  return      SizedBox(
                    height: 150,
                    child:  Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
      StreamBuilder<int>(
  stream: _stopWatchTimer.secondTime,
  initialData: 0,
  builder: (context, snap) {
    final value = snap.data;
    print('Listen every minute. $value');
    return Column(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
              
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    formatTime(value.toString()),
                    
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'Helvetica',
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            )
        ),
      ],
    );
  },
),
        SizedBox(height: 10),

        
      ],
    )
                  );
                 }}});
}

//main Frontend

              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(children: [
                  Divider(height: 20),
    addUserDisplay,
                  Divider(height: 20),
                  SizedBox(
                      height: MediaQuery.of(context).size.height / 8,
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
                          
        stopWatch(),
          buttonWidget(),
                ]),
              );
            }

_getStatsFromServer(User user, Company company) async {
  try {
    Statistic stat = await selectStatements.selectStatOfUserO(user, company);
    allUser = await selectStatements.selectAllUserOfCompany(company);
    if(stat.isrunning == "true"){}
    timeAlreadyRunning = true;

  } catch (Exception) {
    print("Error while getting Data");
  }
}
}