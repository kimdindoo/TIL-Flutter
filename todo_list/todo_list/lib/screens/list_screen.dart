import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todo_list/providers/todo_sqlite.dart';

import '../models/todo_model.dart';
import '../providers/todo_provider.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Todo> todos = [];
  // TodoDefault todoDefault = TodoDefault();
  TodoSqlite todoSqlite = TodoSqlite();
  bool isLoading = true;

  Future initDb() async {
    await todoSqlite.initDb().then((value) async {
      todos = await todoSqlite.getTodos();
    });
  }

  @override
  void initState() {
    super.initState();
    debugPrint('initState');
    Timer(const Duration(seconds: 2), () {
      initDb().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('할 일 목록 앱'),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.all(5),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book),
                  Text('뉴스'),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Text(
          '+',
          style: TextStyle(
            fontSize: 25,
          ),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              String title = '';
              String description = '';
              return AlertDialog(
                title: const Text('할 일 추가하기'),
                content: SizedBox(
                  height: 200,
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (value) {
                          title = value;
                        },
                        decoration: const InputDecoration(labelText: '제목'),
                      ),
                      TextField(
                        onChanged: (value) {
                          description = value;
                        },
                        decoration: const InputDecoration(labelText: '설명'),
                      )
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: const Text('추가'),
                    onPressed: () async {
                      await todoSqlite.addTodo(
                        Todo(title: title, description: description),
                      );
                      List<Todo> newTodos = await todoSqlite.getTodos();
                      setState(() {
                        debugPrint('[UI] ADD');
                        todos = newTodos;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: const Text('취소'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              itemCount: todos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(todos[index].title),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: const Text('할 일'),
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                '제목 : ${todos[index].title}',
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                '설명 : ${todos[index].description}',
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  trailing: SizedBox(
                    width: 80,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          child: InkWell(
                            child: const Icon(Icons.edit),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  String title = todos[index].title;
                                  String description = todos[index].description;
                                  return AlertDialog(
                                    title: const Text('할 일 수정하기'),
                                    content: SizedBox(
                                      height: 200,
                                      child: Column(
                                        children: [
                                          TextField(
                                            onChanged: (value) {
                                              title = value;
                                            },
                                            decoration: InputDecoration(
                                              hintText: todos[index].title,
                                            ),
                                          ),
                                          TextField(
                                            onChanged: (value) {
                                              description = value;
                                            },
                                            decoration: InputDecoration(
                                              hintText:
                                                  todos[index].description,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text('수정'),
                                        onPressed: () async {
                                          Todo newTodo = Todo(
                                            id: todos[index].id,
                                            title: title,
                                            description: description,
                                          );
                                          await todoSqlite.updateTodo(newTodo);
                                          List<Todo> newTodos =
                                              await todoSqlite.getTodos();
                                          setState(() {
                                            todos = newTodos;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('취소'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          child: InkWell(
                            child: const Icon(Icons.delete),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('할 일 삭제하기'),
                                    content: const Text('삭제하시겠습니까?'),
                                    actions: [
                                      TextButton(
                                        child: const Text('삭제'),
                                        onPressed: () async {
                                          await todoSqlite
                                              .deleteTodo(todos[index].id ?? 0);
                                          List<Todo> newTodos =
                                              await todoSqlite.getTodos();
                                          setState(() {
                                            todos = newTodos;
                                          });
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text('취소'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            ),
    );
  }
}
