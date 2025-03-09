import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // JSON 변환을 위해 추가

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ToDoApp(),
    );
  }
}

class ToDoApp extends StatefulWidget {
  const ToDoApp({super.key});

  @override
  State<ToDoApp> createState() => _ToDoAppState();
}

class _ToDoAppState extends State<ToDoApp> {
  List<String> todos = [];
  List<bool> isCompleted = [];
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData(); // 앱 시작할 때 데이터 불러오기
  }

  // 📝 할 일 목록 저장
  Future<void> _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('todos', jsonEncode(todos));
    await prefs.setString('completed', jsonEncode(isCompleted));
  }

  // 🔄 저장된 데이터 불러오기
  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? todoData = prefs.getString('todos');
    String? completedData = prefs.getString('completed');

    if (todoData != null && completedData != null) {
      setState(() {
        todos = List<String>.from(jsonDecode(todoData));
        isCompleted = List<bool>.from(jsonDecode(completedData));
      });
    }
  }

  // ➕ 할 일 추가하기
  void _addTask() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('새로운 할 일 추가'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: '할 일을 입력하세요'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  todos.add(_controller.text);
                  isCompleted.add(false);
                  _controller.clear();
                  _saveData(); // 데이터 저장
                });
                Navigator.pop(context);
              },
              child: Text('추가'),
            ),
          ],
        );
      },
    );
  }

  // ❌ 할 일 삭제하기
  void _deleteTask(int index) {
    setState(() {
      todos.removeAt(index);
      isCompleted.removeAt(index);
      _saveData(); // 삭제 후 저장
    });
  }

  // ✏ 할 일 수정하기
  void _editTask(int index) {
    _controller.text = todos[index];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('할 일 수정'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: '새로운 할 일 입력'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  todos[index] = _controller.text;
                  _saveData(); // 수정 후 저장
                });
                Navigator.pop(context);
              },
              child: Text('저장'),
            ),
          ],
        );
      },
    );
  }

  // ✅ 완료 체크 상태 변경
  void _toggleComplete(int index) {
    setState(() {
      isCompleted[index] = !isCompleted[index];
      _saveData(); // 상태 변경 후 저장
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('To-Do List')),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Checkbox(
              value: isCompleted[index],
              onChanged: (value) => _toggleComplete(index),
            ),
            title: Text(
              todos[index],
              style: TextStyle(
                decoration: isCompleted[index]
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: isCompleted[index] ? Colors.grey : Colors.black,
              ),
            ),
            onTap: () => _editTask(index),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => _deleteTask(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        child: Icon(Icons.add),
      ),
    );
  }
}
