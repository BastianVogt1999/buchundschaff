import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/global_methods.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/message.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';

SelectStatements selectStatements = SelectStatements();
GlobalMethods globalMethods = GlobalMethods();
class MessagesUser extends StatefulWidget {
  Company company;
  User user;

  MessagesUser(this.company, this.user);

  @override
  State<MessagesUser> createState() => _MessagesUserState(company, user);
}

class _MessagesUserState extends State<MessagesUser> {

  _MessagesUserState(this.company, this.user);
  Company company;
  User user;
  List<Message> allMessages = [];
  @override
  Widget build(BuildContext context) {
    
    decoratedTextBox(Message message){
      return Container(
        
               alignment: Alignment.center,
       width: MediaQuery.of(context).size.width /1.8,
          decoration: BoxDecoration(
            
               color: Colors.white,
              border: Border.all(width: 2,color: Colors.blueAccent),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: 
            Column(children: [
              Text(message.user_name, style: TextStyle(fontSize: 12),  textAlign: TextAlign.center),
              Divider(),
            Text(message.message_text, style: TextStyle(fontSize: 25),  textAlign: TextAlign.center),
            Divider(),
Container(
        
               alignment: Alignment.centerRight,
               child:
            Text(message.time, style: TextStyle(fontSize: 12),  textAlign: TextAlign.right),
),
            SizedBox(height:MediaQuery.of(context).size.height /40)
     ],),
      );
    }


    Widget messagesBuilder = FutureBuilder(
        future: selectStatements.selectAllMessages(company),
        builder: (context, dataSnapshot) {
          List<Widget> children;
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
               return globalMethods.loadingScreen(context);
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occured'),
              );
            } else {

                  allMessages = dataSnapshot.data as List<Message>;

return SizedBox( height: MediaQuery.of(context).size.height /1.8,
     child: ListView.builder(
          itemCount: allMessages.length,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(

      width: MediaQuery.of(context).size.width,
      child: Column(children: [
        Align(alignment: Alignment.topRight, child:
          decoratedTextBox(allMessages[index]),
        ),
          SizedBox(height:10),
      ])
      );
      }
      )
      );
            }}});


    return Container(child: messagesBuilder);
  }
}


