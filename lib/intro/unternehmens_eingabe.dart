import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itm_ichtrinkmehr_flutter/global_methods.dart';
import 'package:itm_ichtrinkmehr_flutter/intro/rollen_input.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';

SelectStatements selectStatements = SelectStatements();
GlobalMethods globalMethods = GlobalMethods();

class LoginPage extends StatelessWidget {
  TextEditingController companyNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
       return FutureBuilder(
        future: selectStatements.selectCompany(companyNameController.text),
        builder: (context, dataSnapshot) {
          List<Widget> children;
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
           return globalMethods.loadingScreen();
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occured'),
              );
            } else {
              final data = dataSnapshot.data as Company;
            
    return Scaffold(
        body: Container(
            padding: const EdgeInsets.all(10.0),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  TextFormField(
                    autofocus: false,
                    cursorColor: Theme.of(context).colorScheme.secondary,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Unternehmenscode eingeben',
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      fillColor: Theme.of(context).colorScheme.secondary,
                    ),
                    controller: companyNameController,
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: IconButton(
                      icon: Icon(Icons.info_outline),
                      onPressed: () {
                        entered_code(context, data);
                      },
                    ),
                  ),
                ]))));
            }
          }});
  }

  entered_code(BuildContext context, Company company) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => RoleInput(company)));
  }
}
