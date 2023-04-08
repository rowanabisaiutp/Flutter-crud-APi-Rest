import 'dart:convert';

import 'package:crud_api_rest_flutter/new_api/screen/add_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../screens/todo_list.dart';

class TodoListPage2 extends StatefulWidget {
  const TodoListPage2({super.key});

  @override
  State<TodoListPage2> createState() => _TodoListPage2State();
}

class _TodoListPage2State extends State<TodoListPage2> {
  bool isLoading = true;
  List items = [];
  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('APi Rowan'),
      ),
      body: Visibility(
        visible: isLoading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
            itemCount: items.length,
            padding: EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              final id = item['_id'] as String;
              return Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text('${index + 1}')),
                  title: Text('Producto: ${item['title']}'),
                  subtitle: Text('precio: \$${item['description']}'),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'edit') {
                        navigateToEditPage(item); //
                      } else if (value == 'delete') {
                        //
                        deleteById(id);
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        PopupMenuItem(
                          child: Text('Editar'),
                          value: 'edit',
                        ),
                        PopupMenuItem(
                          child: Text('Eliminar'),
                          value: 'delete',
                        ),
                      ];
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: navigateToAddPage,
        label: Text('Agregar'),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const Text(
              "APis",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            ListTile(
              leading: const Icon(Icons.play_circle_outline_rounded),
              title: const Text("My Api"),
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const TodoListPage2(),
                ))
              },
            ),
            ListTile(
              leading: const Icon(Icons.play_circle_outline_rounded),
              title: const Text("Api (Jesús Alberto)"),
              onTap: () => {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const TodoListPage(),
                ))
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> navigateToEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage2(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage2(),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  Future<void> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      //
      final filtered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        //
        items = filtered;
      });
      //showSuccesMessage('Se elimino correctamente');
    } else {
      //
      showErrorMessage('Error al eliminar');
    }
  }

  Future<void> fetchTodo() async {
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    }
    setState(() {
      //
      isLoading = false;
    });
  }

  void showErrorMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
