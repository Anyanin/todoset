import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:todoset/components/constant.dart';
import 'package:todoset/func/auth_service.dart';
import 'package:todoset/func/tasks_class.dart';

class EditSetTasks extends StatefulWidget {
  const EditSetTasks({Key? key, required this.document, required this.docID}) : super(key: key);
  final Map<String, dynamic> document;
  final String docID;

  @override
  _EditSetTasksState createState() => _EditSetTasksState();
}

final String? uid = AuthHelper().getCurrentUID();

class _EditSetTasksState extends State<EditSetTasks> {
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.document["setName"]);
    type = widget.document["type"].toString();
    date = (widget.document["date"] as Timestamp).toDate();
    deadline = (widget.document["deadline"] as Timestamp).toDate();
    setPathSub = widget.document["setPath"].toString();
    _addDataToList();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
    subTasks.clear();
  }

  //instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //valuable
  late String type;
  late DateTime date;
  late DateTime deadline;
  late String setPathSub;

  //list
  List<SubTasksEditing> subTasks = [];

  //Text Editing Controller
  late final TextEditingController _titleController;

  //Collection Reference
  CollectionReference tasks = FirebaseFirestore.instance
      .collection("users")
      .doc(uid)
      .collection("Tasks");

  _addDataToList () {
    tasks.orderBy("date").get()
        .then((QuerySnapshot querySnapshot) {
          for (var doc in querySnapshot.docs) {
            if(doc["setPath"] == widget.document['setPath']) {
              setState(() {
                subTasks.add(
                    SubTasksEditing(
                        subName: doc["subName"].toString(),
                        setName: doc["setName"].toString(),
                        type: doc["type"].toString(),
                        date: (doc["date"] as Timestamp).toDate(),
                        deadline: (doc["deadline"] as Timestamp).toDate(),
                        setPath: doc["setPath"].toString(),
                        id: doc.id)
                );
              });
            }
          }
    });
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(18),
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.circular(10),
              //   border: Border.all(color: const Color(0xFF707070), width: 2),
              // ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width - 150,
                            child: TextFormField(
                              controller: _titleController,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .headline6,
                              decoration: const InputDecoration(
                                hintText: "Please Enter Title Task",
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Ionicons.close),),
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
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline5,
                      ),
                      Row(
                        children: [
                          tagButton(label: "Work"),
                          tagButton(label: "Home"),
                          tagButton(label: "School"),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Deadlines :",
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline5,
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
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyText1,
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
                      Text(
                        "SubTask(s) :",
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline5,
                      ),
                      Container(
                        height: 200,
                        alignment: Alignment.topLeft,
                        margin:
                        const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: const Color(0xFFFBE7C6), width: 2.3),
                        ),
                        child: SingleChildScrollView(
                          reverse: true,
                          physics: const ScrollPhysics(),
                          child: Column(
                            children: <Widget>[
                              ListView.builder(
                                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                                  shrinkWrap: true,
                                  physics:
                                  const NeverScrollableScrollPhysics(),
                                  itemCount: subTasks.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return subTasksList(index);
                                  }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: InkWell(
                      onTap: () {
                        if (_titleController.text.isNotEmpty) {
                          for(int i = 0; i < subTasks.length; i++) {
                            if(subTasks[i].id == "") {
                              tasks.add({
                                "subName": subTasks[i].subName,
                                "date": subTasks[i].date,
                                "type": type,
                                "deadline": deadline,
                                "setName": _titleController.text,
                                "setPath": setPathSub,
                                "isDone": 0,
                              });
                            }
                            else {
                              tasks.doc(subTasks[i].id).update({
                                "subName": subTasks[i].subName,
                                "date": subTasks[i].date,
                                "type": type,
                                "deadline": deadline,
                                "setName": _titleController.text,
                              });
                            }
                          }
                          tasks.doc(setPathSub).update({
                            "subName": _titleController.text,
                            "deadline": deadline,
                            "type": type,
                          });
                          Navigator.pop(context);
                        }
                        else {
                          const snackBar = SnackBar(content: Text(
                              "Please Enter Title Task"));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFFEC8FD0),

                        ),
                        child: Row(
                          children: const [
                            Text('UPDATE', style: TextStyle(
                              color: Colors.white,
                            ),),
                            Icon(Ionicons.checkmark_circle_sharp, size: 50, color: Colors.white,)
                          ],
                        ),
                      ),
                    ),
                  ),
                  // X
                  Positioned(
                    bottom: 10,
                    left: 0,
                    child: InkWell(
                      onTap: () {
                        tasks.doc(setPathSub).delete();

                        for(int i = 0; i < subTasks.length; i++) {
                          if(subTasks[i].id.isNotEmpty) {
                            tasks.doc(subTasks[i].id).delete();
                          }
                        }
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: const Color(0xFFF85C70),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Row(
                          children: const [
                            Icon(Ionicons.close_circle_sharp, size: 50,color: Colors.white,),
                            Text('DELETE',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget tagButton({required String label}) {
    return InkWell(
      onTap: () {
        setState(() {
          type = label;
        });
      },
      child: Chip(
        label: Text(
          label,
          style: Theme
              .of(context)
              .textTheme
              .subtitle1,
        ),
        padding: const EdgeInsets.all(10),
        backgroundColor:
        type == label ? const Color(0xFFFFD898) : Colors.white,
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
    var day = await pickDate(context, date);
    if (day == null) return;

    final time = await pickTime(context, date);
    if (time == null) return;

    setState(() {
      date = DateTime(
        day.year,
        day.month,
        day.day,
        time.hour,
        time.minute,
      );
      subTasks[index].date = date;
    });
  }

  Widget subTasksList (int index) {
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
                else {
                  tasks.doc(subTasks[index].id).delete();
                  subTasks.removeAt(index);
                }
              },
            ),
            Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 1.7,
                  height: 40,
                  child: TextFormField(
                    initialValue: subTasks[index].subName,
                    style: Theme.of(context).textTheme.headline6,
                    onChanged: (value) {
                      setState(() {
                        subTasks[index].subName = value;
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
                            .format(subTasks[index].date)
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
                  subTasks.add(
                    SubTasksEditing(
                      subName: "",
                      setName: "",
                      type: "",
                      date: date,
                      deadline: deadline,
                      setPath: setPathSub,
                      id: "",
                    ),
                  );
                });
              },
              icon: const Icon(
                Ionicons.checkmark_circle_sharp,
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