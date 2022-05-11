import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_admin/UserManagement/all_user.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_admin/UserManagement/user_operations.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/choose_date.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/current_date.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';

class SwitchUserManagement extends StatefulWidget {
  Company company;
  SwitchUserManagement(this.company);
  @override
  _SwitchUserManagementState createState() =>
      _SwitchUserManagementState(company);
}

class _SwitchUserManagementState extends State<SwitchUserManagement>
    with SingleTickerProviderStateMixin {
  Company company;
  _SwitchUserManagementState(this.company);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Padding(padding: EdgeInsets.all(6), child: allUser()));
  }
}
