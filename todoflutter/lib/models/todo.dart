
class Todo {
  final int? id;
  final int? taskId;
  final String title;
  final int isDone ;
  Todo( {this.id,required this.taskId, this.title="",  this.isDone = 0,});

  Map<String, dynamic> toMap() {
    return {
      'id':id,
       'taskId':taskId,
      'title': title,
      'isDone': isDone,
    };
  }
}
