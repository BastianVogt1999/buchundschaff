import 'dart:async';

import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_admin/UserManagement/user_operations/add_user.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_admin/full_stats_admin.dart';
import 'package:itm_ichtrinkmehr_flutter/global_methods.dart';
import 'package:itm_ichtrinkmehr_flutter/values/colors.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/update_statements.dart';
import 'package:sizer/sizer.dart';

SelectStatements selectStatements = SelectStatements();
GlobalMethods globalmethods = GlobalMethods();
UpdateStatements updateStatements = UpdateStatements();

WhiteMode whiteMode = WhiteMode();
List<User> currentUser = [];

TextEditingController searchField = TextEditingController();
TextEditingController controllerUserName = TextEditingController();
List<TextEditingController> controllerUserEdit = [];
List<bool> sizeOfUserEditFields = [];
List<bool> sizeOfDeleteFields = [];

class allUser extends StatefulWidget {
  allUser(this.company);
  Company company;
  @override
  State<allUser> createState() => _allUserState(company);
}

class _allUserState extends State<allUser> {
  Company company;
  bool shownAddUser = false;
  bool checkBoxUserIsAdminSelected = false;
  late StreamController<List<User>> currentStream =
      StreamController<List<User>>();

  Future<void> closeStream() => currentStream.close();

  @override
  void initState() {
    super.initState();
    currentStream = StreamController<List<User>>();
  }

  @override
  void dispose() {
    super.dispose();
    closeStream();
  }

  _allUserState(this.company);
  @override
  Widget build(BuildContext context) {
    _getUserServer() async {
      List<User> allUser =
          await selectStatements.selectAllUserOfCompany(company);

      controllerUserEdit = [];
      for (int i = 0; i < allUser.length; i++) {
        sizeOfUserEditFields.add(false);
        sizeOfDeleteFields.add(false);
        controllerUserEdit
            .add(TextEditingController(text: allUser[i].user_name));
      }

      currentUser = allUser;

      currentStream.add(allUser);
    }

    Widget deleteUser(int index) {
      return SizedBox(
          height: sizeOfDeleteFields[index] ? 24.h : 0,
          child: Container(
              padding: EdgeInsets.all(10.sp),
              color: Colors.red.withOpacity(0.8),
              width: 100.w,
              child: Column(
                children: [
                  Flexible(
                    flex: 7,
                    child: Container(
                        child: Text("Wirklich löschen?",
                            style: TextStyle(fontSize: 20.sp))),
                  ),
                  Flexible(flex: 4, child: SizedBox(height: 30.h)),
                  Flexible(
                    flex: 7,
                    child: Container(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 7,
                            child: Container(
                                decoration: BoxDecoration(
                                  color: whiteMode.cardColor,
                                  border: Border.all(
                                      width: 2, color: whiteMode.abstractColor),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                ),
                                alignment: Alignment.bottomCenter,
                                child: ListTile(
                                  title: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: whiteMode.abstractColor,
                                      child: Icon(
                                        Icons.cancel,
                                        color: whiteMode.backgroundColor,
                                      )),
                                )),
                          ),
                          Flexible(flex: 1, child: SizedBox(width: 10.w)),
                          Flexible(
                            flex: 7,
                            child: Container(
                                decoration: BoxDecoration(
                                  color: whiteMode.cardColor,
                                  border: Border.all(
                                      width: 2, color: whiteMode.abstractColor),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                ),
                                alignment: Alignment.bottomCenter,
                                child: ListTile(
                                  onTap: (() async {
                                    await deleteStatements.deleteUser(
                                        company, currentUser[index]);

                                    controllerUserEdit.removeAt(index);

                                    _getUserServer();
                                  }),
                                  title: CircleAvatar(
                                      radius: 20,
                                      backgroundColor: whiteMode.abstractColor,
                                      child: Icon(
                                        Icons.delete,
                                        color: whiteMode.backgroundColor,
                                      )),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )));
    }

    Widget editUserName(int index) {
      //Edit Card
      return SizedBox(
          height: sizeOfUserEditFields[index] ? 24.h : 0,
          child: Column(
            children: [
              Container(
                width: 80.w,
                color: whiteMode.cardColor,
                child: ListTile(
                  title: TextField(
                    controller: controllerUserEdit[index],
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: controllerUserEdit[index].text,
                      hintStyle: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.w300),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 20.0),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(45.0)),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.all(Radius.circular(45.0)),
                      ),
                    ),
                  ),
                  trailing: CircleAvatar(
                    backgroundColor: whiteMode.abstractColor,
                    child: IconButton(
                        icon: const Icon(Icons.save_as_outlined),
                        iconSize: 20.sp,
                        color: whiteMode.backgroundColor,
                        onPressed: () {
                          User usrCopy = currentUser[index];
                          usrCopy.user_name = controllerUserEdit[index].text;

                          if (usrCopy.user_name !=
                              currentUser[index].user_name) {
                            setState(() {
                              sizeOfDeleteFields[index] = false;
                              sizeOfUserEditFields[index] = false;
                            });
                            updateStatements.updateUser(company, usrCopy);
                          }
                        }),
                  ),
                ),
              ),
              SizedBox(height: (0.5).h),
              Container(
                  width: 80.w,
                  color: whiteMode.cardColor,
                  child: ListTile(
                    title: Text("User-Code: " + currentUser[index].user_code),
                    trailing: CircleAvatar(
                        backgroundColor: whiteMode.abstractColor,
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete,
                          ),
                          iconSize: 20.sp,
                          color: whiteMode.redLight,
                          onPressed: () {
                            setState(() {
                              sizeOfUserEditFields[index] = false;
                              sizeOfDeleteFields[index] = true;
                            });
                          },
                        )),
                  )),
              SizedBox(height: (0.5).h),
              Container(
                  width: 80.w,
                  color: whiteMode.cardColor,
                  child: ListTile(
                    title: Text("Adminrechte: " +
                        (currentUser[index].is_admin == "true"
                            ? "ja"
                            : "nein")),
                    trailing: CircleAvatar(
                      backgroundColor: whiteMode.abstractColor,
                      child: IconButton(
                          icon: const Icon(Icons.admin_panel_settings),
                          color: currentUser[index].is_admin == "true"
                              ? Colors.green
                              : whiteMode.redLight,
                          iconSize: 20.sp,
                          onPressed: () async {
                            await updateStatements.updateUserAdminRight(
                                company, currentUser[index]);
                            setState(() {});
                          }),
                    ),
                  )),
            ],
          ));
    }

    // ignore: non_constant_identifier_names
    Widget RoundedSearchInput() {
      return Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              offset: const Offset(12, 26),
              blurRadius: 50,
              spreadRadius: 0,
              color: Colors.grey.withOpacity(.1)),
        ]),
        child: TextField(
          controller: searchField,
          onSubmitted: (value) {},
          onChanged: (value) {
            List<User> newUsers = [];

            if (searchField.text == "") {
            } else {
              for (int i = 0; i < currentUser.length; i++) {
                if (currentUser[i]
                    .user_name
                    .toLowerCase()
                    .contains(value.toLowerCase())) {
                  newUsers.add(currentUser[i]);
                }
              }
            }
            currentUser = newUsers;

            currentStream.add(currentUser);
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey[500],
            ),
            filled: true,
            fillColor: Colors.white,
            hintText: "user suchen",
            hintStyle: const TextStyle(
                color: Colors.grey, fontWeight: FontWeight.w300),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(45.0)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
              borderRadius: BorderRadius.all(Radius.circular(45.0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.5),
              borderRadius: BorderRadius.all(Radius.circular(45.0)),
            ),
          ),
        ),
      );
    }

    _getUserServer();

    Widget addUser() {
      return SizedBox(
          height: shownAddUser ? 20.h : 0.h,
          child: Column(children: [
            Container(
              width: 80.w,
              color: whiteMode.cardColor,
              child: ListTile(
                onTap: () {
                  setState(() {
                    checkBoxUserIsAdminSelected
                        ? checkBoxUserIsAdminSelected = false
                        : checkBoxUserIsAdminSelected = true;
                  });
                },
                title: const Text(
                  "Admin-Rechte: ",
                  style: TextStyle(fontSize: 20),
                ),
                trailing: Icon(checkBoxUserIsAdminSelected
                    ? Icons.check_box
                    : Icons.crop_square_sharp),
              ),
            ),
            SizedBox(height: 1.h),
            Container(
              width: 80.w,
              color: whiteMode.cardColor,
              child: ListTile(
                title: TextField(
                  controller: controllerUserName,
                  decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "User-Name",
                    hintStyle: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w300),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(45.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(45.0)),
                    ),
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.save, size: 30, color: Colors.green),
                  onPressed: () {
                    User newUser = User.empty();
                    newUser.user_name = controllerUserName.text;
                    newUser.is_admin = checkBoxUserIsAdminSelected.toString();

                    insertStatements.insertNewUser(company, newUser);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      backgroundColor: Colors.green,
                      content: Text("User hinzugefügt"),
                      duration: Duration(milliseconds: 2500),
                    ));
                    currentUser.add(newUser);
                    controllerUserEdit
                        .add(TextEditingController(text: newUser.user_name));
                    _getUserServer();
                    setState(() {
                      controllerUserName.text = "";
                      checkBoxUserIsAdminSelected = false;
                      shownAddUser = false;
                    });
                  },
                ),
              ),
            ),
          ]));
    }

    Widget CurrentUserWidget() {
      return AnimatedSize(
          curve: Curves.easeIn,
          duration: const Duration(milliseconds: 500),
          child: Container(
              color: whiteMode.backgroundColor,
              height: !shownAddUser ? 60.h : 40.h,
              child: ListView.builder(
                  itemCount: currentUser.length,
                  itemBuilder: (context, index) {
                    return AnimatedSize(
                        curve: Curves.easeIn,
                        duration: const Duration(milliseconds: 500),
                        child: SizedBox(
                            height: (sizeOfUserEditFields[index] ^
                                    sizeOfDeleteFields[index])
                                ? 33.h
                                : 9.h,
                            child: Column(
                              children: [
                                //User Card
                                Card(
                                  color: whiteMode.abstractColor,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: ListTile(
                                      onTap: () {
                                        setState(() {
                                          sizeOfUserEditFields[index]
                                              ? sizeOfUserEditFields[index] =
                                                  false
                                              : sizeOfUserEditFields[index] =
                                                  true;

                                          if (sizeOfDeleteFields[index]) {
                                            sizeOfDeleteFields[index] = false;
                                          }
                                        });
                                      },
                                      title: Text(
                                        currentUser[index].user_name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                      leading: CircleAvatar(
                                          backgroundColor:
                                              whiteMode.backgroundColor,
                                          child: Icon(
                                            Icons.person,
                                            color: whiteMode.abstractColor,
                                          )),
                                      trailing: Icon(
                                        !(sizeOfUserEditFields[index] ^
                                                sizeOfDeleteFields[index])
                                            ? Icons.mode_edit_outline_outlined
                                            : Icons.arrow_right,
                                        size: 30,
                                        color: whiteMode.backgroundColor,
                                      ),
                                    ),
                                  ),
                                ),

                                editUserName(index),
                                deleteUser(index)
                              ],
                            )));
                  })));
    }

    return StreamBuilder(
      stream: currentStream.stream,
      builder: (context, snapshot) {
// Checking if future is resolved
        return snapshot.hasData
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                    child: Column(children: [
                  const Divider(height: 20),
                  SizedBox(
                    height: 50,
                    child: RoundedSearchInput(),
                  ),
                  const Divider(height: 20),
                  CurrentUserWidget(),
                  Divider(height: 4.h),
                  Container(
                    color: whiteMode.abstractColor,
                    child: ListTile(
                      tileColor: whiteMode.abstractColor,
                      onTap: () {
                        setState(
                          () {
                            shownAddUser
                                ? shownAddUser = false
                                : shownAddUser = true;
                          },
                        );
                      },
                      title: Text(
                        !shownAddUser ? "User hinzufügen" : "Abbrechen",
                        style: TextStyle(
                            fontSize: 20, color: whiteMode.backgroundColor),
                      ),
                      leading: Icon(
                        !shownAddUser ? Icons.add : Icons.close,
                        color: whiteMode.backgroundColor,
                      ),
                      //trailing: Text("\$ ${stocksList[index].price}"),
                    ),
                  ),
                  addUser()
                ])))
            : const Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
