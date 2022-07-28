import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/global_methods.dart';
import 'package:itm_ichtrinkmehr_flutter/intro/rollen_input.dart';
import 'package:itm_ichtrinkmehr_flutter/intro/sign_in.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';
import 'package:lottie/lottie.dart';
import 'package:sizer/sizer.dart';

SelectStatements selectStatements = SelectStatements();
GlobalMethods globalMethods = GlobalMethods();
WhiteMode whiteMode = WhiteMode();
BlackMode blackMode = BlackMode();

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => LoginPage_state();
}

class LoginPage_state extends State<LoginPage> {
  TextEditingController companyNameController = TextEditingController();
  bool whiteModeOn = true;

  bool pwdVisibility = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignInPage())),
          backgroundColor: whiteMode.abstractColor,
          label: Text("Jetzt Zugang beantragen"),
          icon: Icon(Icons.login),
        ),
        body: Container(

            //background
            padding: const EdgeInsets.all(10.0),
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              color: whiteModeOn
                  ? whiteMode.backgroundColor
                  : blackMode.backgroundColor,
            ),
            child: SizedBox(
                width: MediaQuery.of(context).size.width > 100 ? 50.w : 80.w,
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Container(
                        height: 20.h,
                        child: Center(
                          child: Lottie.asset(
                            "assets/worker_icon.json",
                            reverse: true,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      //Input Company-Code
                      Container(
                        width: globalMethods.getSizeOfPage(context) > 400.0
                            ? 30.w
                            : 80.w,
                        child: TextFormField(
                          controller: companyNameController,
                          obscureText: !pwdVisibility,
                          decoration: InputDecoration(
                            hintText: "Unternehmenscode",
                            hintStyle: TextStyle(color: whiteMode.textColor),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: whiteMode.textColor,
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
                                color: whiteModeOn
                                    ? whiteMode.textColor
                                    : blackMode.textColor,
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
                      ),

                      //
                      const SizedBox(height: 30),

                      //Button weiter
                      Flexible(
                        flex: 3,
                        child: SizedBox(
                          width: globalMethods.getSizeOfPage(context) > 400.0
                              ? 30.w
                              : 80.w,
                          child: OutlinedButton(
                              onPressed: () {
                                entered_code(
                                    context, companyNameController.text);
                              },
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Weiter",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w300,
                                          color: whiteModeOn
                                              ? whiteMode.backgroundColor
                                              : blackMode.backgroundColor),
                                    ),
                                    Icon(Icons.arrow_forward,
                                        color: whiteModeOn
                                            ? whiteMode.backgroundColor
                                            : blackMode.backgroundColor)
                                  ]),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: whiteModeOn
                                    ? whiteMode.textColor
                                    : blackMode.textColor,
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40))),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 20, horizontal: 50),
                              )),
                        ),
                      )
                    ])))));
  }
}

entered_code(BuildContext context, String companyCode) async {
  Company company = Company.empty();
  try {
    company = await selectStatements.selectCompany(companyCode);
  } catch (Exception) {
    print("error");
  }

  if (company.company_name != "") {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => RoleInput(company)));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.red,
      content: Text("Unternehmen mit angegebenen Code nicht gefunden"),
      duration: Duration(milliseconds: 2500),
    ));
  }
}
