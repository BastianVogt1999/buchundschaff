import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GlobalMethods {
  String substractTimeString(String startTime, String endTime) {
    String result = "";

    List<String> startTimeArrayString = startTime.split(":");
    List<String> endTimeArrayString = endTime.split(":");

    List<int> startTimeArrayInt = <int>[];
    List<int> endTimeArrayInt = <int>[];

//parse all String to int
    for (int i = 0; i < 3; i++) {
      startTimeArrayInt.add(int.parse(startTimeArrayString[i]));
      endTimeArrayInt.add(int.parse(endTimeArrayString[i]));
    }

//substract Seconds

    int seconds = endTimeArrayInt[2] - startTimeArrayInt[2];

    int minutes = (endTimeArrayInt[1] - startTimeArrayInt[1]) * 60;

    int hours = (endTimeArrayInt[0] - startTimeArrayInt[0]) * 3600;

    if (seconds < 0) {
      seconds = seconds + 60;
      minutes - 1;
    }
    if (minutes < 0) {
      minutes = minutes + 60;
      hours - 1;
    }
    if (hours < 0) {
      hours = 0;
    }

    result = (seconds + minutes + hours).toString();
    return result;
  }

  Widget loadingScreen(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.width / 2 - 50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Center(
                child: Lottie.asset("assets/worker.json"),
              ),
            )
          ],
        ));
  }

  String outputCountedTime(String input) {
    int time = int.parse(input);
    if (time <= 60) {
      int seconds = time % 60;
      if (seconds.toString().length > 1) {
        return "00:00" + ":" + input;
      } else {
        return "00:00" + ":0" + input;
      }
    } else if (time <= 3600) {
      int minute = time ~/ 60;
      int seconds = time % 60;
      if (minute.toString().length > 1 && seconds.toString().length > 1) {
        return "00:" + minute.toString() + ":" + seconds.toString();
      } else if (minute.toString().length == 1 &&
          seconds.toString().length > 1) {
        return "00:0" + minute.toString() + ":" + seconds.toString();
      } else if (minute.toString().length > 1 &&
          seconds.toString().length == 1) {
        return "00:" + minute.toString() + ":0" + seconds.toString();
      } else {
        return "00:" + minute.toString() + ":" + seconds.toString();
      }
    } else if (time > 3600) {
      int minute = time ~/ 3600;
      int seconds = time % 3600;
      int hours = time ~/ 60;

      return hours.toString() +
          ":" +
          minute.toString() +
          ":" +
          seconds.toString();
    }
    return "";
  }

  double getSizeOfPage(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}
