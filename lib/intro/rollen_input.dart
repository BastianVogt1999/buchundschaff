import 'dart:async';


import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_user/timer/timer_main.dart';
import 'package:itm_ichtrinkmehr_flutter/intro/carrousel_intro.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/insert_statements.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';
import 'package:lottie/lottie.dart';

import '../actions_admin/admin_menu.dart';
import '../actions_user/user_menu.dart';

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
 

   Company company;
  _RoleInputState(this.company);

  @override
  void initState() {
    super.initState();

    stream.listen((String) {
      pressedRole(
          String);
    });
  }


  pressedRole(String adminPressed) async {
User user = await selectStatements.selectOneUserOfCompany(company, userCodeController.text);

if(user.user_name != ""){


    if (adminPressed == "true") {
      if(user.is_admin == "true"){
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => AdminMenu(
                    company,
                    user,
                  )));
      }
      else{
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
  }
   else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    backgroundColor: Colors.red,
    content: Text("User mit angegebenen Code nicht gefunden"),
    duration: Duration(milliseconds: 2500),
  ));
  }
  }
 

  
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
          }});}

}

getUserFromServer(Company company) async {
  
  return await selectStatements.selectAllUserOfCompany(company);
 }
