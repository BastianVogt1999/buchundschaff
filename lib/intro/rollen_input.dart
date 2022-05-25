import 'dart:async';

import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/timer_main.dart';
import 'package:itm_ichtrinkmehr_flutter/intro/carrousel_intro.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/insert_statements.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';
import 'package:lottie/lottie.dart';

InsertStatements insertStatements = InsertStatements();
SelectStatements selectStatements = SelectStatements();

  StreamController<String> streamControllerUserInput =StreamController<String>();
 Stream stream = streamControllerUserInput.stream.asBroadcastStream();
 

 class RoleInput extends StatefulWidget {
   RoleInput(this.company);
 
  Company company;
   @override
   State<RoleInput> createState() => _RoleInputState(company);
 }
 
 class _RoleInputState extends State<RoleInput> {
   TextEditingController userCodeController = TextEditingController();
 
 User user = User.empty();
   Company company;
  _RoleInputState(this.company);



  @override
  Widget build(BuildContext context) {
        return FutureBuilder(
        future: getUserFromServer(company),
        builder: (context, dataSnapshot) {
          List<Widget> children;
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
           return globalmethods.loadingScreen();
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occured'),
              );
            } else {
              final data = dataSnapshot.data as List<User>;
              for(int i = 0; i<data.length; i++){
if (data[i].user_name== "Dieter"){
  user = data[i];
}
              }
    return Scaffold(
      appBar: AppBar(
    
        backgroundColor: Color(0xff4338CA),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.share,
              color: Color(0xffffffff),
            ),
            onPressed: () {
              insertStatements.insertNewCompany(Company("12", "asas"));
            },
          )
        ],
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_arrow_left,
            color: Color(0xffffffff),
          ),
          onPressed: () {},
        ),
      ),
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
            children: <Widget>[
              TextFormField(
                autofocus: false,
                cursorColor: Theme.of(context).colorScheme.secondary,
                keyboardType: TextInputType.text,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                decoration: InputDecoration(
                  hintText: 'User-Code eingeben',
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  fillColor: Theme.of(context).colorScheme.secondary,
                ),
                controller: userCodeController,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: IconButton(
                  icon: Icon(Icons.info_outline),
                  onPressed: () {
                    entered_user_code(context);
                    print("oh");
                  },
                ),
              ),
              SizedBox(
                height: 300,
                child: cusCar(user, company),
              )
            ],
          ),
        ),
      ),
    );
  }
          }});}

  entered_user_code(BuildContext context) {}

  static InsertStatements() {}
}

getUserFromServer(Company company) async {
  
  return await selectStatements.selectAllUserOfCompany(company);
 }
