import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ionicons/ionicons.dart';
import 'package:todoset/components/component_object.dart';
import 'package:todoset/components/constant.dart';
import 'package:todoset/func/tasks_class.dart';
import 'package:todoset/func/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSet extends StatefulWidget {
  static const String id = 'add_set';
  const AddSet({Key? key}) : super(key: key);

  @override
  _AddSetState createState() => _AddSetState();
}

final String? uid = AuthHelper().getCurrentUID();

class _AddSetState extends State<AddSet> {
  @override
  void dispose() {
    _setTitleController.dispose();
    super.dispose();
    setDetails.clear();
    arraySet.clear();
  }

  @override
  void initState() {
    super.initState();
    _addDataToList();
  }

  //Text Controller
  final TextEditingController _setTitleController = TextEditingController();

  //Drop Down List items
  final _selectedCondition = ['Before', 'After'];
  final _selectedDate = ['Start Date', 'End Date'];

  //Valuables
  String selectedTag = "";
  late String selectedDate;
  var arraySet = [];

  //List
  List<ToDoSetDetails> setDetails = [];

  //Collection
  CollectionReference setData = FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('SetData');

  _addDataToList() {
    setDetails.add(ToDoSetDetails(
        title: "",
        day: "",
        condition: "Before",
        startOrDeadline: "Start Date"));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_setTitleController.text.isNotEmpty) {
              for (var item in setDetails) {
                arraySet.add({
                  'subName': item.title,
                  'days': item.day,
                  'condition': item.condition,
                  'date': item.startOrDeadline,
                });
              }
              setData.add({
                "SetName" : _setTitleController.text,
                "type" : selectedTag,
                "setData" : arraySet
              });
              Navigator.pop(context);
            } else {
              const snackBar =
                  SnackBar(content: Text("Please Enter SetToDo Title"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          child: const Icon(
            Ionicons.checkmark_outline,
            color: Color(0xFFFFFFFF),
            size: 40,
          ),
        ),
        body: SafeArea(
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(18),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 130,
                          child: TextFormField(
                            controller: _setTitleController,
                            decoration: const InputDecoration(
                              hintText: "Please Enter ToDoSet's Title",
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Ionicons.close,
                            color: Color(0xFF707070),
                          ),
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
                      height: 20,
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
                      height: 20,
                    ),
                    Text(
                      'SubTask(s) :',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      alignment: Alignment.topLeft,
                      height: MediaQuery.of(context).size.height / 2,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: const Color(0xFFEFEBE0), width: 2),
                      ),
                      child: SingleChildScrollView(
                        reverse: true,
                        physics: const ScrollPhysics(),
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: setDetails.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    //1st Row
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if (index == 0) {
                                              return;
                                            } else {
                                              setState(() {
                                                setDetails.removeAt(index);
                                              });
                                            }
                                          },
                                          icon: const Icon(
                                            Ionicons.remove_circle_sharp,
                                            color: Color(0xFFFFAEBC),
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width -
                                                  150,
                                          child: TextFormField(
                                            onChanged: (value) {
                                              setDetails[index].title = value;
                                            },
                                            decoration: const InputDecoration(
                                                hintText:
                                                    "Enter SubTask's title"),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    //2nd Row
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(width: 50),
                                        const Icon(
                                          Ionicons.alarm_outline,
                                          color: Color(0xFFB21368),
                                        ),
                                        const SizedBox(width: 10),
                                        SizedBox(
                                          width: 80,
                                          child: TextFormField(
                                              keyboardType: TextInputType.number,
                                              inputFormatters: <
                                                  TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly
                                              ],
                                              onChanged: (value) {
                                                setDetails[index].day =
                                                    value;
                                              },
                                              decoration: const InputDecoration(
                                                  hintText: 'Days')),
                                        ),
                                        const SizedBox(width: 10),
                                        dropDownWidgetForCondition(
                                            index: index,
                                            listName: _selectedCondition,
                                            width: 110),
                                        const SizedBox(width: 20),
                                      ],
                                    ),
                                    const SizedBox(height: 3),
                                    //3rd Row
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox(width: 80),
                                        dropDownWidgetForDate(
                                            index: index,
                                            listName: _selectedDate,
                                            width: 150),
                                        IconButton(
                                            onPressed: () {
                                              setState(() {
                                                setDetails.add(
                                                    ToDoSetDetails(title: "", day: "", condition: "Before", startOrDeadline: "Start Date")
                                                );
                                              });
                                            },
                                            icon: const Icon(
                                              Ionicons.add_circle_sharp,
                                              color: Color(0xFFFFAEBC),
                                            ))
                                      ],
                                    ),
                                    const Divider(),
                                  ],
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(item),
      );

  Widget dropDownWidgetForCondition({
    required int index,
    required List<String> listName,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
            value: setDetails[index].condition,
            items: listName.map(buildMenuItem).toList(),
            onSaved: (value) {
              setState(() {
                setDetails[index].condition = value!;
                setDetails[index].condition;
              });
            },
            onChanged: (value) {
              setState(() {
                setDetails[index].condition = value!;
                setDetails[index].condition;
              });
            }),
      ),
    );
  }

  Widget dropDownWidgetForDate({
    required int index,
    required List<String> listName,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
            value: setDetails[index]
                .startOrDeadline,
            items: listName.map(buildMenuItem).toList(),
            onSaved: (value) {
              setState(() {
                setDetails[index]
                    .startOrDeadline = value!;
                setDetails[index]
                    .startOrDeadline;
              });
            },
            onChanged: (value) {
              setState(() {
                setDetails[index]
                    .startOrDeadline = value!;
                setDetails[index]
                    .startOrDeadline;
              });
            }),
      ),
    );
  }
}
