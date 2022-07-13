import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/delete_statements.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';

SelectStatements selectStatements = SelectStatements();
DeleteStatements deleteStatements = DeleteStatements();

class FullStatsAdmin extends StatefulWidget {
  FullStatsAdmin(this.user, this.company);
  User user;
  Company company;
  @override
  State<FullStatsAdmin> createState() => _FullStatsAdminState(user, company);
}

class _FullStatsAdminState extends State<FullStatsAdmin> {
  User user;
  Company company;

  _FullStatsAdminState(this.user, this.company);
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
      Color color = const Color(0xFF4338CA);
      return Card(
        child: ListTile(
            title: Column(children: [
              Text("Datum: " + statistic.date),
              Divider(),
              Text("Name: " + user.user_name),
              Divider(),
              Text("Uhrzeit: " + statistic.startTime),
              Divider(),
              Text("Kommentar: " + statistic.endTime),
            ]),
            trailing: IconButton(
              onPressed: () {
                deleteStatistic(company, user, statistic);
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
    List<Statistic> allDrinks = await selectStatements.selectAllStats(company);

    return allDrinks;
  } catch (Exception) {
    print("Error while getting Data");
  }
}

deleteStatistic(Company company, User user, Statistic statistic) {
  deleteStatements.deleteStatistic(company, user, statistic);
}
