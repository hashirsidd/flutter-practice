import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoflutter/database_helper.dart';
import 'package:todoflutter/models/task.dart';
import 'package:todoflutter/screens/taskpage.dart';
import 'package:todoflutter/screens/widget.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DatabaseHelper _dbHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          color: Color(0xfff6f6f6),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 25.0),
                    child: Row(
                      children: [
                        Image(
                          image: AssetImage('asset/images/logo.png'),
                          width: 60.0,
                          height: 60.0,
                        ),

                        Text(
                          "My TODO",
                          style: TextStyle(
                            fontSize: 45.0,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff68B7F7),
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: FutureBuilder(
                        future: _dbHelper.getTasks(),
                        initialData: [],
                        builder: (context, AsyncSnapshot snapshot) {
                          // print("length $snapshot.data.length");
                          return ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Taskpage(
                                              task: snapshot.data[index],
                                            )),
                                  ).then((value) {
                                    setState(() {});
                                  });
                                },
                                child: TaskCardWidget(
                                    title:
                                        '${snapshot.data[index].title[0].toUpperCase()}${snapshot.data[index].title.substring(1)}',
                                    desc:
                                        '${snapshot.data[index].description[0].toUpperCase()}${snapshot.data[index].description.substring(1)}'),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Taskpage(task: null)))
                        .then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    // padding: EdgeInsets.all(12.0),
                    height: 60.0,
                    width: 60.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(30.0),
                      color: Color(0xff68B7F7),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.4),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: Offset(0, 0), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Image(
                      image: AssetImage('asset/images/add_icon.png'),
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
