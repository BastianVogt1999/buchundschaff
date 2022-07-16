import 'package:flutter/material.dart';
import "package:intl/intl.dart";

import 'package:itm_ichtrinkmehr_flutter/actions_admin/full_stats_admin.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/message.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/insert_statements.dart';

TextEditingController messageController = TextEditingController();
WhiteMode whiteMode = WhiteMode();
InsertStatements insertStatements = InsertStatements();
DateFormat _formatterDate = DateFormat('dd:MM:yyyy');
DateFormat _formatter = DateFormat('HH:mm:ss');

class SendMessages extends StatefulWidget {
  Company company;
  User user;
  SendMessages(this.company, this.user);

  @override
  State<SendMessages> createState() => _SendMessagesState(company, user);
}

class _SendMessagesState extends State<SendMessages> {
  List<Message> allMessages = [];
  _SendMessagesState(this.company, this.user);
  Company company;
  User user;
  @override
  Widget build(BuildContext context) {
    decoratedTextBox(Message message) {
      return Container(
        padding: EdgeInsets.all(5),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width / 1.8,
        decoration: BoxDecoration(
          color: whiteMode.cardColor,
          border: Border.all(width: 2, color: whiteMode.abstractColor),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            Text(message.user_name,
                style: TextStyle(fontSize: 12, color: whiteMode.textColor),
                textAlign: TextAlign.center),
            Divider(),
            Text(message.message_text,
                style: TextStyle(fontSize: 25, color: whiteMode.textColor),
                textAlign: TextAlign.center),
            Divider(),
            Container(
              alignment: Alignment.centerRight,
              child: Text(message.time,
                  style: TextStyle(fontSize: 12, color: whiteMode.textColor),
                  textAlign: TextAlign.right),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 40)
          ],
        ),
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

              return Container(
                  padding: EdgeInsets.all(10),
                  height: MediaQuery.of(context).size.height / 1.25,
                  child: ListView.builder(
                      itemCount: allMessages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: decoratedTextBox(allMessages[index]),
                              ),
                              SizedBox(height: 10),
                            ]));
                      }));
            }
          }
        });

    return Container(
        padding: EdgeInsets.all(10),
        child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          messagesBuilder,
          Container(
            height: MediaQuery.of(context).size.height / 16,
            child: Row(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width / 1.3,
                    child: TextFormField(
                        controller: messageController,
                        decoration: InputDecoration(
                          hintText: "...",
                          hintStyle: TextStyle(
                              color: whiteMode.textColor.withOpacity(0.6)),
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
                        ))),
                Container(
                    width: MediaQuery.of(context).size.width / 6,
                    child: FloatingActionButton(
                      backgroundColor: Colors.green,
                      onPressed: () {
                        Message message = Message.empty();
                        message.message_text = messageController.text;
                        message.time = _formatter.format(DateTime.now());
                        message.date = _formatterDate.format(DateTime.now());
                        message.user_name = user.user_name;

                        insertStatements.insertNewMessage(company, message);

                        messageController.text = "";

                        setState(() {});
                      },
                      child: Icon(
                        Icons.label_important_rounded,
                        color: whiteMode.backgroundColor,
                      ),
                    )),
              ],
            ),
          )
        ]));
  }
}
