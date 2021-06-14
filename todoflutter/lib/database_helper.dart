import 'dart:ffi';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoflutter/models/task.dart';

import 'models/todo.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)");
        await db.execute("CREATE TABLE todo(id INTEGER PRIMARY KEY, taskId INTEGER, title TEXT, isDone INTEGER)");

        // return db;
      },
      version: 1,
    );
  }

  Future<int> insertTask(Task task) async {
    int taskId = 0;
    Database _db = await database();
    await _db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    ).then((value){
                   taskId = value;
    });
    return taskId;
  }
  Future<void> insertDesc(Task task) async {
    Database _db = await database();
    var id = task.id;
    if (id != null) {
      Database _db = await database();
      await _db.update(
        'tasks',
        task.toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  Future<List<Task>> getTasks() async {
    Database _db = await database();
    List<Map<String, dynamic>> taskMap = await _db.query('tasks');
    return List.generate(taskMap.length, (index) {
      return Task(
          id: taskMap[index]['id'],
          title: taskMap[index]['title'],
          description: taskMap[index]['description']);
    });
  }

  Future<void> deleteTasks(int? id) async {
    // Get a reference to the database.
    if (id != null) {
      Database _db = await database();

      // Remove the Dog from the database.
      await _db.delete(
        'tasks',
        // Use a `where` clause to delete a specific dog.
        where: 'id = ?',
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [id],
      );
      await _db.delete(
        'todo',
        // Use a `where` clause to delete a specific dog.
        where: 'taskId = ?',
        // Pass the Dog's id as a whereArg to prevent SQL injection.
        whereArgs: [id],
      );
    }
    // print(id);
  }

  Future<void> updateTask(Task task) async {
    // Get a reference to the database.
    var id = task.id;
    if (id != null) {
      Database _db = await database();
      await _db.update(
        'tasks',
        task.toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
    }
    // print("update id : $id") ;
  }

  Future<void> insertTodo(Todo todo) async {
    Database _db = await database();
    await _db.insert(
      'todo',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Todo>> getTodo(int taskID) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap = await _db.rawQuery('SELECT * FROM todo where taskId = $taskID');
    return List.generate(todoMap.length, (index) {
      return Todo(
          id: todoMap[index]['id'],
          taskId: todoMap[index]['taskId'],
          title: todoMap[index]['title'],
          isDone: todoMap[index]['isDone']);
    });
  }

  
  Future<List<Todo>> isDoneTodo(int id, int taskId,int isDone) async {
    Database _db = await database();
    List<Map<String, dynamic>> todoMap = await _db.rawQuery('UPDATE todo set isDone = $isDone  where taskId = $taskId AND id = $id');
    return List.generate(todoMap.length, (index) {
      return Todo(
          id: todoMap[index]['id'],
          taskId: todoMap[index]['taskId'],
          title: todoMap[index]['title'],
          isDone: todoMap[index]['isDone']);
    });
  }
  // Future<void> updateTask(Task task) async {
  //   // Get a reference to the database.
  //   var id = task.id;
  //   if (id != null) {
  //     Database _db = await database();
  //     await _db.update(
  //       'tasks',
  //       task.toMap(),
  //       where: 'id = ?',
  //       whereArgs: [id],
  //     );
  //   }
  //   // print("update id : $id") ;
  // }
}

