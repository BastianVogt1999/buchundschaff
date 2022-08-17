import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:sizer/sizer.dart';

import '../values/company.dart';

WhiteMode whiteMode = WhiteMode();

class SettingsAdmin extends StatefulWidget {
  const SettingsAdmin(Company company);

  @override
  State<SettingsAdmin> createState() => _SettingsAdminState();
}

class _SettingsAdminState extends State<SettingsAdmin> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
      SizedBox(height: 2.h),
      AnimatedSize(
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 500),
          child: SizedBox(
              height: 80.h,
              child: Column(
                children: [
                  //User Card
                  Container(
                    width: 90.w,
                    decoration: BoxDecoration(
                      color: whiteMode.abstractColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(2.sp),
                      child: ListTile(
                        onTap: () {
                          setState(() {});
                        },
                        title: Text(
                          "Gesammelte Daten zusenden",
                          style: TextStyle(
                            fontSize: 20,
                            color: whiteMode.backgroundColor,
                          ),
                        ),
                        trailing: Icon(
                          Icons.data_exploration_outlined,
                          size: 30,
                          color: whiteMode.backgroundColor,
                        ),
                      ),
                    ),
                  ),
                ],
              )))
    ]));
  }
}
