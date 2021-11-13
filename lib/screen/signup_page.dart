import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todoset/components/component_object.dart';
import 'package:todoset/func/auth_service.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  static const String id = 'signUp_page';

  const SignUpPage({Key? key}) : super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password_1st = TextEditingController();
  TextEditingController password_2nd = TextEditingController();
  AuthHelper authHelper = AuthHelper();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email.dispose();
    password_1st.dispose();
    password_2nd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            width: size.shortestSide - 70,
            height: 450,
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
                Positioned(
                    left: 10,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LogInPage.id);
                      },
                      icon: const Icon(
                        CupertinoIcons.arrow_left,
                        color: Colors.white,
                        size: 30,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 25.0,
                      ),
                      textFieldItem(
                          label: "Email",
                          obscure: false,
                          inputType: TextInputType.emailAddress,
                          controller: email,
                      context: context),
                      textFieldItem(
                          label: "Password (at least 6 characters)",
                          obscure: true,
                          inputType: TextInputType.text,
                          controller: password_1st,
                      context: context),
                      textFieldItem(
                          label: "Confirm Password",
                          obscure: true,
                          inputType: TextInputType.text,
                          controller: password_2nd,context: context),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () async {
                            if (password_1st.text == password_2nd.text) {
                              authHelper.signup(
                                  email: email.text,
                                  password: password_1st.text,
                                  context: context);
                            } else {
                              const snackBar = SnackBar(
                                  content: Text("Password do not match"));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          child: Text('Sign Up', style: Theme.of(context).textTheme.button),
                        ),
                      ),
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
