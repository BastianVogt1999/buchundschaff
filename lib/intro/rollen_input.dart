import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/intro/carrousel_intro.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/insert_statements.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sizer/sizer.dart';
import '../actions_admin/admin_menu.dart';
import '../actions_user/user_menu.dart';
import 'unternehmens_eingabe.dart';

InsertStatements insertStatements = InsertStatements();
SelectStatements selectStatements = SelectStatements();
WhiteMode whiteMode = WhiteMode();

StreamController<String> streamControllerUserInput = StreamController<String>();
Stream stream = streamControllerUserInput.stream.asBroadcastStream();

class RoleInput extends StatefulWidget {
  const RoleInput(this.company, {Key? key}) : super(key: key);

  final String company;

  @override
  State<RoleInput> createState() => _RoleInputState(company);
}

class _RoleInputState extends State<RoleInput> {
  TextEditingController userCodeController = TextEditingController();
  Future<void> closeStream() => streamControllerUserInput.close();
  bool valuefirst = false;

  String company_name;
  Company company = Company.empty();

  _RoleInputState(this.company_name);

  @override
  initState() {
    super.initState();

    stream.listen((String) {
      pressedRole(String);
    });
  }

  @override
  void dispose() {
    super.dispose();
    closeStream();
  }

  pressedRole(String adminPressed) async {
    UserBuS user = UserBuS.empty();
    user = await SelectStatements().selectOneUserOfCompany(company, "1");

    if (adminPressed == "true") {
      if (userCodeController.text == company.admin_code) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AdminMenu(
                      company,
                    )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text("Falscher Code"),
          duration: Duration(milliseconds: 2500),
        ));
      }
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserMenu(
                    company,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    getCompany() async {
      company = await SelectStatements().selectCompany(company_name);

      print("name2 " + company.company_code);
    }

    bool pwdVisibility = false;
    getCompany();

    return Scaffold(
        appBar: AppBar(
          actions: [
            FloatingActionButton.extended(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('loggedIn', false);
                await prefs.setString('companyName', '');
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage()));
              },
              label: const Text("Log-Out"),
              icon: const Icon(
                Icons.logout,
              ),
            ),
          ],
          backgroundColor: Theme.of(context).cardColor,
          automaticallyImplyLeading: false,
          title: ClipRRect(
            borderRadius: BorderRadius.circular(1.h),
            child: Container(
              padding: EdgeInsets.all(1.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Text(
                "Buchundschaff",
                style: TextStyle(
                  fontSize: 3.h,
                  color: Theme.of(context).textSelectionTheme.selectionColor!,
                ),
              ),
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          width: double.infinity,
          height: double.infinity,
          color: Theme.of(context).backgroundColor,
          child: Center(
            child: SizedBox(
              width: globalMethods.getSizeOfPage(context) > 400 ? 50.w : 100.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    controller: userCodeController,
                    obscureText: !pwdVisibility,
                    decoration: InputDecoration(
                      hintText: "Admin-Code",
                      hintStyle: TextStyle(
                          color: Theme.of(context)
                              .textSelectionTheme
                              .selectionColor!,
                          fontStyle: FontStyle.italic,
                          fontFeatures: const <FontFeature>[
                            FontFeature.liningFigures()
                          ]),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context)
                              .textSelectionTheme
                              .selectionColor!,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context)
                              .textSelectionTheme
                              .selectionColor!,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      suffixIcon: InkWell(
                        onTap: () => setState(
                          () => pwdVisibility = !pwdVisibility,
                        ),
                        child: Icon(
                          pwdVisibility
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Theme.of(context)
                              .textSelectionTheme
                              .selectionColor!,
                          size: 18,
                        ),
                      ),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 300,
                    child: cusCar(stream, streamControllerUserInput),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

getUserFromServer(Company company) async {
  return await selectStatements.selectAllUserOfCompany(company);
}
