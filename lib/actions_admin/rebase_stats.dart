import 'dart:async';

import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/global_methods.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/insert_statements.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/update_statements.dart';
import 'package:sizer/sizer.dart';

SelectStatements selectStatements = SelectStatements();
GlobalMethods globalmethods = GlobalMethods();
UpdateStatements updateStatements = UpdateStatements();
InsertStatements insertStatements = InsertStatements();

WhiteMode whiteMode = WhiteMode();
List<UserBuS> currentUser = [];
List<UserBuS> showedUser = [];
List<String> currentUserNames = [];

TextEditingController searchField = TextEditingController();
TextEditingController controllerUserName = TextEditingController();
TextEditingValue textEditingValue = const TextEditingValue();
String selectedDate = "Zeitraum wählen";

class RebaseStats extends StatefulWidget {
  RebaseStats(this.company);
  Company company;
  @override
  State<RebaseStats> createState() => _RebaseStatsState(company);
}

class _RebaseStatsState extends State<RebaseStats> {
  Company company;
  bool shownAddUser = false;
  bool checkBoxUserIsAdminSelected = false;
  late StreamController<List<UserBuS>> currentStream =
      StreamController<List<UserBuS>>();

  Future<void> closeStream() => currentStream.close();

  @override
  void initState() {
    super.initState();
    currentStream = StreamController<List<UserBuS>>();
  }

  @override
  void dispose() {
    super.dispose();
    closeStream();
  }

  _RebaseStatsState(this.company);
  @override
  Widget build(BuildContext context) {
    _getUserServer() async {
      currentUserNames = [];
      currentUser = [];
      List<UserBuS> allUser =
          await selectStatements.selectAllUserOfCompany(company);

      currentUser = allUser;
      currentUserNames.add("alle User");
      for (int i = 0; i < currentUser.length; i++) {
        currentUserNames.add(currentUser[i].user_name);
      }

      currentStream.add(allUser);
    }

    Widget AutoCompleteUser() {
      return Container(
          width: 80.w,
          color: Theme.of(context).cardColor,
          child: Autocomplete<String>(
            optionsBuilder: (textEditingValue) {
              if (textEditingValue.text == '') {
                return const Iterable<String>.empty();
              }
              return currentUserNames.where((String option) {
                return option
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
              });
            },
            onSelected: (String selection) {
              for (int i = 0; i < currentUser.length; i++) {
                if (currentUser[i].user_name == selection) {
                  showedUser.add(currentUser[i]);
                  setState(() {});
                }
              }

              debugPrint('You just selected ' + selection);
            },
          ));
    }
    // Call when you want the date time range picker to be shown

    Widget buttonConfirm() {
      return SizedBox(
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
              onPressed: () async {},
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
                          minHeight: 36.0), // min sizes for Material buttons
                      alignment: Alignment.center,
                      child: const Text('Bestätigen',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300)))),
            ),
          ),
        ),
      );
    }

    Widget datePicker() {
      return SizedBox(
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
                final DateTimeRange? newDate = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(2022, 1),
                  lastDate: DateTime(2022, 7),
                  helpText: 'Zeitraum auswählen',
                );
              },
              splashColor: Colors.lightBlue,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(36)),
              padding: const EdgeInsets.all(0.0),
              child: Ink(
                  decoration: BoxDecoration(
                    //gradient:
                    image: const DecorationImage(
                      image: AssetImage('assets/background.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(36),
                  ),
                  child: Container(
                      constraints: const BoxConstraints(
                          minWidth: 88.0,
                          minHeight: 36.0), // min sizes for Material buttons
                      alignment: Alignment.center,
                      child: Text(selectedDate,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w300)))),
            ),
          ),
        ),
      );
    }

    Widget showedPickedUser() {
      return Container(
          padding: EdgeInsets.all(2.h),
          height: 50.h,
          width: 80.w,
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: Theme.of(context).accentColor),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) =>
                  SizedBox(height: 1.h),
              itemCount: showedUser.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 40.w,
                  decoration: BoxDecoration(
                    color: Theme.of(context).accentColor,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(2.sp),
                    child: ListTile(
                      onTap: () {},
                      title: Text(
                        showedUser[index].user_name,
                        style: const TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      leading: CircleAvatar(
                          backgroundColor: Theme.of(context).backgroundColor,
                          child: Icon(
                            Icons.person,
                            color: Theme.of(context).accentColor,
                          )),
                      trailing: Icon(
                        Icons.delete,
                        size: 30,
                        color: Theme.of(context).backgroundColor,
                      ),
                    ),
                  ),
                );
              }));
    }

    _getUserServer();

    return SingleChildScrollView(
        child: Column(
      children: [
        AutoCompleteUser(),
        SizedBox(height: 2.h),
        showedPickedUser(),
        SizedBox(height: 2.h),
        datePicker(),
        SizedBox(height: 2.h),
        buttonConfirm()
      ],
    ));
  }
}
