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
  TextEditingController _controller = TextEditingController();

  // 할 일 수정 다이얼로그
  void _editTask(int index) {
    _controller.text = todos[index]; // 기존 값 설정
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
                  todos[index] = _controller.text; // 수정된 값 반영
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('To-Do List')),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todos[index]),
            onTap: () => _editTask(index), // 클릭하면 수정 다이얼로그 실행
          );
        },
      ),
    );
  }
}
