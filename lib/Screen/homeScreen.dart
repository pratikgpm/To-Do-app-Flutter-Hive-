import 'dart:async';
import 'package:do_it/util/customStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:do_it/widgets/notice_container.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:do_it/Screen/add_task.dart';
import 'package:do_it/box/boxes.dart';
import 'package:do_it/model/notes_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({super.key});

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> animation;
  late Animation<Offset> container1Animation;
  late Animation<Offset> container2Animation;
  late Animation<Offset> container3Animation;
  late Animation<double> opacityAnimation;

  int _counter = 0;
  late Timer _timer;
  late int pending_task;
  late int completed_task;
  late int time_bounded_task;

  Future<void> count() async {
    var box = await Hive.openBox<NotesModel>('myBox');
    var data = box.values.toList().cast<NotesModel>();
    pending_task = data.where((element) => !element.isCompleted).length;
    completed_task = data.length - pending_task;
    time_bounded_task = data
        .where((element) => element.DeadLineSelected && !element.isCompleted)
        .length;

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    count();
    _timer = Timer.periodic(Duration(seconds: 60), (timer) {
      setState(() {
        _counter++;
      });
    });

    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    animation = Tween<Offset>(begin: const Offset(-1.0, 0.0), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.5, curve: Curves.easeInOut)));

    container1Animation = containerAnimation(begin: 0.0, end: 0.3);
    container2Animation = containerAnimation(begin: 0.3, end: 0.5);
    container3Animation = containerAnimation(begin: 0.5, end: 0.7);
    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: controller,
            curve: Interval(0.0, 0.8, curve: Curves.easeInOut)));

    controller.forward();
  }

  Animation<Offset> containerAnimation(
      {required double begin, required double end}) {
    return Tween<Offset>(
      begin: const Offset(1.5, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: controller,
        curve: Interval(begin, end, curve: Curves.easeInOut)));
  }

  @override
  void dispose() {
    _timer.cancel();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFFD1C4E9),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Color(0xff330066)],
                  end: Alignment.bottomLeft,
                  begin: Alignment.topRight,
                ),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(40.0),
                    bottomLeft: Radius.circular(40.0))),
            // margin: EdgeInsets.only(left: 12.0,right: 12.0),

            height: MediaQuery.of(context).size.width * 0.70,
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: SlideTransition(
                    position: animation,
                    child: Container(
                        // color : Colors.red.withOpacity(0.5),
                        child: Image.asset(
                      fit: BoxFit.contain,
                      alignment: Alignment.bottomRight,
                      'assets/images/tood_app_back.png',
                      width: double.maxFinite,
                      height: double.maxFinite,
                    )),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    margin: EdgeInsets.only(bottom: 25),
                    //color: Colors.red,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FadeTransition(
                          opacity: opacityAnimation,
                          child: Container(
                            child: Text(
                              "Hi 👋",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'FontMain',
                                fontWeight: FontWeight.w600,
                                fontSize: 30,
                              ),
                            ),
                          ),
                        ), //Hii Text
                        Text(
                          "Your day look like this ",
                          style: myStyle(col: Colors.white),
                        ), //Your day look like this
                        SizedBox(
                          height: 10,
                        ),
                        SlideTransition(
                          position: container1Animation,
                          child: noticeContainer(
                              Icons.list_alt, "$pending_task", "Task Pending"),
                        ),
                        SlideTransition(
                          position: container2Animation,
                          child: noticeContainer(Icons.task_alt_outlined,
                              "$completed_task", "Task completed"),
                        ),
                        SlideTransition(
                          position: container3Animation,
                          child: noticeContainer(Icons.alarm,
                              "$time_bounded_task", "Time-Bounded Task"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              //color:  Colors.red,
              child: ValueListenableBuilder<Box<NotesModel>>(
                valueListenable: Boxes.getData().listenable(),
                builder: (context, box, _) {
                  var data = box.values.toList().cast<NotesModel>();
                  // completed_task =
                  //     box.values.where((element) => element.isCompleted).length;
                  // pending_task = box.values
                  //     .where((element) => !element.isCompleted)
                  //     .length;
                  // time_bounded_task = box.values
                  //     .where((element) =>
                  //         element.DeadLineSelected && !element.isCompleted)
                  //     .length;

                  return data.length == 0
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AnimatedOpacity(
                                opacity: 0.5,
                                duration: Duration(seconds: 3),
                                child: Lottie.asset(
                                  'assets/images/resting_animation.json',
                                  repeat: false,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "No tasks for today",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.grey.shade600),
                              ), //No task for Today
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: box.length,
                          itemBuilder: (context, index) {
                            bool isCompleted = data[index].isCompleted;

                            //deadline - creation time (total time)
                            int timeDef = data[index]
                                .deadline
                                .difference(data[index].creationTime)
                                .inMinutes;

                            Duration totalP = data[index]
                                .deadline
                                .difference(data[index].creationTime);

                            // creation time - current time ()
                            int usedTime = DateTime.now()
                                .difference(data[index].creationTime)
                                .inMinutes;

                            Duration usedP = DateTime.now()
                                .difference(data[index].creationTime);

                            Duration timeLeftP = totalP - usedP;

                            int hour = timeLeftP.inHours;
                            int min = timeLeftP.inMinutes.remainder(60);

                            int percentage = 0;
                            int timeLeft = timeDef - usedTime;
                            if (usedTime < timeDef) {
                              percentage = ((usedTime / timeDef) * 100).toInt();
                            } else if (usedTime > timeDef) {
                              percentage = 100;
                            }
                            double per = percentage / 100;

                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0,
                                  right: 10.0,
                                  bottom: 3.0,
                                  top: 1.0),
                              child: Slidable(
                                  endActionPane: ActionPane(
                                    motion: StretchMotion(),
                                    children: [
                                      SlidableAction(
                                        icon: Icons.edit,
                                        onPressed: (context) {
                                          editData(data[index]);
                                          count();
                                        },
                                      ),
                                      SlidableAction(
                                        icon: Icons.delete,
                                        onPressed: (context) {
                                          delete(data[index]);
                                          count();
                                        },
                                      ),
                                      SlidableAction(
                                        icon: Icons.thumb_up_sharp,
                                        onPressed: (context) {
                                          changeStatus(data[index]);
                                        },
                                      )
                                    ],
                                  ),
                                  child: InkWell(
                                    onTap: () async {
                                      await showMy(
                                          context,
                                          data[index].title.toString(),
                                          data[index].description.toString());
                                    },
                                    child: Card(
                                      borderOnForeground: true,
                                      elevation: 2.5,
                                      shadowColor: Colors.grey,
                                      color: isCompleted
                                          ? Colors.green.withOpacity(0.5)
                                          : Colors.white,
                                      //   margin: EdgeInsets.only(left: 5.0, right: 5.0),
                                      child: Center(
                                        child: Container(
                                            height: 100,
                                            width: screenWidth * 0.95,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 7,
                                                  child: Center(
                                                    child: Container(
                                                      height: 80,
                                                      child: ListTile(
                                                        leading: Text(
                                                          '${index + 1}',
                                                          style: TextStyle(
                                                              fontSize: 20),
                                                        ),
                                                        title: Text(
                                                          data[index]
                                                              .title
                                                              .toString(),
                                                          style: myStyle(),
                                                        ),
                                                        subtitle: Text(
                                                          data[index]
                                                              .description
                                                              .toString(),
                                                          maxLines: 2,
                                                          overflow:
                                                              TextOverflow.fade,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: !data[index]
                                                          .DeadLineSelected
                                                      ? Container(
                                                          child: data[index]
                                                                  .isCompleted
                                                              ? Icon(
                                                                  Icons
                                                                      .done_all_outlined,
                                                                  size: 30,
                                                                )
                                                              : null,
                                                        )
                                                      : Center(
                                                          child: data[index]
                                                                  .isCompleted
                                                              ? Icon(
                                                                  Icons
                                                                      .done_all_outlined,
                                                                  size: 30,
                                                                )
                                                              : CircularPercentIndicator(
                                                                  reverse: true,
                                                                  radius: 30,
                                                                  lineWidth: 7,
                                                                  animation:
                                                                      true,
                                                                  percent: per,
                                                                  center:
                                                                      timeLeft >
                                                                              0
                                                                          ? Text(
                                                                              "$percentage %",
                                                                              style: TextStyle(fontSize: 15),
                                                                            )
                                                                          : Text(
                                                                              "!",
                                                                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
                                                                            ),
                                                                  circularStrokeCap:
                                                                      CircularStrokeCap
                                                                          .round,
                                                                  progressColor: timeLeft >
                                                                          0
                                                                      ? Colors
                                                                          .blueAccent
                                                                      : Colors
                                                                          .red,
                                                                  footer: Text(
                                                                    timeLeft > 0
                                                                        ? '$hour Hr $min m '
                                                                        : "${hour * -1} Hr ${min * -1} m ",
                                                                    style:
                                                                        myStyle(
                                                                      fontSize:
                                                                          12,
                                                                      weight: FontWeight
                                                                          .normal,
                                                                    ),
                                                                  ),
                                                                ),
                                                        ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  )),
                            );
                          },
                        );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        backgroundColor: Colors.indigo,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTask(
                  isCreate: true,
                ),
              ));
          // make sure to call this function
          count();
        },
      ),
    );
  }

  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }

  void editData(NotesModel notesModel) async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddTask(
            isCreate: false,
            notesModel: notesModel,
          ),
        ));
  }

  void changeStatus(NotesModel notesModel) async {
    if (notesModel.isCompleted) {
      notesModel.isCompleted = false;
      await notesModel.save();
      count();
    } else {
      notesModel.isCompleted = true;
      await notesModel.save();
      count();
    }
  }
}

Future<void> showMy(
    BuildContext context, String title, String description) async {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
              child: Text(
            title.toString(),
            style: myStyle(fontSize: 25),
          )),
          content: SingleChildScrollView(
            child: Text(
              description,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      });
}
