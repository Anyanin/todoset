import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:todoset/components/component_object.dart';
import 'package:todoset/func/navi_bottom.dart';
import 'package:todoset/screen/signup_page.dart';
import 'package:todoset/func/auth_service.dart';

class LogInPage extends StatefulWidget {
  static const String id = 'login_page';

  const LogInPage({Key? key}) : super(key: key);

  @override
  _LogInPageState createState() => _LogInPageState();
}

String? uid = AuthHelper().getCurrentUID();

class _LogInPageState extends State<LogInPage> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  AuthHelper authHelper = AuthHelper();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if(user != null) {
        Navigator.pushNamedAndRemoveUntil(context, NavBar.id, (route) => false);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            width: size.shortestSide - 70,
            height: 300,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color(0xFFF7CAC9),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(5, 4),
                  )
                ]),
            child: Stack(
              children: [
                const Hero(
                  tag: 'header',
                  child: TopObject(),
                ),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textFieldItem(
                          label: "Email",
                          obscure: false,
                          inputType: TextInputType.emailAddress,
                          controller: email,
                          context: context),
                      textFieldItem(
                          label: "Password",
                          obscure: true,
                          inputType: TextInputType.text,
                          controller: password,
                          context: context),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton(
                            onPressed: () async {
                              authHelper.login(
                                  email: email.text,
                                  password: password.text,
                                  context: context);
                            },
                            child: Text(
                              'Log In',
                              style: Theme.of(context).textTheme.button,
                            ),
                          ),
                          Text(
                            '|',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, SignUpPage.id);
                            },
                            child: Text(
                              'Sign Up',
                              style: Theme.of(context).textTheme.button,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
