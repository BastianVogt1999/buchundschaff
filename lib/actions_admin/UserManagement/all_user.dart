import 'package:flutter/material.dart';
import 'package:itm_ichtrinkmehr_flutter/actions_admin/UserManagement/user_operations/add_user.dart';
import 'package:itm_ichtrinkmehr_flutter/global_methods.dart';
import 'package:itm_ichtrinkmehr_flutter/intro/unternehmens_eingabe.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';
import 'package:lottie/lottie.dart';

SelectStatements selectStatements = SelectStatements();
GlobalMethods globalmethods = GlobalMethods();
_getUserServer(Company company) {
  try {
    return selectStatements.selectAllUserOfCompany(company);
  } catch (Exception) {
    print("Error while getting Data");
  }
}

class allUser extends StatefulWidget {
   allUser(this.company);
  Company company;
  @override
  State<allUser> createState() => _allUserState(company);
}

class _allUserState extends State<allUser> {
  Company company;

  _allUserState(this.company);
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
// Checking if future is resolved
        if (snapshot.connectionState == ConnectionState.done) {
// If we got an error
          if (snapshot.connectionState == ConnectionState.waiting) {
             return globalmethods.loadingScreen();
          } else if (snapshot.hasData) {
// Extracting data from snapshot object
            final data = snapshot.data as List<User>;

            return Scrollbar(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(children: [
                      Divider(height: 20),
                      SizedBox(
                        height: 50,
                        child: RoundedSearchInput(),
                      ),
                      Divider(height: 20),
                      SizedBox(
                          height: 400,
                          child: ListView.builder(
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return Card(
                                    child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: ListTile(
                                    title: Text(
                                      data[index].user_name,
                                      style: TextStyle(
                                        fontSize: 20,
                                      ),
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Text(
                                        data[index].user_name[0],
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    //trailing: Text("\$ ${stocksList[index].price}"),
                                  ),
                                ));
                              })),
                      Divider(height: 20),
                      ListTile(
                        tileColor: Colors.white,
                        onTap: () {
                          // Call this in a function
                          showDialog<Dialog>(
                              context: context,
                              builder: (BuildContext context) =>
                                  DialogAddUser(company));
                        },
                        title: Text(
                          "User hinzufügen",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        leading: Icon(
                          Icons.add,
                        ),
                        //trailing: Text("\$ ${stocksList[index].price}"),
                      ),
                    ])));
          }
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      future: _getUserServer(company),
    );
  }
}

TextEditingController searchField = TextEditingController();

class RoundedSearchInput extends StatelessWidget {
  const RoundedSearchInput();

  @override
  Widget build(BuildContext context) {
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
        onChanged: (value) {
          //Do something wi
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[500],
          ),
          filled: true,
          fillColor: Colors.white,
          hintText: "user suchen",
          hintStyle:
              const TextStyle(color: Colors.grey, fontWeight: FontWeight.w300),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(45.0)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(45.0)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey, width: 1.5),
            borderRadius: BorderRadius.all(Radius.circular(45.0)),
          ),
        ),
      ),
    );
  }
}
