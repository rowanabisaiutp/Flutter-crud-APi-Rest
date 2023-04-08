import 'package:flutter/material.dart';
import 'package:crud_api_rest_flutter/screens/todo_list.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const TodoListPage(),
    );
  }
}
