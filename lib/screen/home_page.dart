import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoset/func/auth_service.dart';
import 'package:todoset/func/add_tasks.dart';
import 'package:intl/intl.dart';
import 'package:todoset/func/edit_set_main.dart';
import 'package:todoset/func/edit_tasks.dart';
import 'package:todoset/components/constant.dart';
import '../func/edit_set_tasks.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

final uid = AuthHelper().getCurrentUID();
int remain = 24 - (TimeOfDay.now().hour);

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  //Stream
  final Stream<QuerySnapshot> _todayTaskStream = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('Tasks')
      .where('date', isLessThanOrEqualTo: DateTime.now().add(Duration(hours: remain)))
      .orderBy('date')
      .snapshots(includeMetadataChanges: true);

  final Stream<QuerySnapshot> _tomorrowTaskStream = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('Tasks')
      .where('date', isGreaterThan: DateTime.now())
      .where('date', isLessThanOrEqualTo: DateTime.now().add(Duration(days: 1, hours: remain)))
      .orderBy('date')
      .snapshots(includeMetadataChanges: true);

  final Stream<QuerySnapshot> _upcomingTaskStream = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('Tasks')
      .where('date', isGreaterThan: DateTime.now().add(Duration(days: 1, hours: remain)))
      .orderBy('date')
      .snapshots(includeMetadataChanges: true);

  //Collection References
  CollectionReference tasks = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('Tasks');

  List<String> doneTasks = [];

  Future<void>? deleteDoneTasks() {
    for (int i = 0; i < doneTasks.length; i++) {
      tasks.doc(doneTasks[i]).delete();
    }
    doneTasks.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'ToDoList',
        ),
        actions: [
          TextButton(
              onPressed: () {
                setState(() {
                  deleteDoneTasks();
                });
              },
              child: const Text(
                'Clear',
                style: TextStyle(fontSize: 23, color: Colors.white),
              ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, AddTasks.id);
        },
        child: const Icon(
          CupertinoIcons.add,
          color: Color(0xFFFFFFFF),
          size: 31,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        physics: const ScrollPhysics(),
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(5),
          children: [
            dayExpansionTile(title: "Today", taskStream: _todayTaskStream),
            dayExpansionTile(title: "Tomorrow", taskStream: _tomorrowTaskStream),
            dayExpansionTile(title: "Upcoming", taskStream: _upcomingTaskStream),
          ],
        ),
      ),
    );
  }
  
  Widget dayExpansionTile({
    required String title,
    required Stream<QuerySnapshot> taskStream,
  })
  
  {
    return ExpansionTile(
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      controlAffinity: ListTileControlAffinity.leading,
      backgroundColor: kBackgroundColor,
      collapsedBackgroundColor: kCollapsedBackgroundColor,
      childrenPadding: const EdgeInsets.all(5),
      children: [
        const Divider(
          height: 1,
          thickness: 2,
          color: Color(0xFFF8C0C8),
        ),
        StreamBuilder(
            stream: taskStream,
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data =
                      snapshot.data!.docs[index].data()
                      as Map<String, dynamic>;
                      return data['setName'] == ""
                          ? toDoTile(
                          title: data['subName'].toString(),
                          tag: data['type'].toString(),
                          isChecked:
                          data['isDone'] == 0 ? false : true,
                          id: snapshot.data!.docs[index].id,
                          date: (data['date'] as Timestamp).toDate(),
                          doc: data,
                          set: data['set'])
                          : setToDoTile(
                          title: data['subName'].toString(),
                          tag: data['type'].toString(),
                          isChecked:
                          data['isDone'] == 0 ? false : true,
                          id: snapshot.data!.docs[index].id,
                          setName: data['setName'],
                          deadline: (data['deadline'] as Timestamp)
                              .toDate(),
                          date: (data['date'] as Timestamp).toDate(),
                          setPath: data['setPath'].toString(),
                          doc: data,
                      );
                    });
              } else {
                return const Text("");
              }
            })
      ],
    );
  }
  

  Widget setToDoTile({
    required String title,
    required String tag,
    required bool isChecked,
    required String id,
    required String setName,
    required DateTime deadline,
    required DateTime date,
    required String setPath,
    required Map<String, dynamic> doc,
  }) {
    DocumentReference _updateTasks = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('Tasks')
        .doc(id);

    if (isChecked == true) {
      doneTasks.add(id);
    }

    return Column(
      children: [
        InkWell(
          onDoubleTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (builder) => EditSetTasks(
                      document: doc,
                      docID: id,
                    )));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                Checkbox(
                    value: isChecked,
                    checkColor: const Color(0xFFFFFFFF),
                    onChanged: (bool? value) {
                      _updateTasks.update({"isDone": value == true ? 1 : 0});
                      setState(() {
                        value == true
                            ? doneTasks.add(id)
                            : doneTasks.remove(id);
                      });
                    }),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                    Text(
                      "setName: $setName",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    Text(
                      "Deadline : ${DateFormat("dd/MM/yyyy").format(deadline).toString()}",
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ],
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Chip(
                      label: Text(
                        tag,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      padding: const EdgeInsets.all(10),
                      backgroundColor: Colors.white),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Text(DateFormat.Hm().format(date).toString(),
                          style: Theme.of(context).textTheme.headline4),
                      Text(DateFormat("dd/MM/yyyy").format(date).toString(),
                          style: Theme.of(context).textTheme.headline4),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget toDoTile({
    required String title,
    required String tag,
    required bool isChecked,
    required String id,
    required DateTime date,
    required Map<String, dynamic> doc,
    required bool set,
  }) {
    DocumentReference _updateTasks = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('Tasks')
        .doc(id);

    if (isChecked == true) {
      doneTasks.add(id);
    }

    return Column(
      children: [
        InkWell(
          onDoubleTap: () {
            if(set == false) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (builder) => EditTasks(
                        document: doc,
                        docID: id,
                      ),
                  ),
              );
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (builder) => EditSetMain(
                document: doc,
                docID: id,
                  ),),);
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                      value: isChecked,
                      checkColor: const Color(0xFFFFFFFF),
                      onChanged: (bool? value) {
                        _updateTasks.update({"isDone": value == true ? 1 : 0});
                        setState(() {
                          value == true
                              ? doneTasks.add(id)
                              : doneTasks.remove(id);
                        });
                      }),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ],
              ),
              Row(
                children: [
                  Chip(
                      label: Text(
                        tag,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      padding: const EdgeInsets.all(10),
                      backgroundColor: Colors.white),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    children: [
                      Text(DateFormat.Hm().format(date).toString(),
                      style: Theme.of(context).textTheme.headline4),
                      Text(DateFormat("dd/MM/yyyy").format(date).toString(),
                          style: Theme.of(context).textTheme.headline4),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
