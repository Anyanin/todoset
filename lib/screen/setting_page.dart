import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoset/func/auth_service.dart';
import 'package:todoset/func/tasks_class.dart';

class SettingPage extends StatefulWidget {
  static const id = 'setting_page';
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

final String? uid = AuthHelper().getCurrentUID();
final String? emailUser = AuthHelper().getCurrentUser();

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            ListTile(
              title: Text("E-MAIL : ${emailUser!}",style: const TextStyle(
                fontSize: 30
              ),),
            ),
            const SizedBox(height: 10),
            const Divider(
              thickness: 3,
              color: Color(0xFFB9B7BD),
            ),
            ListTile(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return const SetWeekend();
                    });
              },
              title: const Text("Set Weekend"),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                AuthHelper().logout(context);
              },
              title: const Text("Sign Out"),
            ),
            const Divider(),
          ],
        ),
      )),
    );
  }
}

class SetWeekend extends StatefulWidget {
  const SetWeekend({Key? key}) : super(key: key);

  @override
  _SetWeekendState createState() => _SetWeekendState();
}

class _SetWeekendState extends State<SetWeekend> {
  @override
  void initState() {
    super.initState();
    getDataToList();
  }

  @override
  void dispose() {
    weekendSet.clear();
    super.dispose();
  }

  List<Weekend> weekendSet = [
    Weekend(
        sunday: false,
        monday: false,
        tuesday: false,
        wednesday: false,
        thursday: false,
        friday: false,
        saturday: false)
  ];

  CollectionReference weekend = FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .collection("Weekend");

  void getDataToList() {
    FirebaseFirestore.instance.collection("users").doc(uid).collection("Weekend").doc(uid).get()
    .then((dynamic data) {
      if(data != null) {
        setState(() {
          weekendSet[0].sunday = data["sunday"];
          weekendSet[0].monday = data["monday"];
          weekendSet[0].tuesday = data["tuesday"];
          weekendSet[0].wednesday = data["wednesday"];
          weekendSet[0].thursday = data["thursday"];
          weekendSet[0].friday = data["friday"];
          weekendSet[0].saturday = data["saturday"];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          height: 230,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //1st Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Set Weekend"),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(CupertinoIcons.clear)),
                ],
              ),
              const Divider(),
              //2nd Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  dayTile(
                      onTap: () {
                        setState(() {
                          weekendSet[0].sunday == true
                              ? weekendSet[0].sunday = false
                              : weekendSet[0].sunday = true;
                        });
                      },
                      title: "Sun",
                      isChecked: weekendSet[0].sunday),
                  dayTile(
                      onTap: () {
                        setState(() {
                          weekendSet[0].monday == true
                              ? weekendSet[0].monday = false
                              : weekendSet[0].monday = true;
                        });
                      },
                      title: "Mon",
                      isChecked: weekendSet[0].monday),
                  dayTile(
                      onTap: () {
                        setState(() {
                          weekendSet[0].tuesday == true
                              ? weekendSet[0].tuesday = false
                              : weekendSet[0].tuesday = true;
                        });
                      },
                      title: "Tue",
                      isChecked: weekendSet[0].tuesday),
                  dayTile(
                      onTap: () {
                        setState(() {
                          weekendSet[0].wednesday == true
                              ? weekendSet[0].wednesday = false
                              : weekendSet[0].wednesday = true;
                        });
                      },
                      title: "Wed",
                      isChecked: weekendSet[0].wednesday),
                  dayTile(
                      onTap: () {
                        setState(() {
                          weekendSet[0].thursday == true
                              ? weekendSet[0].thursday = false
                              : weekendSet[0].thursday = true;
                        });
                      },
                      title: "Thu",
                      isChecked: weekendSet[0].thursday),
                  dayTile(
                      onTap: () {
                        setState(() {
                          weekendSet[0].friday == true
                              ? weekendSet[0].friday = false
                              : weekendSet[0].friday = true;
                        });
                      },
                      title: "Fri",
                      isChecked: weekendSet[0].friday),
                  dayTile(
                      onTap: () {
                        setState(() {
                          weekendSet[0].saturday == true
                              ? weekendSet[0].saturday = false
                              : weekendSet[0].saturday = true;
                        });
                      },
                      title: "Sat",
                      isChecked: weekendSet[0].saturday),
                ],
              ),
              const SizedBox(height: 20),

              //3rd Row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                          weekend.doc(uid).set({
                            "sunday": weekendSet[0].sunday,
                            "monday": weekendSet[0].monday,
                            "tuesday": weekendSet[0].tuesday,
                            "wednesday": weekendSet[0].wednesday,
                            "thursday": weekendSet[0].thursday,
                            "friday": weekendSet[0].friday,
                            "saturday": weekendSet[0].saturday,
                          });
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        CupertinoIcons.check_mark_circled_solid,
                        color: Color(0xFFF12E90),
                        size: 30,
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget dayTile({
    required onTap,
    required String title,
    required bool isChecked,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isChecked == true
              ? const Color(0xFFE98980)
              : const Color(0xFFF9F1F0),
        ),
        child: Center(
          child: Text(title),
        ),
      ),
    );
  }
}
