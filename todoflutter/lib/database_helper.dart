import 'dart:ffi';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todoflutter/models/task.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'todo.db'),
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description INTEGER)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertTask(Task task) async {
    Database _db = await database();
    await _db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
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
   if(id != null){
     Database _db = await database();

     // Remove the Dog from the database.
     await _db.delete(

       'tasks',
       // Use a `where` clause to delete a specific dog.
       where: 'id = ?',
       // Pass the Dog's id as a whereArg to prevent SQL injection.
       whereArgs: [id],
     );
   }
    // print(id);
  }
}
