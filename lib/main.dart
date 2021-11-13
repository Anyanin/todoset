import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoset/func/add_set.dart';
import 'package:todoset/func/add_tasks.dart';
import 'package:todoset/screen/login_page.dart';
import 'package:todoset/screen/set_page.dart';
import 'package:todoset/screen/setting_page.dart';
import 'package:todoset/screen/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todoset/screen/home_page.dart';
import 'package:todoset/func/navi_bottom.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Color(0xFFF5B2B1),
          toolbarHeight: 70,
          titleTextStyle: TextStyle(
              color: Color(0xFFFFFFFF),
              fontFamily: 'FCDaisy',
              fontSize: 35,
          ),
            titleSpacing: 20,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFBF3880),
          selectedItemColor: Color(0xFFFFFFFF),
          selectedLabelStyle: TextStyle(
            fontFamily: "FCDaisy",
            fontSize: 20,
            color: Color(0xFFFFFFFF),
          ),
          unselectedLabelStyle: TextStyle(
            fontFamily: "FCDaisy",
            fontSize: 20,
            color: Color(0xFFFFFFFF),
          ),
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFF12E90),
          splashColor: Color(0xFFFF8BDA),
        ),

        textTheme: const TextTheme(
          bodyText1: TextStyle(color: Color(0xFF707070), fontFamily: 'FCDaisy', fontSize: 27),
          bodyText2: TextStyle(color: Color(0xFF707070), fontFamily: 'FCDaisy', fontSize: 22), // day - calendar
          headline3: TextStyle(color: Color(0xFF707070), fontFamily: 'FCDaisy', fontSize: 23), //home - title todoTile
          headline4: TextStyle(color: Color(0xFF707070), fontFamily: 'FCDaisy', fontSize: 21), //home- subtitle
            headline5: TextStyle(color: Color(0xFFD43790), fontFamily: 'FCDaisy', fontSize: 27),
            headline6: TextStyle(color: Color(0xFFD8A7B1), fontFamily: 'FCDaisy', fontSize: 22), //body for add&edit tasks - set tasks
            subtitle1: TextStyle(color: Color(0xFF707070), fontFamily: 'FCDaisy', fontSize: 22),
          subtitle2: TextStyle(color: Color(0xFFE98980), fontFamily: 'FCDaisy', fontSize: 21),
          button: TextStyle(color: Color(0xFF947360), fontFamily: 'FCDaisy', fontSize: 29)
        ),

        dividerTheme: const DividerThemeData(
          color: Color(0xFFEF7C8E),
          thickness: 1,
          indent: 5,
          endIndent: 5,
        ),

        dialogTheme: const DialogTheme(
          titleTextStyle:  TextStyle(color: Color(0xFF707070), fontSize: 29),
          contentTextStyle: TextStyle(color: Color(0xFF707070), fontSize: 23),
        ),

        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Color(0xFFFFFFFF),
          hintStyle: TextStyle(color: Colors.grey, fontSize: 23),
          contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 20.0),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFF707070), width: 1.0),
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF707070), width: 2.0),
              borderRadius: BorderRadius.all(Radius.circular(10.0),
              ),
          ),
        ),

      ),
      debugShowCheckedModeBanner: false,
      initialRoute: LogInPage.id,
      routes: {
        LogInPage.id: (context) => const LogInPage(),
        SignUpPage.id: (context) => const SignUpPage(),
        HomePage.id: (context) => const HomePage(),
        NavBar.id: (context) => const NavBar(),
        AddTasks.id: (context) => const AddTasks(),
        SetPage.id: (context) => const SetPage(),
        AddSet.id: (context) => const AddSet(),
        SettingPage.id: (context) => const SettingPage(),
      },
    );
  }
}