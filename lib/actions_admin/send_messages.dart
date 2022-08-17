import 'package:flutter/material.dart';
import "package:intl/intl.dart";

import 'package:itm_ichtrinkmehr_flutter/actions_admin/full_stats_admin.dart';
import 'package:itm_ichtrinkmehr_flutter/global_methods.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/message.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/insert_statements.dart';
import 'package:sizer/sizer.dart';

WhiteMode whiteMode = WhiteMode();
InsertStatements insertStatements = InsertStatements();
DateFormat _formatterDate = DateFormat('dd:MM:yyyy');
DateFormat _formatter = DateFormat('HH:mm:ss');
GlobalMethods globalMethods = GlobalMethods();

class SendMessages extends StatefulWidget {
  Company company;
  UserBuS user;
  SendMessages(this.company, this.user);

  @override
  State<SendMessages> createState() => _SendMessagesState(company, user);
}

class _SendMessagesState extends State<SendMessages> {
  List<Message> allMessages = [];
  _SendMessagesState(this.company, this.user);
  Company company;
  UserBuS user;
  TextEditingController messageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    decoratedTextBox(Message message) {
      return Container(
        padding: const EdgeInsets.all(5),
        alignment: Alignment.center,
        width: 60.w,
        decoration: BoxDecoration(
          color: whiteMode.cardColor,
          border: Border.all(width: 2, color: whiteMode.abstractColor),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
        ),
        child: Column(
          children: [
            Text(message.user_name,
                style: TextStyle(fontSize: 12, color: whiteMode.textColor),
                textAlign: TextAlign.center),
            const Divider(),
            Text(message.message_text,
                style: TextStyle(fontSize: 20.sp, color: whiteMode.textColor),
                textAlign: TextAlign.center),
            const Divider(),
            Row(
              children: [
                Flexible(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Datum: " + message.date,
                        style: TextStyle(
                            fontSize: 8.sp, color: whiteMode.textColor),
                        textAlign: TextAlign.right),
                  ),
                ),
                Flexible(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Text("Zeit: " + message.time,
                        style: TextStyle(
                            fontSize: 8.sp, color: whiteMode.textColor),
                        textAlign: TextAlign.right),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 40)
          ],
        ),
      );
    }

    Widget messagesBuilder = FutureBuilder(
        future: selectStatements.selectAllMessages(company),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return globalMethods.loadingScreen(context);
          } else {
            if (dataSnapshot.error != null) {
              return const Center(
                child: Text('An error occured'),
              );
            } else {
              allMessages = dataSnapshot.data as List<Message>;

              return Container(
                  padding: const EdgeInsets.all(10),
                  height: 80.h,
                  child: ListView.builder(
                      itemCount: allMessages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Column(children: [
                              Align(
                                alignment: Alignment.bottomRight,
                                child: decoratedTextBox(allMessages[index]),
                              ),
                              SizedBox(height: 2.h),
                            ]));
                      }));
            }
          }
        });

    return Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
            child: SizedBox(
          height: 90.h,
          child: ListView(children: [
            messagesBuilder,
            SizedBox(
              height: MediaQuery.of(context).size.height / 16,
              child: Row(
                children: [
                  SizedBox(
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
                                color: whiteMode.textColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                          ))),
                  SizedBox(
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
          ]),
        )));
  }
}
