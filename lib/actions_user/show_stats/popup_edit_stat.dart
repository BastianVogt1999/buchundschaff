import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/values/statistic.dart';

TextEditingController startTimeController = TextEditingController();
TextEditingController endTimeController = TextEditingController();
TextEditingController dateController = TextEditingController();
TextEditingController blankController = TextEditingController();
const backgroundColor = Color(0xFFC0C0C0);
bool startTimeEditable = false;
bool endTimeEditable = false;
bool dateEditable = false;
bool nameEditable = false;
bool idEditable = false;

class EditStats extends StatefulWidget {
  final Statistic statistic;
  const EditStats(this.statistic);

  @override
  State<EditStats> createState() => EditStats_State(statistic);
}

class EditStats_State extends State<EditStats> {
  final Statistic statistic;
  EditStats_State(this.statistic);
  final primaryColor = const Color(0xff4338CA);
  final accentColor = const Color(0xffffffff);

  @override
  Widget build(BuildContext context) {
    Widget TextInputs(TextEditingController inputController, String hint,
        String text, BuildContext contex, bool isEditable) {
      const primaryColor = Color(0xffffffff);
      const secondaryColor = Color(0xff6D28D9);
      const accentColor = Color(0xffffffff);

      const errorColor = Color(0xffEF4444);
      inputController.text = text;
      editEditable(String text) {
        setState(() {
          switch (text) {
            case "Startzeit":
              startTimeEditable = true;
              break;
            case "Stoppzeit":
              endTimeEditable = true;
              break;
            case "Tag":
              dateEditable = true;
              break;
          }
        });
      }

      return Container(
          height: 70,
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width / 2.1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            offset: const Offset(12, 26),
                            blurRadius: 50,
                            spreadRadius: 0,
                            color: Colors.grey.withOpacity(.1)),
                      ]),
                      child: TextField(
                        enabled: isEditable,
                        controller: inputController,
                        onChanged: (value) {
                          //Do something wi
                        },
                        keyboardType: TextInputType.emailAddress,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.black),
                        decoration: InputDecoration(
                          label: Text(hint),
                          labelStyle: const TextStyle(color: primaryColor),
                          // prefixIcon: Icon(Icons.email),
                          filled: true,
                          fillColor: secondaryColor,
                          hintText: hint,
                          hintStyle:
                              TextStyle(color: Colors.grey.withOpacity(.75)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 20.0),
                          border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColor, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: secondaryColor, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: errorColor, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide:
                                BorderSide(color: primaryColor, width: 1.0),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width / 4.8,
                child: CircleAvatar(
                    backgroundColor: primaryColor,
                    radius: 10,
                    child: IconButton(
                      onPressed: () {
                        editEditable(hint);
                      },
                      icon: Icon(
                        Icons.edit,
                      ),
                    )),
              )
            ],
          ));
    }

    bool startTimeIsEdiable = false;
    return Dialog(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.4,
        height: MediaQuery.of(context).size.height / 1.5,
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(12, 26),
                  blurRadius: 50,
                  spreadRadius: 0,
                  color: Colors.grey.withOpacity(.1)),
            ]),
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextInputs(startTimeController, "Startzeit", statistic.startTime,
                  context, startTimeEditable),
              TextInputs(endTimeController, "Stoppzeit", statistic.endTime,
                  context, endTimeEditable),
              TextInputs(
                  dateController, "Tag", statistic.date, context, dateEditable),
              TextInputs(blankController, "User", statistic.user_name, context,
                  nameEditable),
              TextInputs(blankController, "ID", statistic.statistic_id, context,
                  idEditable),
              SizedBox(height: 10),
              Container(
                height: 40,
                color: Colors.green,
                width: MediaQuery.of(context).size.width,
                child: CircleAvatar(
                    backgroundColor: Color(0xFF00570E),
                    radius: 10,
                    child: IconButton(
                      color: Colors.white,
                      onPressed: () {},
                      icon: Icon(
                        Icons.save,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
