import 'package:do_it/box/boxes.dart';
import 'package:do_it/model/notes_model.dart';
import 'package:do_it/util/customStyle.dart';
import 'package:do_it/widgets/dateTimePicker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';

class AddTask extends StatefulWidget {
  final bool isCreate;
  final NotesModel? notesModel;

  AddTask({super.key, required this.isCreate, this.notesModel});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  var titleController = TextEditingController();
  var descController = TextEditingController();
  late DateTime selectedDateTime = DateTime.now();

  late DateTime CreationTime;

  bool deadLineSelected = false;
  bool isVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CreationTime = DateTime.now();
    CreationTime = DateTime(
      CreationTime.year,
      CreationTime.month,
      CreationTime.day,
      CreationTime.hour,
      CreationTime.minute,
    );
    if (widget.notesModel != null) {
      titleController.text = widget.notesModel!.title.toString();
      descController.text = widget.notesModel!.description.toString();
      deadLineSelected = widget.notesModel!.DeadLineSelected;
      selectedDateTime = widget.notesModel!.deadline;
      selectedDateTime = DateTime(
        selectedDateTime.year,
        selectedDateTime.month,
        selectedDateTime.day,
        selectedDateTime.hour,
        selectedDateTime.minute,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.maxFinite,
        padding: EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Color(0xff330066)],
            end: Alignment.bottomLeft,
            begin: Alignment.topRight,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.isCreate ? "Create Task" : "Edit Task",
                    style: myStyle(
                        col: Colors.white,
                        fontSize: 40,
                        weight: FontWeight.w400),
                  ),
                  Gap(15),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                        hintText: "Title",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        fillColor: Colors.white,
                        filled: true),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                        hintText: "Description",
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        fillColor: Colors.white,
                        filled: true),
                    controller: descController,
                    minLines: 8,
                    maxLines: 12,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    //color: Colors.red,
                    margin: EdgeInsets.only(left: 20, right: 20),
                    width: double.maxFinite,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Set DeadLine For this Task ',
                          style:
                              myStyle(col: Colors.grey.shade300, fontSize: 15),
                        ),
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                              value: deadLineSelected,
                              onChanged: (value) {
                                setState(() {
                                  deadLineSelected = value;
                                  isVisible = value;
                                });
                              }),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: deadLineSelected,
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          DateTimeField(false, Timebutton(), selectedDateTime),
                          SizedBox(
                            height: 20,
                          ),
                          DateTimeField(true, Datebutton(), selectedDateTime),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      onPressed: widget.isCreate
                          ? () async {
                              if (titleController.text.toString() == "") {
                                showSnackBar(
                                    "Title Can't be empty", Colors.red);
                              } else {
                                final data = NotesModel(
                                  title: titleController.text,
                                  description: descController.text,
                                  isCompleted: false,
                                  creationTime: CreationTime,
                                  deadline: selectedDateTime,
                                  DeadLineSelected: deadLineSelected,
                                );

                                try {
                                  final box = Boxes.getData();
                                  await box.add(data);
                                  data.save();
                                  setState(() {
                                    showSnackBar("New task added successfully",
                                        Colors.green);
                                    Navigator.pop(context);
                                  });
                                } catch (e) {
                                  showSnackBar(
                                      "Error adding task $e", Colors.red);
                                }
                                titleController.clear();
                                descController.clear();
                              }
                            }
                          : () async {
                              widget.notesModel!.title =
                                  titleController.text.toString();
                              widget.notesModel!.description =
                                  descController.text.toString();
                              widget.notesModel!.deadline = selectedDateTime;
                              widget.notesModel!.DeadLineSelected =
                                  deadLineSelected;
                              widget.notesModel!.save();
                              titleController.clear();
                              descController.clear();
                              showSnackBar(
                                  "Task updated successfully", Colors.green);
                              Navigator.pop(context);
                            },
                      child: Text(
                        widget.isCreate ? "Create" : "Update",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton Timebutton() {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.grey.shade300),
          // button styl
        ),
        onPressed: () {
          selectTime(context);
        },
        child: Text("Time"));
  }

  ElevatedButton Datebutton() {
    return ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.grey.shade300),
          // button style
        ),
        onPressed: () {
          selectDate(context);
        },
        child: Text("Date"));
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        initialDate: DateTime.now());
    if (picked != null && picked != selectedDateTime) {
      setState(() {
        selectedDateTime = DateTime(picked.year, picked.month, picked.day,
            selectedDateTime.hour, selectedDateTime.minute);
      });
    }
  }

  void showSnackBar(String message, Color color) {
    final msg = SnackBar(
      duration: Duration(seconds: 2),
      content: Text(
        "$message",
        style: TextStyle(
            color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
      ),
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(msg);
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null && picked != selectedDateTime) {
      setState(() {
        selectedDateTime = DateTime(
          selectedDateTime.year,
          selectedDateTime.month,
          selectedDateTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }
}
