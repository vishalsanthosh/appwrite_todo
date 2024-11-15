import 'package:appwrite_todo/appwriteservice.dart';
import 'package:appwrite_todo/to_do.dart';
import 'package:flutter/material.dart';

class ToDoAppwrite extends StatefulWidget {
  const ToDoAppwrite({super.key});

  @override
  State<ToDoAppwrite> createState() => _ToDoAppwriteState();
}

class _ToDoAppwriteState extends State<ToDoAppwrite> {
  TextEditingController taskcontrol=TextEditingController();
  late Appwriteservice _appwriteservice;
  late List<Task> _tasks;
  @override
  void initState(){
    super.initState();
    _appwriteservice=Appwriteservice();
    _tasks=[];
    _loadTasks();
  }
  Future<void>_loadTasks()async{
    try{
      final tasks=await _appwriteservice.getTasks();
      setState(() {
        _tasks=tasks.map((e)=>Task.fromDocument(e)).toList();
      });
    }catch(e){
      print("Error Loading Task:$e");
      
    }
  }
    Future<void> _addTask() async {
    final title = taskcontrol.text;
    if (title.isNotEmpty) {
      try {
        await _appwriteservice.addTask(title);
        taskcontrol.clear();
        _loadTasks();
      } catch (e) {
        print('Error adding task: $e');
      }
    }
  }

  Future<void> _updateTaskStatus(Task task) async {
    try {
      final updatedTask =
          await _appwriteservice.updateTaskStatus(task.id, !task.completed);
      setState(() {
        task.completed != updatedTask.data['Completed'];
      });
    } catch (e) {
      print('Error updating task: $e');
    }
  }
  Future<void>_deleteTask(String taskId)async{
    try{
      await _appwriteservice.deleteTask(taskId);
      _loadTasks();

    }catch(e){
      print("Error deleting task:$e");

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TO-DO"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           TextField(
            controller: taskcontrol,
            decoration: InputDecoration(border: OutlineInputBorder(),label: Text("Add Task")),
           ),
           SizedBox(height: 12,),
           ElevatedButton(
            
            onPressed: _addTask, child: Text("Add"))
            ,
            Expanded(child: ListView.builder(
              
              itemCount: _tasks.length,
              itemBuilder: (context,index){
                final task=_tasks[index];
              return ListTile(
                title: Text(task.title,style: TextStyle(decoration: task.completed?TextDecoration.lineThrough:null),),
                trailing: IconButton(
                  icon: Icon(Icons.check),
                  onPressed: ()=>_updateTaskStatus(task),),
                  onLongPress: ()=>_deleteTask(task.title),
              );
            }))
          ],
        ),
      ),
    );
  }
}