import 'dart:async';
import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/show_stats/popup_edit_stat.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/timer_main.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/delete_statements.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';
import 'package:lottie/lottie.dart';

SelectStatements selectStatements = SelectStatements();
DeleteStatements deleteStatements = DeleteStatements();

class Stats_main extends StatefulWidget {
  final User user;
  final Company company;
  const Stats_main(this.user, this.company, {Key? key}) : super(key: key);

  @override
  State<Stats_main> createState() => _Stats_mainState(user, company);
}

class _Stats_mainState extends State<Stats_main> {
  User user;
  Company company;

  _Stats_mainState(this.user, this.company);

  Widget widgetBuilded = Container();
  updateWidget() {
    setState(() {
      widgetBuilded = widgetBuilded;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget CustomListTile(
      User user,
      Company company,
      Statistic statistic,
    ) {
<<<<<<< HEAD
      Color color = const Color(0xFF4338CA);
      return Container(
          height: 80,
          color: Colors.white,
          child: Row(children: [
            SizedBox(
                width: (MediaQuery.of(context).size.width / 10) * 3,
                child: Center(
                    child: Column(children: const [
                  SizedBox(height: 5),
                  Text(
                    "Startzeit: ",
                    textScaleFactor: 1,
                  ),
                  Text(
                    "Stoppzeit: ",
                    textScaleFactor: 1,
                  ),
                  Text(
                    "Zeitspanne: ",
                    textScaleFactor: 1,
                  )
                ]))),
            SizedBox(
                width: (MediaQuery.of(context).size.width / 10) * 2,
                child: Center(
                    child: Column(children: [
                  SizedBox(height: 5),
                  Text(
                    statistic.startTime,
                    textScaleFactor: 1,
                  ),
                  Text(
                    statistic.endTime,
                    textScaleFactor: 1,
                  ),
                  Text(
                    statistic.countedTime,
                    textScaleFactor: 1,
                  )
                ]))),
            SizedBox(
                width: (MediaQuery.of(context).size.width / 10) * 4,
                child: Row(children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.amber,
                    child: IconButton(
                        color: Colors.black,
                        padding: const EdgeInsets.all(2),
                        iconSize: 20,
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          print("edit");
                        }),
                  ),
                  SizedBox(width: 10),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.amber,
                    child: IconButton(
                        color: Colors.black,
                        padding: const EdgeInsets.all(2),
                        iconSize: 20,
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          deleteStatements.deleteStatistic(
                              company, user, statistic);
               
                          updateWidget();
                        }),
                  ),
                  SizedBox(width: 10),
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.amber,
                    child: IconButton(
                        color: Colors.black,
                        padding: const EdgeInsets.all(2),
                        iconSize: 20,
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          showDialog<Dialog>(
                              context: context,
                              builder: (BuildContext context) =>
                                  EditStats(statistic, user, company));
       
                        }),
                  ),
                ]))
          ]));
=======
      Color color = Color(0xFF4338CA);
      return Card(
        child: ListTile(
            title: Column(children: [
              Text("Datum: " + statistic.date),
              Divider(),
              Text("Startzeit: " + statistic.startTime),
              Divider(),
              Text("Endzeit: " + statistic.endTime),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("User: "),
                  SizedBox(
                      height: 80,
                      width: 150,
                      child: ListView.builder(
                          itemCount: statistic.user.length,
                          padding: EdgeInsets.all(5),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                padding: EdgeInsets.all(5),
                                child: Text((index + 1).toString() +
                                    " " +
                                    statistic.user[index]));
                          }))
                ],
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Timer läuft: "),
                  Icon(statistic.isrunning == "true"
                      ? Icons.check_box
                      : Icons.close_rounded),
                ],
              ),
            ]),
            trailing: IconButton(
              onPressed: () {
                deleteStatements.deleteStatistic(company, user, statistic);
                updateWidget();
              },
              icon: Icon(Icons.more_vert),
            )),
        elevation: 8,
        shadowColor: Colors.green,
        margin: EdgeInsets.all(20),
        shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.green, width: 1)),
      );
>>>>>>> 27790788245379a6295b935cd9163d19b8a8c097
    }

    widgetBuilded = FutureBuilder(
        future: _getStatsFromServer(company, user),
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

                  final data = dataSnapshot.data as List<Statistic>;
    return  Scrollbar(
                child: ListView.builder(
                    itemCount: data.length,
                    padding: EdgeInsets.all(5),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          padding: EdgeInsets.all(5),
                          child: CustomListTile(
                            user,
                            company,
                            data[index],
                          ));
                    }));
            }
          }
        });
      
    

    return widgetBuilded;
  
}

_getStatsFromServer(
  Company company,
  User user,
) async {
  try {
    List<Statistic> allDrinks =
        await selectStatements.selectStatsOfUserOnDate(user, company);


    return allDrinks;
  } catch (Exception) {
    print("Error while getting Data");
  }
}

deleteStatistic(User user, Statistic statistic, BuildContext context) {}

}


