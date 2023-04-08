import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage2 extends StatefulWidget {
  final Map? todo;
  const AddTodoPage2({
    super.key,
    this.todo,
  });

  @override
  State<AddTodoPage2> createState() => _AddTodoPage2State();
}

class _AddTodoPage2State extends State<AddTodoPage2> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      //
      isEdit = true;
      final title = todo['title'];
      final description = todo['description'];
      titleController.text = title;
      descriptionController.text = description;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Editar' : 'Agregar'),
      ),
      body: ListView(
        padding: EdgeInsets.all(100),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: 'nombre'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(hintText: 'precio'),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: isEdit ? updateData : submitData,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(isEdit ? 'Editar' : 'Aceptar'),
            ),
          ),
        ],
      ),
    );
  }

  //updateData

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print('Error al actualizar');
      return;
    }
    final id = todo['_id'];
    //final isCompleted = todo['is_completed'];
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };

    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      //print('');
      showSuccesMessage('Se actualizo correctamente');
    } else {
      //print('Error al crear');
      showErrorMessage('Error al actualizar');
      //print(response);
    }
  }

  Future<void> submitData() async {
    final title = titleController.text;
    final description = descriptionController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false,
    };
    final url = 'https://api.nstack.in/v1/todos';
    final uri = Uri.parse(url);
    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 201) {
      //print('');
      titleController.text = '';
      descriptionController.text = '';
      showSuccesMessage('Se creo correctamente');
    } else {
      //print('Error al crear');
      showErrorMessage('Error al crear');
      //print(response);
    }
  }

  void showSuccesMessage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.blue,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
