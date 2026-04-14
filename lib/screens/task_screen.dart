import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskScreen extends StatefulWidget {
  final DateTime selectedDate;

  TaskScreen({required this.selectedDate});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> tasks = [];

  void addTask(String title) {
    setState(() {
      tasks.add(Task(title: title));
      sortTasks();
    });
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
      sortTasks();
    });
  }

  void sortTasks() {
    tasks.sort((a, b) {
      if (a.isDone == b.isDone) {
        return a.title.compareTo(b.title);
      }
      return a.isDone ? 1 : -1;
    });
  }

  void showDialogAdd() {
    TextEditingController c = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Nova tarefa"),
        content: TextField(controller: c),
        actions: [
          TextButton(
            onPressed: () {
              if (c.text.isNotEmpty) {
                addTask(c.text);
              }
              Navigator.pop(context);
            },
            child: Text("Adicionar"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String dataFormatada =
        "${widget.selectedDate.day.toString().padLeft(2, '0')}/"
        "${widget.selectedDate.month.toString().padLeft(2, '0')}/"
        "${widget.selectedDate.year}";

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [

          Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            color: Colors.white,
            child: Text(
              "Bem vindo!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
          ),

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
                ),
              ),
              child: Column(
                children: [

                  SizedBox(height: 15),

                  Text(
                    "Dia $dataFormatada",
                    style: TextStyle(color: Colors.white),
                  ),

                  SizedBox(height: 10),

                  Expanded(
                    child: Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ListView.builder(
                        itemCount: tasks.length,
                        itemBuilder: (_, index) {
                          final task = tasks[index];

                          return ListTile(
                            title: Text(
                              task.title,
                              style: TextStyle(
                                decoration: task.isDone
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),

                            subtitle: Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  size: 10,
                                  color: task.isDone
                                      ? Colors.green
                                      : Colors.blue,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  task.isDone
                                      ? "Tarefa concluída"
                                      : "Tarefa em andamento",
                                ),
                              ],
                            ),

                            leading: Checkbox(
                              value: task.isDone,
                              onChanged: (_) => toggleTask(index),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: showDialogAdd,
                    child: Icon(Icons.add, color: Colors.deepPurple),
                  ),

                  SizedBox(height: 20),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}