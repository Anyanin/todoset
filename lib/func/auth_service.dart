import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todoset/screen/login_page.dart';
import 'package:todoset/func/navi_bottom.dart';

class AuthHelper {
  final auth = FirebaseAuth.instance;
  late User loggedInUser;

  Future<void> _signUp(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: const Text('Registration success'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, LogInPage.id);
              },
              child: Text(
                'OK',
                style: Theme.of(context).textTheme.button,
              ),
            )
          ],
        ),
      );
    } catch (e) {
      String msg = e.toString();
      String errorMsg =
          (msg.substring(msg.indexOf(']'), msg.length)).substring(2);
      final snackBar = SnackBar(content: Text(errorMsg));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> _login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushNamedAndRemoveUntil(context, NavBar.id, (route) => false);
    } catch (e) {
      String msg = e.toString();
      String errorMsg =
          (msg.substring(msg.indexOf(']'), msg.length)).substring(2);
      final snackBar = SnackBar(content: Text(errorMsg));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  login(
      {required String email,
      required String password,
      required BuildContext context}) {
    _login(email: email, password: password, context: context);
  }

  signup(
      {required String email,
      required String password,
      required BuildContext context}) {
    _signUp(email: email, password: password, context: context);
  }

  logout(BuildContext context) {
    auth.signOut();
    Navigator.pushNamedAndRemoveUntil(context, LogInPage.id, (route) => false);
  }

  checkLogin(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const NavBar()));
    }
  }

  String getCurrentUser() {
    final user = auth.currentUser!;
    loggedInUser = user;
    return loggedInUser.email!;
  }

  String? getCurrentUID() {
    return auth.currentUser!.uid;
  }
}
