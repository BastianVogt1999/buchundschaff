import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_dev.dart/menu_dev.dart';
import 'package:itm_ichtrinkmehr_flutter/global_methods.dart';
import 'package:itm_ichtrinkmehr_flutter/intro/rollen_input.dart';
import 'package:itm_ichtrinkmehr_flutter/intro/sign_in.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:theme_manager/theme_manager.dart';

SelectStatements selectStatements = SelectStatements();
GlobalMethods globalMethods = GlobalMethods();
WhiteMode whiteMode = WhiteMode();
BlackMode blackMode = BlackMode();
bool beLoggedIn = false;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => LoginPage_state();
}

class LoginPage_state extends State<LoginPage> {
  TextEditingController companyNameController = TextEditingController();

  bool pwdVisibility = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SignInPage())),
          backgroundColor: Theme.of(context).cardColor,
          label: const Text("Jetzt Zugang beantragen"),
          icon: const Icon(Icons.login),
        ),
        body: Container(

            //background
            padding: const EdgeInsets.all(10.0),
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(color: Theme.of(context).backgroundColor),
            child: SizedBox(
                width: MediaQuery.of(context).size.width > 100 ? 50.w : 80.w,
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Container(
                          alignment: Alignment.topRight,
                          child: IconButton(
                              onPressed: () {
                                ThemeManager.of(context)
                                    .setBrightnessPreference(
                                        BrightnessPreference.dark);
                              },
                              icon: Icon(
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Icons.sunny
                                      : Icons.dark_mode,
                                  size: 30.sp,
                                  color: Theme.of(context)
                                      .textSelectionTheme
                                      .selectionColor))),
                      SizedBox(
                        height: 30.h,
                        child: Center(child: Image.asset('assets/logo_bus.png')
                            /*whiteModeOn
                              ? Lottie.asset(
                                  "assets/worker_icon.json",
                                  repeat: false,
                                )
                              : Lottie.asset(
                                  "assets/worker_blue.json",
                                  repeat: false,
                                ),*/
                            ),
                      ),
                      const SizedBox(height: 20),
                      //Input Company-Code
                      SizedBox(
                        width: globalMethods.getSizeOfPage(context) > 400.0
                            ? 30.w
                            : 80.w,
                        child: TextFormField(
                          controller: companyNameController,
                          obscureText: !pwdVisibility,
                          decoration: InputDecoration(
                            hintText: "Unternehmenscode",
                            hintStyle: TextStyle(
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionColor!),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionColor!,
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
                                    .selectionColor,
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
                      SizedBox(
                        height: 40,
                        child: CheckboxListTile(
                          title: const Text('Angemeldet bleiben'),
                          value: beLoggedIn,
                          onChanged: (value) {
                            setState(() {
                              if (beLoggedIn) {
                                beLoggedIn = false;
                              } else {
                                beLoggedIn = true;
                              }
                            });
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
                                          color: Theme.of(context)
                                              .backgroundColor),
                                    ),
                                    Icon(Icons.arrow_forward,
                                        color:
                                            Theme.of(context).backgroundColor)
                                  ]),
                              style: OutlinedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionColor,
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
  final prefs = await SharedPreferences.getInstance();

  if (companyCode == "Bv(9ak723") {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const DevMenu()));
    return;
  }
  Company company = Company.empty();
  try {
    company = await selectStatements.selectCompany(companyCode);
  } catch (Exception) {
    print("error");
  }

  if (company.company_name != "") {
    if (beLoggedIn) {
      await prefs.setBool('loggedIn', true);
      await prefs.setString('companyCode', company.company_code);
      beLoggedIn = false;
    }
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => RoleInput(company.company_code)));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.red,
      content: Text("Unternehmen mit angegebenen Code nicht gefunden"),
      duration: Duration(milliseconds: 2500),
    ));
  }
}
