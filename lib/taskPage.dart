import 'package:flutter/material.dart';
import 'package:sqlitedemo/database/task_db.dart';

import 'taskModel.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  Future<List<TaskModel>>? futuretasklist;
  var taskdb = TaskDB();
  var titlecontroller = TextEditingController();

  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() {
    setState(() {
      futuretasklist = taskdb.fetchAllData();
    });
  }

  _myDialog(TaskModel? item) {
    if (item != null) {
      titlecontroller.text = item.title;
    }
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(item != null ? "Update Item" : "Add Item"),
          TextFormField(
            controller: titlecontroller,
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              if (titlecontroller.text.isNotEmpty) {
                item != null
                    ? taskdb.updateData(
                        id: item.id, title: titlecontroller.text)
                    : taskdb.insertData(title: titlecontroller.text);
                getData();
                Navigator.pop(context);
                titlecontroller.clear();
              }
            },
            child: Text(item != null ? "Update" : "Add")),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
              titlecontroller.clear();
            },
            child: Text("Cancel"))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(context: context, builder: (context) => _myDialog(null));
        },
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
          future: futuretasklist,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data;
              if (data!.isEmpty) {
                return const Center(
                  child: Text('List is Empty'),
                );
              } else {
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var mydata = data[index];
                      return ListTile(
                        title: Text(mydata.title),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => _myDialog(mydata));
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.green,
                                )),
                            IconButton(
                                onPressed: () {
                                  taskdb.deleteData(id: mydata.id);
                                  getData();
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ))
                          ],
                        ),
                      );
                    });
              }
            } else {
              return const Center(
                child: Text('Snapshot has no data'),
              );
            }
          }),
    );
  }
}
