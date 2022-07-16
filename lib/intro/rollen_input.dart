import 'dart:async';

import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/timer_main.dart';
import 'package:itm_ichtrinkmehr_flutter/intro/carrousel_intro.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/insert_statements.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';
import 'package:lottie/lottie.dart';

import '../actions_admin/admin_menu.dart';
import '../actions_user/user_menu.dart';
import 'unternehmens_eingabe.dart';

InsertStatements insertStatements = InsertStatements();
SelectStatements selectStatements = SelectStatements();
WhiteMode whiteMode = WhiteMode();

StreamController<String> streamControllerUserInput = StreamController<String>();
Stream stream = streamControllerUserInput.stream.asBroadcastStream();

class RoleInput extends StatefulWidget {
  RoleInput(this.company);

  Company company;
  @override
  State<RoleInput> createState() => _RoleInputState(company);
}

class _RoleInputState extends State<RoleInput> {
  TextEditingController userCodeController = TextEditingController();

  Company company;
  _RoleInputState(this.company);

  @override
  void initState() {
    super.initState();

    stream.listen((String) {
      pressedRole(String);
    });
  }

  pressedRole(String adminPressed) async {
    User user = await selectStatements.selectOneUserOfCompany(
        company, userCodeController.text);

    if (user.user_name != "") {
      if (adminPressed == "true") {
        if (user.is_admin == "true") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AdminMenu(
                        company,
                        user,
                      )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.red,
            content: Text("Du bist kein Admin"),
            duration: Duration(milliseconds: 2500),
          ));
        }
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserMenu(
                      company,
                      user,
                    )));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text("User mit angegebenen Code nicht gefunden"),
        duration: Duration(milliseconds: 2500),
      ));
    }
  }

  bool valuefirst = false;

  @override
  Widget build(BuildContext context) {
    bool pwdVisibility = false;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteMode.cardColor,
        actions: [
          IconButton(
            icon: Icon(
              Icons.share,
              color: whiteMode.textColor,
            ),
            onPressed: () {
              insertStatements.insertNewCompany(Company("12", "asas"));
            },
          ),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              },
              icon: Icon(
                Icons.home_filled,
                color: whiteMode.textColor,
              ))
        ],
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: whiteMode.textColor,
          ),
          onPressed: () {},
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        width: double.infinity,
        height: double.infinity,
        color: whiteMode.backgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: userCodeController,
                obscureText: !pwdVisibility,
                decoration: InputDecoration(
                  hintText: "User-Code",
                  hintStyle: TextStyle(color: whiteMode.textColor),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: whiteMode.textColor,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: whiteMode.textColor,
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
                      color: whiteMode.textColor,
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
              SizedBox(height: 10),

              /** Checkbox Widget **/
              SizedBox(
                height: 40,
                child: CheckboxListTile(
                  title: const Text('Angemeldet bleiben'),
                  value: this.valuefirst,
                  onChanged: (value) {
                    setState(() {
                      if (valuefirst) {
                        valuefirst = false;
                      } else {
                        valuefirst = true;
                      }
                    });
                  },
                ),
              ),
              SizedBox(
                height: 300,
                child: cusCar(stream, streamControllerUserInput),
              )
            ],
          ),
        ),
      ),
    );
  }
}

getUserFromServer(Company company) async {
  return await selectStatements.selectAllUserOfCompany(company);
}
