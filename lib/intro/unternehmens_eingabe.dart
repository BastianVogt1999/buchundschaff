import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:itm_ichtrinkmehr_flutter/global_methods.dart';
import 'package:itm_ichtrinkmehr_flutter/intro/rollen_input.dart';
import 'package:itm_ichtrinkmehr_flutter/values/company.dart';
import 'package:itm_ichtrinkmehr_flutter/values/user.dart';
import 'package:itm_ichtrinkmehr_flutter/web_db/select_statements.dart';

SelectStatements selectStatements = SelectStatements();
GlobalMethods globalMethods = GlobalMethods();

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => LoginPage_state();
}

class LoginPage_state extends State<LoginPage> {
 
  TextEditingController companyNameController = TextEditingController();
 bool pwdVisibility = false;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
        body: Container(

          //background
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

                      //Input Company-Code
                  TextFormField(
      controller: companyNameController,
      obscureText: !pwdVisibility,
      decoration: InputDecoration(
        hintText: "Unternehmenscode",

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white,
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
            color: Colors.white,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(25.0),
        ),
        suffixIcon: InkWell(
          onTap: () => setState(
            () => pwdVisibility = !pwdVisibility,
          ),
          child: Icon(
            pwdVisibility
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
      validator: (val) {
        if (val!.isEmpty) {
          return 'Required';
        }
        return null;
      },
    ),

    //
    SizedBox(height: 30),

    //Button weiter
    OutlinedButton(
        onPressed: () {
  
                        entered_code(context, companyNameController.text);
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(
            "Weiter",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.white),
          ),
          Icon(Icons.arrow_forward, color:Colors.white)
        ]),
        style: ButtonStyle(
            side: MaterialStateProperty.all(
                BorderSide(color: Colors.white, width: 1.4)),
            padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(vertical: 20, horizontal: 50)),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(40))))),
      ),
          
                ]))));
            }
          }
  

  entered_code(BuildContext context, String company_code) async {

    
 Company company = Company.empty();
try{
  company = await selectStatements.selectCompany(company_code);
}
catch(Exception){
print("error");
}

if(company.company_name!= ""){
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => RoleInput(company)));
}
else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    backgroundColor: Colors.red,
    content: Text("Unternehmen mit angegebenen Code nicht gefunden"),
    duration: Duration(milliseconds: 2500),
  ));
}

  
  }






















