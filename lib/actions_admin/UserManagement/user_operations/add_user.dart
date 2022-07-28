import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/insert_statements.dart';

TextEditingController getUserName = TextEditingController();
InsertStatements insertStatements = InsertStatements();
const primaryColor = Color(0xffffffff);
const secondaryColor = Color(0xff6D28D9);
const accentColor = Color(0xffffffff);

const errorColor = Color(0xffEF4444);

bool? checkBoxSelected = false;

class DialogAddUser extends StatefulWidget {
  Company company;
  DialogAddUser(this.company);
  @override
  State<DialogAddUser> createState() => dialogAddUserState(company);
}

class dialogAddUserState extends State<DialogAddUser> {
  Company company;
  dialogAddUserState(this.company);
  final primaryColor = const Color(0xff4338CA);
  final accentColor = const Color(0xffffffff);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.4,
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(12, 26),
                  blurRadius: 50,
                  spreadRadius: 0,
                  color: Colors.grey.withOpacity(.1)),
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: primaryColor,
              radius: 25,
              child: Image.network(
                  "https://firebasestorage.googleapis.com/v0/b/flutterbricks-public.appspot.com/o/FlutterBricksLogo-Med.png?alt=media&token=7d03fedc-75b8-44d5-a4be-c1878de7ed52"),
            ),
            const SizedBox(
              height: 15,
            ),
            const SizedBox(
              height: 3.5,
            ),
            buildTextField(),
            const SizedBox(
              height: 15,
            ),
            CheckboxListTile(
              title: Text("Adminkonfiguration"),
              value: checkBoxSelected,
              onChanged: (newValue) {
                setState(() {
                  checkBoxSelected = newValue;
                });
              },
              controlAffinity:
                  ListTileControlAffinity.leading, //  <-- leading Checkbox
            ),
            SimpleBtn1(
                text: "Bestätigen",
                onPressed: () {
                  insertStatements.insertNewUser(
                      company,
                      UserBuS(
                          getUserName.text, "", checkBoxSelected.toString()));
                  setState(() {
                    checkBoxSelected = false;
                    getUserName.text = "";
                  });
                }),
          ],
        ),
      ),
    );
  }
}

class SimpleBtn1 extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final bool invertedColors;
  const SimpleBtn1(
      {required this.text,
      required this.onPressed,
      this.invertedColors = false});
  final primaryColor = const Color(0xff4338CA);
  final accentColor = const Color(0xffffffff);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            alignment: Alignment.center,
            side: MaterialStateProperty.all(
                BorderSide(width: 1, color: primaryColor)),
            padding: MaterialStateProperty.all(
                const EdgeInsets.only(right: 25, left: 25, top: 0, bottom: 0)),
            backgroundColor: MaterialStateProperty.all(
                invertedColors ? accentColor : primaryColor),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            )),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              color: invertedColors ? primaryColor : accentColor, fontSize: 16),
        ));
  }
}

Widget buildTextField() {
  return TextField(
    enabled: true,
    controller: getUserName,
    onChanged: (value) {
      //Do something wi
    },
    keyboardType: TextInputType.emailAddress,
    style: const TextStyle(fontSize: 14, color: Colors.black),
    decoration: InputDecoration(
      label: Text("User-Name"),
      labelStyle: const TextStyle(color: primaryColor),
      // prefixIcon: Icon(Icons.email),
      filled: true,
      fillColor: secondaryColor,
      hintText: "User_name eingeben",
      hintStyle: TextStyle(color: Colors.grey.withOpacity(.75)),
      contentPadding:
          const EdgeInsets.symmetric(vertical: 0.0, horizontal: 20.0),
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: secondaryColor, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: errorColor, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor, width: 1.0),
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
    ),
  );
}

// - - - - - - - - - - - - Instructions - - - - - - - - - - - - - -
// Place AppBarFb1 inside the app bar property of a Scaffold
// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

