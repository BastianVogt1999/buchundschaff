import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:sizer/sizer.dart';
import '../values/company.dart';

WhiteMode whiteMode = WhiteMode();

class Settings extends StatefulWidget {
  Settings(this.user, this.company, {Key? key}) : super(key: key);
  UserBuS user;
  Company company;
  @override
  State<Settings> createState() => _SettingsState(user, company);
}

class _SettingsState extends State<Settings> {
  bool blackMode = false;
  UserBuS user;
  Company company;

  _SettingsState(
    this.user,
    this.company,
  );

  @override
  Widget build(BuildContext context) {
    Widget settingsRow(bool checked, String text) {
      return Container(
        width: 80.w,
        height: 8.h,
        decoration: BoxDecoration(
          color: whiteMode.cardColor.withOpacity(0.6),
          border: Border.all(width: 1, color: whiteMode.abstractColor),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: ListTile(
          onTap: () {
            setState(() {
              if (checked) {
                checked = false;
              } else {
                checked = true;
              }
            });
          },
          title: Text(
            text,
            style: const TextStyle(fontSize: 20),
          ),
          trailing: Icon(checked ? Icons.crop_square_sharp : Icons.check_box),
        ),
      );
    }

    return Container(
        padding: EdgeInsets.all(2.h),
        child: Column(
          children: [
            Container(
              width: 80.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: whiteMode.cardColor.withOpacity(0.6),
                border: Border.all(width: 1, color: whiteMode.abstractColor),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: ListTile(
                onTap: () {
                  setState(() {
                    if (blackMode) {
                      blackMode = false;
                    } else {
                      blackMode = true;
                    }
                  });
                },
                title: const Text(
                  "Farbe switchen",
                  style: TextStyle(fontSize: 20),
                ),
                trailing:
                    Icon(blackMode ? Icons.crop_square_sharp : Icons.check_box),
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              width: 80.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: whiteMode.cardColor.withOpacity(0.6),
                border: Border.all(width: 1, color: whiteMode.abstractColor),
                borderRadius: const BorderRadius.all(Radius.circular(10)),
              ),
              child: ListTile(
                onTap: () {},
                title: const Text(
                  "Daten einfordern",
                  style: TextStyle(fontSize: 20),
                ),
                trailing: const Icon(Icons.straight_sharp),
              ),
            )
          ],
        ));
  }
}
