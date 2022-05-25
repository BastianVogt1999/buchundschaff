import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class GlobalMethods{
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

  Widget loadingScreen(){
    return Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: Center(
                    child: Lottie.asset("assets/worker.json"),
                  ),
                )
              ],
            );
  }
}