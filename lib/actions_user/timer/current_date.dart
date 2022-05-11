import 'package:flutter/material.dart';

import "package:intl/intl.dart";

TimeOfDay selectedTime = TimeOfDay.now();

const primaryColor = Color(0xff4338CA);
const accentColor = Color(0xffffffff);

class AutomatedDate extends StatefulWidget {
  SetStartTime settedStartTime;

  AutomatedDate(this.settedStartTime);

  @override
  State<AutomatedDate> createState() => _AutomatedDateState(settedStartTime);
}

class _AutomatedDateState extends State<AutomatedDate> {
  SetStartTime settedStartTime;

  _AutomatedDateState(this.settedStartTime);
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Divider(height: 20),
      Container(
        width: 300,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          color: const Color(0xff2c2c2c),
        ),
        child: Center(
          child: Text(
            "${selectedTime.hour}:${selectedTime.minute}",
            style: TextStyle(
              fontFamily: 'Arial',
              fontSize: 40,
              color: Colors.white,
              height: 1,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      Divider(height: 20),
      SizedBox(
          width: 200.0,
          height: 50.0,
          child: ElevatedButton(
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  alignment: Alignment.center,
                  side: MaterialStateProperty.all(
                      BorderSide(width: 1, color: primaryColor)),
                  padding: MaterialStateProperty.all(const EdgeInsets.only(
                      right: 25, left: 25, top: 0, bottom: 0)),
                  backgroundColor: MaterialStateProperty.all(accentColor),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  )),
              onPressed: () {
                _updateTime();
              },
              child: Text(
                "Aktualisieren",
                style: TextStyle(color: primaryColor, fontSize: 16),
              )))
    ]);
  }

  _updateTime() {
    settedStartTime(DateFormat('HH:mm:ss').format(DateTime.now()));
    setState(() {
      selectedTime = TimeOfDay.now();
    });
  }
}

typedef SetStartTime = void Function(String startTime);
