import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../database_helper.dart';

class TaskCardWidget extends StatelessWidget {
  final String title;
  final String desc;
  TaskCardWidget({
    this.title = "(Unnamed Task)",
    this.desc = "(No Description Added)",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 25.0, left: 5.0, right: 5.0, top: 5.0),
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: -1,
            blurRadius: 3,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Color(0xff211511),
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 10.0)),
          Text(
            desc,
            style:
                TextStyle(fontSize: 18.0, color: Colors.black54, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class TodoWidget extends StatelessWidget {
  final String title;
  final int isDone;
  final int taskId;
  final int todoId;

  TodoWidget({this.title = "(Unnamed Todo)", this.isDone = 0, this.taskId=0, this.todoId=0});


  @override
  Widget build(BuildContext context) {
    bool isdone = false;
    if(isDone==0){
           isdone = false;
    }else{
      isdone = true;
    }
    return Container(
                   // color: Colors.blue,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0,left: 5.0),
        child: Row(

          children: [
            Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                color: isdone ? Colors.blue : Colors.transparent,
                border: isdone
                    ? null
                    : Border.all(
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
            Text(
              title,
              style: TextStyle(
                fontWeight: isdone? FontWeight.w500 : FontWeight.bold,
                color: isdone? Colors.black54 : Colors.black87,
                fontSize: 16,
              ),
            ),
            Flexible(fit: FlexFit.tight, child: SizedBox()),
            Container(

              child:  GestureDetector(
                onTap: () async {
                  DatabaseHelper _dbhelper = DatabaseHelper();
                  await _dbhelper.deleteTodo(todoId, taskId);
                  // await _dbhelper.deleteTodo(widget.task!.id);
                  print("deleted taskid : $taskId id: $todoId");

                },
                child: Container(
                  padding: EdgeInsets.all(7.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.0),
                    color: Colors.red ,
                  ),
                  width: 30.0,
                  height: 30.0,
                  child: Image(
                    height: 20.0,
                    width: 20.0,
                    image: AssetImage(
                      'asset/images/delete_icon.png',
                    ),
                  ),
                  margin: EdgeInsets.only(right: 8.0),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}
