import 'package:flutter/material.dart';
import 'package:todo_app/constants/colors.dart';
import 'package:todo_app/models/tasks.dart';
import 'package:todo_app/services/db_service.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _databaseService = DatabaseService.instance;
  String? _task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: black,
        floatingActionButton: _addTaskButton(),
        body: SafeArea(child: _tasksList()),
    );
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (_) =>
              AlertDialog(
                title: const Text("Add Task"),
                content: _content(),
              ),
        );
      },
      child: const Icon(Icons.add),
    );
  }

  Widget _content() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          onChanged: (value) {
            setState(() {
              _task = value;
            });
          },
          decoration: const InputDecoration(
            hintText: "Add Task",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                if (_task == null || _task == "") return;
                _databaseService.addTask(_task!);
                setState(() {
                  _task = null;
                });
                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ],
    );
  }


  Widget _tasksList() {
    return FutureBuilder(future:
    _databaseService.getTasks(),
        builder: (context, snapshot) {
          return ListView.builder(
            padding: EdgeInsets.zero,
              itemCount: snapshot.data?.length ?? 0,
              itemBuilder: (context, index){
                Tasks tasks = snapshot.data![index];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  minTileHeight: 0,
                  minVerticalPadding: 0,
                  title: Slidable(
                    key: const ValueKey(0),

                    startActionPane: ActionPane(
                        dragDismissible: false,
                        extentRatio: 0.2,
                        motion: const BehindMotion(),
                        dismissible: DismissiblePane(onDismissed: (){
                          setState(() async{
                            _databaseService.updateTaskStatus(tasks.id, 1);
                          });
                        },),
                        children: [
                          SlidableAction(onPressed: (_){}, icon: Icons.check, backgroundColor: green,),
                        ],),

                    endActionPane: ActionPane(
                      motion: const BehindMotion(),
                      dismissible: DismissiblePane(
                        onDismissed: () {
                          setState(() async {
                            _databaseService.deleteTask(tasks.id);
                          });
                        },
                      ),
                      children: [
                        // SlidableAction(onPressed: (_){}, icon: Icons.edit, backgroundColor: white,spacing: 2,),
                        SlidableAction(
                          onPressed: (_){},
                          icon: Icons.delete_forever, backgroundColor: red,
                        ),
                      ],
                    ),
                    child: ListTile(
                        title: Text(
                          tasks.content,
                          style: const TextStyle(
                            color: black,
                            fontSize: 24,
                          ),)),
                  ),
                );
          });
        }
    );
  }
}