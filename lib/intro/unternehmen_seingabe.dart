import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itm_ichtrinkmehr_flutter/intro/rollen_input.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';

User user = User.empty();
Company company = Company.empty();

class LoginPage extends StatelessWidget {
  TextEditingController companyNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    company.company_name = "testCompany 2204";

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
                        entered_code(context);
                      },
                    ),
                  ),
                ]))));
  }

  entered_code(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => RoleInput(company)));
  }
}
