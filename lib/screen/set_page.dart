import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:todoset/components/constant.dart';
import 'package:todoset/func/add_set.dart';
import 'package:todoset/func/auth_service.dart';
import 'package:todoset/func/edit_set.dart';
import 'package:intl/intl.dart';
import 'package:todoset/func/tasks_class.dart';

class SetPage extends StatefulWidget {
  static const String id = 'set_page';
  const SetPage({Key? key}) : super(key: key);

  @override
  _SetPageState createState() => _SetPageState();
}

String? uid = AuthHelper().getCurrentUID();

class _SetPageState extends State<SetPage> {
  @override
  void dispose() {
    setDetails.clear();
    super.dispose();
  }

  //Stream
  final Stream<QuerySnapshot> _setDetail = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('SetData')
      .snapshots(includeMetadataChanges: true);

  //List
  List<ToDoSetDetails> setDetails = [];

  List<ToDoSetDetails> addDataToList(dynamic set) {
    List<ToDoSetDetails> list = [];
    for (int i = 0; i < set.length; i++) {
      list.add(ToDoSetDetails(
          title: set[i]["subName"].toString(),
          day: set[i]["days"].toString(),
          condition: set[i]["condition"],
          startOrDeadline: set[i]["date"]));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('ToDoSet'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddSet.id);
        },
        child: const Icon(
          CupertinoIcons.add,
          color: Color(0xFFFFFFFF),
          size: 31,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        physics: const ScrollPhysics(),
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(5),
          children: [
            StreamBuilder(
                stream: _setDetail,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          Map<String, dynamic> data = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>;
                          var setDocument = snapshot.data!.docs[index];
                          dynamic setList = setDocument['setData'];
                          String docID = snapshot.data!.docs[index].id;
                          return ExpansionTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            backgroundColor: kBackgroundColor,
                            collapsedBackgroundColor: kCollapsedBackgroundColor,
                            childrenPadding: const EdgeInsets.only(left: 10),
                            title: Text(data['SetName'].toString()),
                            trailing: SizedBox(
                              width: 110,
                              child: Row(
                                children: [
                                  Chip(
                                    label: Text(data['type'].toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle1),
                                  ),
                                  PopupMenuButton(
                                    onSelected: (result) {
                                      switch (result) {
                                        case 0:
                                          setState(() {
                                            setDetails = addDataToList(setList);
                                          });
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return MyDialog(
                                                    setList: setDetails,
                                                    title: data["SetName"]
                                                        .toString(),
                                                    type: data["type"]
                                                        .toString());
                                              });
                                          break;

                                        case 1:
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (builder) => EditSet(
                                                  document: data,
                                                  id: docID,
                                                  setDetail: setList),
                                            ),
                                          );
                                          break;

                                        case 2:
                                          FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(uid)
                                              .collection('SetData')
                                              .doc(docID)
                                              .delete();
                                          break;
                                      }
                                    },
                                    child: const Icon(
                                        CupertinoIcons.ellipsis_vertical),
                                    itemBuilder: (BuildContext context) => [
                                      const PopupMenuItem(
                                        value: 0,
                                        child: Text('Select'),
                                      ),
                                      const PopupMenuItem(
                                        value: 1,
                                        child: Text('Edit'),
                                      ),
                                      const PopupMenuItem(
                                        value: 2,
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            children: [
                              ListView.builder(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  itemCount: setList.length,
                                  itemBuilder: (_, int index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(index.toString()),
                                            const SizedBox(width: 5),
                                            Text(
                                                " : ${setList[index]["subName"]}")
                                          ],
                                        ),
                                        const SizedBox(width: 20),
                                        Row(
                                          children: [
                                            Text(
                                                'Days : ${setList[index]["days"]}'),
                                            const SizedBox(width: 30),
                                            Text(setList[index]["condition"]
                                                .toString()),
                                            const SizedBox(width: 20),
                                            Text(setList[index]["date"]
                                                .toString()),
                                          ],
                                        ),
                                        const Divider(),
                                      ],
                                    );
                                  })
                            ],
                          );
                        });
                  }
                  if(snapshot.hasError) {
                    return const Text('no data');
                  }
                  else {
                    return const Text('Loading');
                  }
                })
          ],
        ),
      ),
    );
  }
}

class MyDialog extends StatefulWidget {
  const MyDialog(
      {Key? key,
      required this.setList,
      required this.title,
      required this.type})
      : super(key: key);
  final List<ToDoSetDetails> setList;
  final String title;
  final String type;

  @override
  _MyDialogState createState() => _MyDialogState();
}

class _MyDialogState extends State<MyDialog> {
  @override
  void initState() {
    super.initState();
    addDataToList();
  }

  @override
  void dispose() {
    weekendDay.clear();
    weekendList.clear();
    super.dispose();
  }

  List<Weekend> weekendList = [];
  List<int> weekendDay = [];

  void addDataToList() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("Weekend")
        .doc(uid)
        .get()
        .then((dynamic data) {
      setState(() {
        weekendList.add(Weekend(
            sunday: data["sunday"],
            monday: data["monday"],
            tuesday: data["tuesday"],
            wednesday: data["wednesday"],
            thursday: data["thursday"],
            friday: data["friday"],
            saturday: data["saturday"]));
      });
      setState(() {
        if (weekendList[0].sunday == true) {
          weekendDay.add(DateTime.sunday);
        }
        if (weekendList[0].monday == true) {
          weekendDay.add(DateTime.monday);
        }
        if (weekendList[0].tuesday == true) {
          weekendDay.add(DateTime.tuesday);
        }
        if (weekendList[0].wednesday == true) {
          weekendDay.add(DateTime.wednesday);
        }
        if (weekendList[0].thursday == true) {
          weekendDay.add(DateTime.thursday);
        }
        if (weekendList[0].friday == true) {
          weekendDay.add(DateTime.friday);
        }
        if (weekendList[0].saturday == true) {
          weekendDay.add(DateTime.saturday);
        }
        debugPrint(weekendDay.first.toString());
      });
    });
  }

  //Variable
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  late List<ToDoSetDetails> setDetails;
  List<GenerateSetTasks> newList = [];
  late String setTitle;
  late String tag;
  String setPath = "";
  DateTime newTime = DateTime.now();
  bool avoidWeekend = true;

  //Collection
  CollectionReference tasks = FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .collection("Tasks");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          color: Colors.white,
          width: 300,
          height: 400,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Select Date",
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(CupertinoIcons.clear))
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text("Avoid Weekend", style: TextStyle(fontSize: 18)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Switch.adaptive(
                    value: avoidWeekend,
                    activeColor: const Color(0xFFF8AFA6),
                    activeTrackColor: const Color(0xFFFADCD9),
                    inactiveTrackColor: const Color(0xFFD48C70),
                    onChanged: (value) =>
                        setState(() => avoidWeekend = value),
                  ),
                ],
              ),
              const Text("Start Date : "),
              SizedBox(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text((DateFormat("dd/MM/yyyy").format(startDate)).toString()),
                    IconButton(
                        onPressed: () {
                          pickStartDate(context);
                        },
                        icon: const Icon(CupertinoIcons.calendar))
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text("End Date : "),
              SizedBox(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text((DateFormat("dd/MM/yyyy").format(endDate)).toString()),
                    IconButton(
                        onPressed: () {
                          pickEndDate(context);
                        },
                        icon: const Icon(CupertinoIcons.calendar))
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 20),
                  IconButton(
                    onPressed: () async {
                      setState(() {
                        setDetails = widget.setList;
                        setTitle = widget.title;
                        tag = widget.type;
                      });

                      for (int i = 0; i < setDetails.length; i++) {
                        DateTime x =
                            setDetails[i].startOrDeadline == "Start Date"
                                ? startDate
                                : endDate;
                        int days = int.parse(setDetails[i].day);

                        if (setDetails[i].condition == "Before") {
                          setState(() {
                            newTime = x.subtract(Duration(days: days));
                          });
                        } else {
                          setState(() {
                            newTime = x.add(Duration(days: days));
                          });
                        }

                        if(avoidWeekend == true) {
                          int h = newTime.weekday;

                          if(weekendDay.contains(h)) {
                            do {
                              setState(() {
                                newTime = newTime.subtract(const Duration(days: 1));
                              });
                            } while (weekendDay.contains(newTime.weekday));
                          }
                        }


                        newList.add(GenerateSetTasks(
                            title: setDetails[i].title, date: newTime));
                        debugPrint("add List : ${newList[i].date.toString()}");
                      }

                      final docRef = await tasks.add({
                        "subName": setTitle,
                        "setName": "",
                        "type": tag,
                        "date": endDate,
                        "deadline": endDate,
                        "isDone": 0,
                        "startDate": startDate,
                        "setPath": "",
                        "set": true,
                      });
                      setState(() {
                        setPath = docRef.id;
                      });

                      for (int i = 0; i < newList.length; i++) {
                        tasks.add({
                          "setName": setTitle,
                          "subName": newList[i].title,
                          "date": newList[i].date,
                          "isDone": 0,
                          "type": tag,
                          "deadline": endDate,
                          "setPath": setPath
                        });
                      }

                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      CupertinoIcons.check_mark_circled_solid,
                      color: Color(0xFFF12E90),
                      size: 50,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<DateTime?> pickStartDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime(DateTime.now().year - 3),
      lastDate: DateTime(DateTime.now().year + 3),
    );

    if (newDate == null) return null;

    setState(() {
      startDate = DateTime(
        newDate.year,
        newDate.month,
        newDate.day,
      );
    });
  }

  Future<DateTime?> pickEndDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(DateTime.now().year - 3),
      lastDate: DateTime(DateTime.now().year + 3),
    );

    if (newDate == null) return null;

    setState(() {
      endDate = DateTime(
        newDate.year,
        newDate.month,
        newDate.day,
      );
    });
  }
}
