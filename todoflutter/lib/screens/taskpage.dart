import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoflutter/database_helper.dart';
import 'package:todoflutter/models/task.dart';
import 'package:todoflutter/screens/widget.dart';

class Taskpage extends StatefulWidget {
  // final int id;
  final Task? task;
  Taskpage({required this.task});
  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  String _taskTitle = "";
  @override
  void initState() {
    if(widget.task != null){
      _taskTitle = widget.task!.title;
      print(widget.task!.id);
    }


    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(24.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Image(
                              height: 30.0,
                              width: 30.0,
                              image: AssetImage(
                                  "asset/images/back_arrow_icon.png")),
                        ),
                      ),
                      Expanded(
                          child: TextField(
                        onSubmitted: (value) async {
                          if (value != "") {
                            // print('new tasskhas been created');
                          }
                          if (widget.task == null) {
                            DatabaseHelper _dbhelper = DatabaseHelper();
                            Task _newTask = Task(title: value, description: "");
                            await _dbhelper.insertTask(_newTask);
                            print("create new task");
                          } else {
                            print("Update task");
                          }
                        },
                        controller: TextEditingController()..text = _taskTitle,
                        decoration: InputDecoration(
                            hintText: 'Enter Task Title',
                            border: InputBorder.none),
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 12.0,
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Description for the tasks',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        TodoWidget(
                          text: "Complete todo app home page",
                          isdone: true,
                        ),
                        TodoWidget(),
                        TodoWidget(),
                        TodoWidget(),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Container(
                  // padding: EdgeInsets.all(12.0),
                  height: 60.0,
                  width: 60.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(30.0),
                    color: Colors.red,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      DatabaseHelper _dbhelper = DatabaseHelper();
                      await _dbhelper.deleteTasks(widget.task!.id);
                      Navigator.pop(context);
                    },
                    child: Image(
                      image: AssetImage('asset/images/delete_icon.png'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
