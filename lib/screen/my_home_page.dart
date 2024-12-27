import 'package:flutter/material.dart';
import 'package:todo/constants/const_colors.dart';
import 'package:todo/model/todo.dart';
import 'package:todo/widget/todo_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _todoController = TextEditingController();
  List<Todo> todosList = [];
  List<Todo> _foundTodo = [];

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: _appBar(),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            color: Colors.white,
          ),
          Positioned(
            top: 15,
            left: 15,
            right: 15,
            child: searchBox(onSearch: _runFilter),
          ),
          const Positioned(
            top: 80,
            left: 15,
            child: Text(
              'LIST OF TODOS',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            ),
          ),
          Positioned(
            top: 130,
            left: 0,
            right: 0,
            bottom: 0,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              children: _foundTodo.map((todo) {
                return Column(
                  children: [
                    TodoItem(
                      todo: todo,
                      onTodoChange: _handleTodoChange,
                      onDeleteItem: _deleteTodoItem,
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              }).toList(),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            offset: const Offset(0.0, 0.0),
                            blurRadius: 10.0,
                            spreadRadius: 1.0,
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _todoController,
                        decoration: const InputDecoration(
                          hintText: 'Add New Todo Item',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20, right: 20),
                    child: ElevatedButton(
                      onPressed: () => _addTodoItem(_todoController.text),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tdBlue,
                        minimumSize: const Size(60, 60),
                        elevation: 10,
                      ),
                      child: const Text(
                        '+',
                        style: TextStyle(fontSize: 40, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

//hadling the isDone status
  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.isDone = !(todo.isDone);
    });
    _saveTodos();
  }

//filtering out the searched key worlds
  void _runFilter(String enteredKeyWord) {
    List<Todo> result = [];
    if (enteredKeyWord.isEmpty) {
      result = todosList;
    } else {
      result = todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyWord.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundTodo = result;
    });
  }

//deleting function
  void _deleteTodoItem(String id) {
    setState(() {
      todosList.removeWhere((todo) => todo.id == id);
    });
    _saveTodos(); // Save after deletion
  }

// add item
  void _addTodoItem(String todoText) {
    setState(() {
      todosList.insert(
          0,
          Todo(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              todoText: todoText));
    });
    _saveTodos(); // Save after adding a new todo
    _todoController.clear(); // Clear input field
  }

  // Function to save todos to SharedPreferences
  void _saveTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> todosStringList =
        todosList.map((todo) => json.encode(todo.toMap())).toList();
    prefs.setStringList('todos', todosStringList);
  }

  // Function to load todos from SharedPreferences
  void _loadTodos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? todosStringList = prefs.getStringList('todos');
    if (todosStringList != null) {
      setState(() {
        todosList = todosStringList.map((todoString) {
          return Todo.fromMap(json.decode(todoString));
        }).toList();
        _foundTodo = todosList; // Initialize filtered todo list
      });
    }
  }
}

Widget searchBox({required Function(String) onSearch}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: TextField(
      onChanged: (value) => onSearch(value),
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.all(0),
        prefixIcon: Icon(
          Icons.search,
          color: tdBlack,
          size: 20,
        ),
        prefixIconConstraints: BoxConstraints(
          maxHeight: 20,
          minWidth: 25,
        ),
        border: InputBorder.none,
        hintText: 'Search',
        hintStyle: TextStyle(color: tdGrey),
      ),
    ),
  );
}

AppBar _appBar() {
  return AppBar(
    backgroundColor: bgColor,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Icon(
          Icons.menu,
          color: tdBlack,
          size: 30,
        ),
        SizedBox(
          height: 40,
          width: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('assets/flutter1.png'),
          ),
        )
      ],
    ),
  );
}
