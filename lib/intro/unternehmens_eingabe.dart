import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itm_ichtrinkmehr_flutter/global_methods.dart';
import 'package:itm_ichtrinkmehr_flutter/intro/rollen_input.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';

SelectStatements selectStatements = SelectStatements();
GlobalMethods globalMethods = GlobalMethods();
WhiteMode whiteMode = WhiteMode();

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => LoginPage_state();
}

class LoginPage_state extends State<LoginPage> {
  TextEditingController companyNameController = TextEditingController();
  bool pwdVisibility = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(

            //background
            padding: const EdgeInsets.all(10.0),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: whiteMode.backgroundColor,
            ),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Icon(Icons.smart_toy_sharp,
                      size: 200, color: whiteMode.textColor),
                  SizedBox(height: 20),
                  //Input Company-Code
                  TextFormField(
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

                  //
                  SizedBox(height: 30),

                  //Button weiter
                  OutlinedButton(
                      onPressed: () {
                        entered_code(context, companyNameController.text);
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Weiter",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w300,
                                  color: whiteMode.backgroundColor),
                            ),
                            Icon(Icons.arrow_forward,
                                color: whiteMode.backgroundColor)
                          ]),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: whiteMode.textColor,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(40))),
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                      )),
                ]))));
  }
}

entered_code(BuildContext context, String company_code) async {
  Company company = Company.empty();
  try {
    company = await selectStatements.selectCompany(company_code);
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
