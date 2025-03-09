import 'package:flutter/material.dart';

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
  List<String> todos = ["플러터 공부하기", "운동하기", "코드 리뷰하기"];
  List<bool> isCompleted = [false, false, false]; // 완료 여부 저장
  TextEditingController _controller = TextEditingController();

  // 할 일 추가하기
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

  // 할 일 삭제하기
  void _deleteTask(int index) {
    setState(() {
      todos.removeAt(index);
      isCompleted.removeAt(index);
    });
  }

  // 할 일 수정하기
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

  // 체크박스 상태 변경
  void _toggleComplete(int index) {
    setState(() {
      isCompleted[index] = !isCompleted[index];
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
