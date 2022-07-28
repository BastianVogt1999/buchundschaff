import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/intro/rollen_input.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:sizer/sizer.dart';

WhiteMode whiteMode = WhiteMode();

class HomeButton extends StatelessWidget {
  final BuildContext context;
  final User user;
  final Company company;
  const HomeButton(this.context, this.user, this.company);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: whiteMode.abstractColor,
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => RoleInput(company)));
      },
      child: Icon(
        Icons.logout,
      ),
    );
  }
}
