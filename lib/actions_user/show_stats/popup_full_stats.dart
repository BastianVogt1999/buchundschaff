import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/global_methods.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';

TextEditingController startTimeController = TextEditingController();
TextEditingController endTimeController = TextEditingController();
TextEditingController dateController = TextEditingController();
TextEditingController blankController = TextEditingController();
GlobalMethods globalMethods = GlobalMethods();
const backgroundColor = Color.fromARGB(255, 254, 253, 253);

class FullStats extends StatefulWidget {
  final Statistic statistic;
  const FullStats(this.statistic);

  @override
  State<FullStats> createState() => FullStats_State(statistic);
}

class FullStats_State extends State<FullStats> {
  final Statistic statistic;
  FullStats_State(this.statistic);
  final primaryColor = Color.fromARGB(255, 130, 130, 136);
  final accentColor = const Color(0xffffffff);

  @override
  Widget build(BuildContext context) {
    decoratedTextBox(String text) {
      return Container(
        height: 100,
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width / 2.8,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(width: 2, color: Colors.blueAccent),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Text(text,
            style: TextStyle(fontSize: 25), textAlign: TextAlign.center),
      );
    }

    return Dialog(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: (MediaQuery.of(context).size.width / 1.4) + 15,
        height: MediaQuery.of(context).size.height / 1.3,
        decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(12, 26),
                  blurRadius: 50,
                  spreadRadius: 0,
                  color: Colors.grey.withOpacity(.1)),
            ]),
        child: Container(
            width: MediaQuery.of(context).size.width / 2.8,
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2.8,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      decoratedTextBox("Datum: "),
                      const SizedBox(
                        height: 8,
                      ),
                      decoratedTextBox("Startzeit: "),
                      const SizedBox(
                        height: 8,
                      ),
                      decoratedTextBox("Endzeit: "),
                      const SizedBox(
                        height: 8,
                      ),
                      decoratedTextBox("Gestoppte Zeit: "),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 140,
                        width: MediaQuery.of(context).size.width / 2.8,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          border:
                              Border.all(width: 5, color: Colors.blueAccent),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Text(
                          "User: ",
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(width: 5),
                Container(
                  width: MediaQuery.of(context).size.width / 2.8,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 8,
                      ),
                      decoratedTextBox(statistic.date),
                      const SizedBox(
                        height: 8,
                      ),
                      decoratedTextBox(statistic.startTime),
                      const SizedBox(
                        height: 8,
                      ),
                      decoratedTextBox(statistic.endTime),
                      const SizedBox(
                        height: 8,
                      ),
                      decoratedTextBox(statistic.countedTime != ""
                          ? globalMethods
                              .outputCountedTime(statistic.countedTime)
                          : "..."),
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        height: 140,
                        width: MediaQuery.of(context).size.width / 2.8,
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          border:
                              Border.all(width: 5, color: Colors.blueAccent),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: ListView.builder(
                            itemCount: statistic.user.length,
                            padding: EdgeInsets.all(5),
                            itemBuilder: (BuildContext context, int index) {
                              return Text(
                                statistic.user[index],
                                style: TextStyle(fontSize: 20),
                                textAlign: TextAlign.center,
                              );
                            }),
                      )
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
