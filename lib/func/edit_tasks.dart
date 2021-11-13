import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:todoset/func/auth_service.dart';

class EditTasks extends StatefulWidget {
  const EditTasks({Key? key, required this.document, required this.docID}) : super(key: key);
  final Map<String, dynamic> document;
  final String docID;

  @override
  _EditTasksState createState() => _EditTasksState();
}

final String? uid = AuthHelper().getCurrentUID();

class _EditTasksState extends State<EditTasks> {
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.document["subName"]);
    _detailsController = TextEditingController(text: widget.document["detail"]);
    type = widget.document["type"];
    date = (widget.document["date"] as Timestamp).toDate();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  //instance
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //valuable
  late String type;
  late DateTime date;

  //Text Editing Controller
  late final TextEditingController _titleController;
  late final TextEditingController _detailsController;

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
          child: Center(
            child: Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width - 23,
              height: 650,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF707070), width: 2),
              ),
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
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Enter Title Task";
                                }
                                return null;
                              },
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
                        decoration: const BoxDecoration(
                          color: Color(0xFFA0E7E5),
                          borderRadius: BorderRadius.only(
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
                                  .format(date)
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
                        "Details :",
                        style: Theme
                            .of(context)
                            .textTheme
                            .headline5,
                      ),
                      Expanded(
                        child: Container(
                          margin:
                          const EdgeInsets.symmetric(horizontal: 10),
                          height: MediaQuery
                              .of(context)
                              .size
                              .height / 2.5,
                          child: TextFormField(
                            controller: _detailsController,
                            style: Theme
                                .of(context)
                                .textTheme
                                .headline6,
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
                      ),
                    ],
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: InkWell(
                      onTap: () {
                        if (_titleController.text.isNotEmpty) {
                          tasks.doc(widget.docID).update({
                            "subName": _titleController.text,
                            "date": date,
                            "type": type,
                            "detail": _detailsController.text
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
                        tasks.doc(widget.docID).delete();
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
                            Text('DELETE', style: TextStyle(
                              color: Colors.white,
                            ),),
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

  Future<DateTime?> pickDate(BuildContext context) async {
    final newDate = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(DateTime
          .now()
          .year - 3),
      lastDate: DateTime(DateTime
          .now()
          .year + 3),
    );

    if (newDate == null) return null;

    return newDate;
  }

  Future<TimeOfDay?> pickTime(BuildContext context) async {
    final newTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(date),
    );

    if (newTime == null) return null;

    return newTime;
  }

  Future pickDateTime(BuildContext context) async {
    var date = await pickDate(context);
    if (date == null) return;

    final time = await pickTime(context);
    if (time == null) return;

    setState(() {
      date = DateTime(
        date!.year,
        date!.month,
        date!.day,
        time.hour,
        time.minute,
      );
    });
  }
}