import 'package:flutter/material.dart';
import 'package:wordpress_image_upload/service/api_service.dart';
import 'package:wordpress_image_upload/utils/ProgressHUD.dart';
import 'package:wordpress_image_upload/utils/form_helper.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String _username = "";
  String _pwd = "";
  bool isApiCallProcess = false;
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        key: _scaffoldKey,
        body: ProgressHUD(
          child: loginUISetup(),
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
        ),
      ),
    );
  }

  Widget loginUISetup() {
    return new SingleChildScrollView(
      child: new Container(
        //margin: new EdgeInsets.all(15.0),
        child: new Form(
          key: globalFormKey,
          child: _loginUI(context),
        ),
      ),
    );
  }

  Widget _loginUI(BuildContext context) {
    return new SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.redAccent,
                  Colors.redAccent,
                ],
              ),
              borderRadius: BorderRadius.only(
                // topLeft: Radius.circular(500),
                //  topRight: Radius.circular(150),
                //bottomRight: Radius.circular(150),               
                bottomLeft: Radius.circular(150),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: Image.network(
                    "https://avatars.githubusercontent.com/u/64971583?s=460&u=ccc349dd8eaafbfa73533c3316d7d729ec223e9b&v=4",
                    fit: BoxFit.contain,
                    width: 140,
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20, top: 40),
              child: Text(
                "Login",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20, top: 20),
            child: FormHelper.inputFieldWidget(
                context, Icon(Icons.verified_user), "name", "Username",
                (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return 'Username can\'t be empty.';
              }

              return null;
            }, (onSavedVal) => {_username = onSavedVal.toString().trim()},
                initialValue: ""),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: FormHelper.inputFieldWidget(
              context,
              Icon(Icons.lock),
              "password",
              "Password",
              (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return 'Password can\'t be empty.';
                }

                return null;
              },
              (onSavedVal) => {_pwd = onSavedVal.toString().trim()},
              initialValue: "",
              obscureText: hidePassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
                color: Colors.redAccent.withOpacity(0.4),
                icon: Icon(
                  hidePassword ? Icons.visibility_off : Icons.visibility,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          new Center(
            child: FormHelper.saveButton(
              "Login",
              () {
                if (validateAndSave()) {
                  setState(() {
                    this.isApiCallProcess = true;
                  });

                  APIServices.loginCustomer(_username, _pwd).then((response) {
                    setState(() {
                      this.isApiCallProcess = false;
                    });
                    if (response) {
                      globalFormKey.currentState.reset();
                      Navigator.of(context).pushReplacementNamed('/home');
                    } else {
                      FormHelper.showMessage(
                        context,
                        "Wordpress Login",
                        "Invalid Username/Password!!",
                        "Ok",
                        () {
                          Navigator.of(context).pop();
                        },
                      );
                    }
                  });
                }
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
