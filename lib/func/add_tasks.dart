import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:todoset/components/component_object.dart';
import 'package:todoset/components/constant.dart';
import 'package:todoset/func/auth_service.dart';
import 'tasks_class.dart';

class AddTasks extends StatefulWidget {
  static const String id = 'add_tasks';
  const AddTasks({Key? key}) : super(key: key);

  @override
  _AddTasksState createState() => _AddTasksState();
}

final String? uid = AuthHelper().getCurrentUID();

class _AddTasksState extends State<AddTasks> {
  @override
  void initState() {
    super.initState();
    addList();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    subTasksList.clear();
    super.dispose();
  }

  //instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //valuable
  String selectedTag = "";
  DateTime deadline = DateTime.now();
  bool todoSet = false;
  DateTime subDeadline = DateTime.now();
  late CollectionReference<Object?> mainID;
  late bool duplicateName;
  late dynamic data;
  String setPath = "";

  //Create List for Sub Task(s)
  List<SubTasksDetails> subTasksList = [];

  //Text Editing Controller
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();

  //Add Empty List
  void addList() {
    subTasksList.add(
      SubTasksDetails(
        subName: "",
        date: subDeadline,
      ),
    );
  }

  //Collection Reference
  CollectionReference tasks = FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .collection("Tasks");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 150,
                        child: TextFormField(
                          controller: _titleController,
                          style: Theme.of(context).textTheme.headline6,
                          decoration: const InputDecoration(
                            hintText: "Please Enter Title Task",
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          todoSet
                              ? Text("ToDoSet", style: Theme.of(context).textTheme.subtitle2)
                              : Text("ToDoList", style: Theme.of(context).textTheme.subtitle2),
                          Switch.adaptive(
                            value: todoSet,
                            activeColor: const Color(0xFFF8AFA6),
                            activeTrackColor: const Color(0xFFFADCD9),
                            inactiveTrackColor: const Color(0xFFD48C70),
                            onChanged: (value) =>
                                setState(() => todoSet = value),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: kDividerContainer,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(23),
                        bottomRight: Radius.circular(23),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Type :",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Row(
                    children: [
                      tagButton(
                          context: context,
                          onTap: () {
                            setState(() {
                              selectedTag = "Work";
                            });
                          },
                          label: "Work",
                          selectedTag: selectedTag),
                      tagButton(
                          context: context,
                          onTap: () {
                            setState(() {
                              selectedTag = "Home";
                            });
                          },
                          label: "Home",
                          selectedTag: selectedTag),
                      tagButton(
                          context: context,
                          onTap: () {
                            setState(() {
                              selectedTag = "School";
                            });
                          },
                          label: "School",
                          selectedTag: selectedTag),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Deadlines :",
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    padding: const EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color(0xFFFBE7C6), width: 2.3),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          (DateFormat("dd/MM/yyyy")
                              .add_Hm()
                              .format(deadline)
                              .toString()),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        IconButton(
                          onPressed: () {
                            pickDateTime(context);
                          },
                          icon: const Icon(
                            Ionicons.calendar_clear_outline,
                            color: Color(0xFF707070),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  todoSet
                      ? Text(
                          "SubTask(s) :",
                          style: Theme.of(context).textTheme.headline5,
                        )
                      : Text(
                          "Details :",
                          style: Theme.of(context).textTheme.headline5,
                        ),
                  todoSet
                      ? Container(
                            alignment: Alignment.topLeft,
                            height: 200,
                            margin:
                                const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              border: Border.all(
                                  color: const Color(0xFFFBE7C6), width: 2.3),
                            ),
                            child: SingleChildScrollView(
                              reverse: true,
                              physics: const ScrollPhysics(),
                              child: Column(
                                children: [
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: subTasksList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return addSubTasks1(index);
                                      }),
                                ],
                              ),
                            ),
                          )
                      : Container(
                        margin:
                            const EdgeInsets.symmetric(horizontal: 10),
                        child: TextFormField(
                          controller: _detailsController,
                          style: Theme.of(context).textTheme.headline6,
                          maxLines: 5,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(20),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFBE7C6),
                                width: 2.3,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Color(0xFFFBE7C6),
                                width: 2.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Ionicons.close_circle_sharp,
                          color: Color(0xFFF85C70),
                          size: 50,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      IconButton(
                        alignment: Alignment.bottomRight,
                        onPressed: () async {
                          if(_titleController.text.isNotEmpty) {
                            switch(todoSet) {
                              case(false):
                                tasks.add({
                                  "subName" : _titleController.text,
                                  "setName" : "",
                                  "date" : deadline,
                                  "deadline" : DateTime.now(),
                                  "isDone" : 0,
                                  "type": selectedTag,
                                  "setPath" : "",
                                  "detail" : _detailsController.text,
                                  "set" : false,
                                }).then((value) => setState (() => setPath = value.id));
                                break;

                              case(true):
                                final docRef = await FirebaseFirestore.instance.collection('users').doc(uid).collection('Tasks').add({
                                  "subName": _titleController.text,
                                  "setName": "",
                                  "type": selectedTag,
                                  "date": deadline,
                                  "deadline" : deadline,
                                  "isDone": 0,
                                  "startDate": DateTime.now(),
                                  "setPath": "",
                                  "set": true,
                                });
                                setState(() {
                                  setPath = docRef.id;
                                });

                                subTasksList.removeWhere((item) => item.subName.isEmpty);
                                for (int i = 0; i < subTasksList.length; i++) {
                                  tasks.add({
                                    "setName": _titleController.text,
                                    "subName": subTasksList[i].subName,
                                    "date": subTasksList[i].date,
                                    "isDone": 0,
                                    "type": selectedTag,
                                    "deadline": deadline,
                                    "setPath": setPath
                                  });
                                }
                                break;
                            }
                            Navigator.pop(context);
                          }
                          else {
                            const snackBar = SnackBar(content: Text("Please Enter Title Task"));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        },
                        icon: const Icon(
                          Ionicons.checkmark_circle_sharp,
                          color: Color(0xFFEC8FD0),
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //pick dateTime for Main Task

  Future<DateTime?> pickDate(BuildContext context, DateTime value) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: value,
      firstDate: DateTime(DateTime.now().year - 3),
      lastDate: DateTime(DateTime.now().year + 3),
    );

    if (newDate == null) return null;

    return newDate;
  }

  Future<TimeOfDay?> pickTime(BuildContext context, DateTime value) async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(value),
    );

    if (newTime == null) return null;

    return newTime;
  }

  Future pickDateTime(BuildContext context) async {
    final date = await pickDate(context, deadline);
    if (date == null) return;

    final time = await pickTime(context, deadline);
    if (time == null) return;

    setState(() {
      deadline = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future pickDateTimeSub(BuildContext context, int index) async {
    final date = await pickDate(context, subDeadline);
    if (date == null) return;

    final time = await pickTime(context, subDeadline);
    if (time == null) return;

    setState(() {
      subDeadline = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      subTasksList[index].date = subDeadline;
    });
  }

  Widget addSubTasks1(int index) {
    return Column(
      children: [
        const SizedBox(height: 5),
        Row(
          children: [
            IconButton(
              disabledColor: Colors.black12,
              icon: const Icon(Ionicons.remove_circle_sharp),
              color: const Color(0xFFFFAEBC),
              onPressed: (){
                if(index == 0) { return; }
                else {subTasksList.removeAt(index);}
              },
            ),
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.7,
                  height: 40,
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Subtask's title"
                    ),
                    style: Theme.of(context).textTheme.headline6,
                    onChanged: (value) {
                      setState(() {
                        subTasksList[index].subName = value;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 3),
                Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width / 1.7,
                  padding: const EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: const Color(0xFFDCBAA9), width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat("dd/MM/yyyy")
                            .add_Hm()
                            .format(subTasksList[index].date)
                            .toString(),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            pickDateTimeSub(context, index);
                          });
                        },
                        icon: const Icon(
                          Ionicons.calendar_clear_outline,
                          color: Color(0xFF638C80),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  addList();
                });
              },
              icon: const Icon(
                Ionicons.add_circle_sharp,
                color: Color(0xFFFFAEBC),
              ),
            )
          ],
        ),
        const SizedBox(height: 5),
        const Divider(),
      ],
    );
  }
}