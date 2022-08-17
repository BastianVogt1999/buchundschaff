import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/delete_statements.dart';
import 'package:sizer/sizer.dart';

import '../values/company.dart';

WhiteMode whiteMode = WhiteMode();
DeleteStatements deleteStatements = DeleteStatements();
bool deleteIsRunning = false;

class ClearStat extends StatefulWidget {
  const ClearStat({Key? key}) : super(key: key);

  @override
  State<ClearStat> createState() => _ClearStatState();
}

class _ClearStatState extends State<ClearStat> {
  @override
  Widget build(BuildContext context) {
    return Container(
        //background
        padding: const EdgeInsets.all(10.0),
        width: 100.w,
        height: 100.h,
        decoration: BoxDecoration(color: whiteMode.backgroundColor),
        child: Column(
          children: [
            SizedBox(height: 80.h),
            SizedBox(
              width: 40.w,
              child: AspectRatio(
                aspectRatio: 208 / 71,
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        offset: const Offset(0, 4),
                        color: const Color(0x004960f9).withOpacity(.3),
                        spreadRadius: 4,
                        blurRadius: 50)
                  ]),
                  child: MaterialButton(
                    onPressed: () async {
                      Company company = Company.empty();
                      company.company_name = "testCompany 2204";
                    },
                    splashColor: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36)),
                    padding: const EdgeInsets.all(0.0),
                    child: Ink(
                        decoration: BoxDecoration(
                          //gradient:
                          color: Colors.lightGreen,
                          borderRadius: BorderRadius.circular(36),
                        ),
                        child: Container(
                            constraints: const BoxConstraints(
                                minWidth: 88.0,
                                minHeight:
                                    36.0), // min sizes for Material buttons
                            alignment: Alignment.center,
                            child: const Text('Bestätigen',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300)))),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
