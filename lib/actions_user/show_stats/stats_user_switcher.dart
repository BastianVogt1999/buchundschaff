import 'dart:async';

import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/show_stats/pick_user.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/show_stats/stats_main.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';

StreamController<UserBuS> streamControllerUserInput =
    StreamController<UserBuS>();
Stream stream = streamControllerUserInput.stream.asBroadcastStream();

class StateUserSwitcher extends StatefulWidget {
  Company company;
  StateUserSwitcher(this.company, {Key? key}) : super(key: key);

  @override
  State<StateUserSwitcher> createState() => _StateUserSwitcherState(company);
}

class _StateUserSwitcherState extends State<StateUserSwitcher> {
  Company company;
  bool shown_user = true;
  UserBuS userR = UserBuS.empty();

  _StateUserSwitcherState(this.company);

  @override
  initState() {
    super.initState();

    stream.listen((UserBuS) {
      switchToStats(UserBuS);
    });
  }

  switchToStats(UserBuS user) {
    print("checle");
    setState(() {
      userR = user;
      shown_user;
      shown_user = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("loaded");
    return Container(
        child: shown_user
            ? PickUser(company, stream, streamControllerUserInput)
            : Stats_main(company, userR));
  }
}
