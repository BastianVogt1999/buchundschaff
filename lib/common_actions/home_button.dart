import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/intro/rollen_input.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:sizer/sizer.dart';

WhiteMode whiteMode = WhiteMode();

class HomeButton extends StatelessWidget {
  final BuildContext context;

  final Company company;
  const HomeButton(this.context, this.company);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RoleInput(company.company_code)));
      },
      label: const Text("User-Menü"),
      icon: const Icon(
        Icons.logout,
      ),
    );
  }
}
