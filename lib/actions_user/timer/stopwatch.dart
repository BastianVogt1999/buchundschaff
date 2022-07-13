import 'dart:async';
import 'package:flutter/material.dart';
class BySetState extends StatefulWidget {
  @override
  _BySetStateState createState() => _BySetStateState();
}
class _BySetStateState extends State<BySetState> {
  int _counter = 10;
  late Timer _timer;
  void _startTimer() {
    _counter = 10;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
      } else {
        _timer.cancel();
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Count Down Timer using SetState to keep updating'),
            SizedBox(
              height: 20,
            ),
            Text(
              '$_counter',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  _startTimer();
                },
                child: Text('Start Timer')),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  _timer.cancel();
                },
                child: Text('Pause')),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    _timer.cancel();
                    _counter = 10;
                  });
                },
                child: Text('Reset'))
          ],
        ),
      ),
    );
  }
}