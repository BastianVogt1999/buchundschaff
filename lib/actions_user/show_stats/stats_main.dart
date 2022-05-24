import 'dart:async';
import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/show_stats/popup_edit_stat.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/timer_main.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/delete_statements.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';

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
    }

    widgetBuilded = FutureBuilder(
      builder: (context, snapshot) {
// Checking if future is resolved
        if (snapshot.connectionState == ConnectionState.done) {
// If we got an error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} while getting drinks occured',
                style: TextStyle(fontSize: 18),
              ),
            );

// if we got our data
          } else if (snapshot.hasData) {
// Extracting data from snapshot object
            final data = snapshot.data as List<Statistic>;

            return Scrollbar(
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
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      future: _getStatsFromServer(
          Company("testCompany 2204", "1234"), User("Dieter", "1234", "false")),
    );

    return widgetBuilded;
  }
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
