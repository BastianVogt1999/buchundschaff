import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/insert_statements.dart';

InsertStatements insertStatements = InsertStatements();

class StartStopValues {
  Icon icon;
  String name;
  int index;

  StartStopValues({
    required this.icon,
    required this.name,
    required this.index,
  });
}

class StartStop extends StatefulWidget {
  StartStop({required this.startTimer});

  StartStopTimer startTimer;

  @override
  State<StartStop> createState() {
    return StartStopState(startTimer);
  }
}

class StartStopState extends State<StartStop> {
  int selectedIndex = 0;

  switchWidgets(int index) {
    startTimer(index);
    setState(
      () {
        if (selectedIndex == 0) {
          selectedIndex = 1;
        } else {
          selectedIndex = 0;
        }
      },
    );
  }

  List<StartStopValues> startStopWidgets = [
    StartStopValues(
        icon: Icon(Icons.play_arrow_outlined), name: "Start", index: 0),
    StartStopValues(
        icon: const Icon(Icons.stop_circle_outlined), name: "Stop", index: 1),
  ];

  StartStopState(this.startTimer);

  final StartStopTimer startTimer;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: GestureDetector(
      child: Container(
        decoration: BoxDecoration(color: Colors.green),
        width: 200,
        height: 50,
        child: Row(
          children: [
            Text(
              startStopWidgets[selectedIndex].name,
              textAlign: TextAlign.center,
            ),
            startStopWidgets[selectedIndex].icon
          ],
        ),
      ),
      onTap: () {
        switchWidgets(startStopWidgets[selectedIndex].index);
      },
    ));
  }
}

typedef StartStopTimer = void Function(int indexTimer);
