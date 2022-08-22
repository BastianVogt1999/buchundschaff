import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/global_methods.dart';
import 'package:itm_ichtrinkmehr_flutter/intro/unternehmens_eingabe.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';
import 'package:sizer/sizer.dart';

SelectStatements selectStatements = SelectStatements();
GlobalMethods globalMethods = GlobalMethods();
WhiteMode whiteMode = WhiteMode();

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => SignInPage_state();
}

class SignInPage_state extends State<SignInPage> {
  TextEditingController companyNameController = TextEditingController();
  TextEditingController countOfUserController = TextEditingController();
  TextEditingController mailController = TextEditingController();
  TextEditingController nameOfMaController = TextEditingController();

  bool pwdVisibility = false;

  @override
  Widget build(BuildContext context) {
    Widget textFieldDesign(
        TextEditingController textController, String textName) {
      return
          //Input Company-Code
          SizedBox(
        width: globalMethods.getSizeOfPage(context) > 400.0 ? 30.w : 80.w,
        child: TextFormField(
          controller: textController,
          decoration: InputDecoration(
            hintText: textName,
            hintStyle: TextStyle(
                color: Theme.of(context).textSelectionTheme.selectionColor!),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).textSelectionTheme.selectionColor!,
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
                color: Theme.of(context).textSelectionTheme.selectionColor!,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(25.0),
            ),
          ),
        ),
      );
    }

    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginPage())),
          backgroundColor: Theme.of(context).cardColor,
          label: const Text("Bereits angemeldet?"),
          icon: const Icon(Icons.login),
        ),
        body: Container(

            //background
            padding: const EdgeInsets.all(10.0),
            width: 100.w,
            height: 100.h,
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
            ),
            child: SizedBox(
                width: MediaQuery.of(context).size.width > 100 ? 50.w : 80.w,
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Container(
                          padding: const EdgeInsets.all(15),
                          alignment: Alignment.center,
                          width: 80.w,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            border: Border.all(
                                width: 1,
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionColor!),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                          ),
                          child: Text(
                            "Dieses Formular stellt keinen verbindlichen Vertrag dar, sondern stellt ausschließlich einen Antrag dar. Wir werden uns zeitnah bei Ihnen melden um Sie freizuschalten",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textSelectionTheme
                                    .selectionColor!,
                                fontSize: 12.sp),
                          )), //
                      SizedBox(height: 1.h),
                      textFieldDesign(
                          companyNameController, "Unternehmensname"),
                      SizedBox(height: 1.h),
                      textFieldDesign(
                          nameOfMaController, "Name des Ansprechpartners"),
                      SizedBox(height: 1.h),
                      textFieldDesign(
                          mailController, "Mail-Adresse des Ansprechpartners"),
                      SizedBox(height: 1.h),
                      textFieldDesign(
                          countOfUserController, "Anzahl an Mitarbeiter"),
                      SizedBox(height: 1.h),
                      //Button weiter
                      SizedBox(
                        width: globalMethods.getSizeOfPage(context) > 400.0
                            ? 30.w
                            : 80.w,
                        child: OutlinedButton(
                            onPressed: () {
                              entered_code(context);
                            },
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Antrag abschicken",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300,
                                        color:
                                            Theme.of(context).backgroundColor),
                                  ),
                                  Icon(Icons.arrow_forward,
                                      color: Theme.of(context).backgroundColor)
                                ]),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .textSelectionTheme
                                  .selectionColor!,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40))),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 50),
                            )),
                      ),
                    ])))));
  }

  entered_code(BuildContext context) async {
    var database = FirebaseFirestore.instance.collection('/Antraege');

    if (companyNameController.text != "" &&
        nameOfMaController.text != "" &&
        mailController.text != "" &&
        countOfUserController.text != "") {
      await database
          .doc()
          .set(
            {
              'company_name': companyNameController.text,
              'ansprechpartner': nameOfMaController.text,
              'mail': mailController.text,
              'anzahl_ma': countOfUserController.text,
              'bearbeitet': "false"
            },
          )
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const LoginPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text("Angaben nicht vollständig"),
        duration: Duration(milliseconds: 2500),
      ));
    }
  }
}
