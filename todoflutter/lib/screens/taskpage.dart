import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoflutter/database_helper.dart';
import 'package:todoflutter/models/task.dart';
import 'package:todoflutter/models/todo.dart';
import 'package:todoflutter/screens/widget.dart';

class Taskpage extends StatefulWidget {
  // final int id;
  final Task? task;

  Taskpage({required this.task});
  @override
  _TaskpageState createState() => _TaskpageState();
}

class _TaskpageState extends State<Taskpage> {
  DatabaseHelper _dbhelper = DatabaseHelper();

  String _taskTitle = "";
  String _taskDesc = "";
  int _taskId = 0;
  late FocusNode _titleFocus;
  late FocusNode _descriptionFocus;
  late FocusNode _todoFocus;
  bool _contentVisible = false;
  @override
  void initState() {
    if (widget.task != null) {
      _contentVisible = true;
      _taskTitle = widget.task!.title;
      _taskId = widget.task!.id!;
      if (widget.task!.description != "") {
        _taskDesc = widget.task!.description;
      }
      print(widget.task!.id);
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();
    _todoFocus.dispose();

    super.dispose();
  }

  @override
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
                        focusNode: _titleFocus,
                        onSubmitted: (value) async {
                          if (value != "") {
                            // print('new tasskhas been created');
                            if (widget.task == null) {
                              Task _newTask =
                                  Task(title: value, description: "");
                              int id = await _dbhelper.insertTask(_newTask);
                              print("create new task");
                              setState(() {
                                _taskTitle = value;
                                _contentVisible = true;
                                _taskId = id;

                              });
                            } else {
                              Task _updateTask = Task(
                                  id: widget.task!.id,
                                  title: value,
                                  description: "");
                              await _dbhelper.updateTask(_updateTask);
                            }
                            _descriptionFocus.requestFocus();
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

                  // Description

                  Visibility(
                    visible: _contentVisible,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12.0,
                      ),
                      child: TextField(
                        onSubmitted: (value) async {
                          if (value != "") {
                            if (widget.task == null) {
                              Task _newTask = Task(
                                  id: _taskId,
                                  title: _taskTitle,
                                  description: value);
                              await _dbhelper.insertDesc(_newTask);
                              // print("create new task");
                              print('description added');


                            } else {
                              Task _updateTask = Task(
                                  id: widget.task!.id,
                                  title: _taskTitle,
                                  description: value);
                              await _dbhelper.updateTask(_updateTask);
                            }
                          }  setState(() {
                            // _taskTitle = _taskTitle;
                            _taskDesc = value;
                          });
                          _todoFocus.requestFocus();
                        },
                        focusNode: _descriptionFocus,
                        controller: TextEditingController()..text = _taskDesc,
                        decoration: InputDecoration(

                          hintText: 'Description for the tasks',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 5.0),
                        ),
                      ),
                    ),
                  ),

                  // todo list
                  Visibility(
                    visible: _contentVisible,
                    child: Expanded(
                      child: FutureBuilder(
                        initialData: [],
                        future: _dbhelper.getTodo(_taskId),
                        builder: (context, AsyncSnapshot snapshot) {
                          print('taskid of todo ${_taskId}');
                          return ClipRRect(
                            child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () async {
                                      if (snapshot.data![index].isDone == 0) {
                                        print("todo id ${snapshot.data[index].id}");

                                        await _dbhelper.isDoneTodo(snapshot.data[index].id , _taskId,1);
                                      } else {
                                        // print("isdone true");
                                        print("todo id ${snapshot.data[index].id}");
                                        await _dbhelper.isDoneTodo(snapshot.data[index].id , _taskId,0);


                                      }       setState(() {});
                                    },
                                    child: TodoWidget(
                                      title: snapshot.data[index].title,
                                      isDone: snapshot.data[index].isDone,
                                    ),
                                  );
                                }),
                          );
                        },
                      ),
                    ),
                  ),
                  // add todo
                  Visibility(
                    visible: _contentVisible,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              // padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.0),
                                color: Colors.transparent,
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 1.5,
                                ),
                              ),
                              width: 25.0,
                              height: 25.0,
                              child: Image(
                                height: 20.0,
                                width: 20.0,
                                image: AssetImage(
                                  'asset/images/check_icon.png',
                                ),
                              ),
                              margin: EdgeInsets.only(right: 8.0),
                            ),
                            Expanded(
                                child: TextField(
                              focusNode: _todoFocus,
                              onSubmitted: (value) async {
                                if (value != "") {
                                  print('new todo been created');
                                  if (_taskTitle != "") {
                                    print("Taskid inside todo $_taskId");
                                    DatabaseHelper _dbhelper = DatabaseHelper();
                                    Todo _newTodo = Todo(
                                        taskId: _taskId,
                                        title: value,
                                        isDone: 0);
                                    await _dbhelper.insertTodo(_newTodo);
                                    setState(() {});
                                    print("create new todo");
                                  }
                                }
                                _todoFocus.requestFocus();
                              },
                              controller: TextEditingController()..text = "",
                              decoration: InputDecoration(
                                  hintText: 'Add todo..',
                                  border: InputBorder.none),
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // delete button
              Visibility(
                visible: _contentVisible,
                child: Positioned(
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
                        // await _dbhelper.deleteTodo(widget.task!.id);
                        Navigator.pop(context);
                      },
                      child: Image(
                        image: AssetImage('asset/images/delete_icon.png'),
                      ),
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
