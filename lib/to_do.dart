import 'package:appwrite/models.dart';

class Task {
  final String id;
  final String title;
  final bool completed;

  Task({ required this.title, required this.completed,required this.id});

  
  factory Task.fromDocument(Document doc) {
    return Task(
      id: doc.$id,
      title: doc.data['Task'], 
      completed: doc.data['Completed'],
    );
  }
}