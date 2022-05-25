import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/intro/rollen_input.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';

class HomeButton extends StatelessWidget {
  final BuildContext context;
  final User user;
  final Company company;
  const HomeButton(this.context, this.user, this.company);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Color(0xEA0091B5),
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => RoleInput( company)));
      },
      child: Icon(
        Icons.home_outlined,
      ),
    );
  }
}
