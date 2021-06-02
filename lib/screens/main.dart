import 'package:faith_sample/database/databasehelper.dart';
import 'package:faith_sample/models/todomodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

main() {
  runApp(MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseHelper databaseHelper;
  TextEditingController title = new TextEditingController();
  TextEditingController description = new TextEditingController();
  List todos = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    databaseHelper = new DatabaseHelper();
    getTodos();
  }

  getTodos() async {
    todos = await databaseHelper.getAllTodo();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sample Project for Faith"),
      ),
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top: 20)),
          todos.isEmpty
              ? Container()
              : Text(
                  "Swipe Container to Delete Todo",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
          todos.isEmpty
              ? Container()
              : Expanded(
                  child: ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, currentIndex) {
                      TodoModel todoModel =
                          TodoModel.fromMap(todos[currentIndex]);
                      return Dismissible(
                          // Each Dismissible must contain a Key. Keys allow Flutter to
                          // uniquely identify widgets.
                          key: Key(todoModel.id.toString()),
                          // Provide a function that tells the app
                          // what to do after an item has been swiped away.
                          onDismissed: (direction) {
                            // Remove the item from the data source.

                            databaseHelper.deleteTodo(todoModel.id);
                            setState(() {
                              todos.removeAt(currentIndex);
                            });

                            print(todos);

                            // Then show a snackbar.
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    '${todoModel.title.toString()} deleted')));
                          },
                          // Show a red background as the item is swiped away.
                          background: Container(color: Colors.red),
                          child: Container(
                            width: double.infinity,
                            margin: EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 20,
                            ),
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            color: Colors.amber,
                            child: Wrap(
                              children: [
                                Container(
                                    margin:
                                        EdgeInsets.only(right: 15, left: 15),
                                    child: Icon(Icons.note)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      children: [
                                        Text(
                                          "Title: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text("${todoModel.title}")
                                      ],
                                    ),
                                    Wrap(
                                      children: [
                                        Text(
                                          "Description: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text("${todoModel.description}")
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ));
                    },
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Add Todo"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: title,
                        decoration: InputDecoration(
                            hintText: "Title", labelText: "Title"),
                      ),
                      TextField(
                        controller: description,
                        decoration: InputDecoration(
                            hintText: "Description", labelText: "Description"),
                      ),
                      Padding(padding: EdgeInsets.only(top: 15)),
                      RaisedButton(
                        onPressed: () async {
                          TodoModel todoModel =
                              new TodoModel(title.text, description.text);

                          await databaseHelper
                              .createTodo(todoModel)
                              .then((value) async {
                            todos = [];
                            todos = await databaseHelper.getAllTodo();
                          });
                          setState(() {});
                        },
                        child: Text("Add Todo"),
                      )
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
