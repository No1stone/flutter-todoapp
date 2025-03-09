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
              onChanged: (value) => _toggleComplete(index), // 체크하면 상태 변경
            ),
            title: Text(
              todos[index],
              style: TextStyle(
                decoration: isCompleted[index]
                    ? TextDecoration.lineThrough // 완료 시 취소선 추가
                    : TextDecoration.none,
                color: isCompleted[index] ? Colors.grey : Colors.black, // 완료 시 회색으로 변경
              ),
            ),
            onTap: () => _editTask(index), // 클릭하면 수정 다이얼로그 실행
          );
        },
      ),
    );
  }
}
