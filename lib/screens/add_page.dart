import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddTodoPage extends StatefulWidget {
  final Map? todo;
  const AddTodoPage({super.key, this.todo});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

//METODO POST
class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  //TextEditingController quantityController = TextEditingController();
  TextEditingController categoriaController = TextEditingController();
  TextEditingController imgController = TextEditingController();
  bool isEdit = false;

  @override
  void initState() {
    super.initState();
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final nameEdit = todo['name'];
      final priceEdit = todo['price'];
      final quantityEdit = todo['quantity'];
      final categoriaEdit = todo['categoria'];
      nameController.text = nameEdit;
      priceController.text = priceEdit;
      //quantityController.text = quantityEdit;
      categoriaController.text = categoriaEdit;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Editar Producto' : 'Nuevo Producto',
        ),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
        child: ListView(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            children: [
              TextField(
                controller: nameController,
                style: const TextStyle(
                  fontSize: 25.0,
                ),
                decoration: const InputDecoration(hintText: 'Nombre'),
              ),
              TextField(
                controller: priceController,
                style: const TextStyle(
                  fontSize: 25.0,
                ),
                decoration: const InputDecoration(hintText: 'Precio'),
              ),
              TextField(
                controller: categoriaController,
                style: const TextStyle(
                  fontSize: 25.0,
                ),
                decoration: const InputDecoration(hintText: 'Categoria'),
              ),
              /*TextField(
              controller: quantityController,
              decoration: const InputDecoration(hintText: 'cantidad'),
            ),*/
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isEdit ? updateData : submitData,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(isEdit ? 'Editar' : 'Guardar'),
                ),
              )
            ]),
      ),
    );
  }

//PUT
  Future<void> updateData() async {
    //obtener los datos del formulario
    final todo = widget.todo;
    if (todo == null) {
      print('error');
      return;
    }
    final id = todo['_id'];
    var name = nameController.text;
    var price = priceController.text;
    //final quantity = quantityController.text;
    var categoria = categoriaController.text;
    var imgedit = imgController.text;

    //METODO HTTP HEAD PARA VERIFICAR EL EMCABEZADO

    Future<bool> verificarEnlace(String enlace) async {
      try {
        http.Response respuesta = await http.get(Uri.parse(enlace));
        return respuesta.statusCode == 200;
      } catch (excepcion) {
        return false;
      }
    }

    bool enlaceExiste = await verificarEnlace(imgedit);
    if (enlaceExiste) {
      print("El enlace existe.");
      imgedit = imgController.text;
    } else {
      print("El enlace no existe.");
      imgedit = "https://img.icons8.com/ultraviolet/256/cancel.png";
    }

    //enviamos un body con el modelo de la api :)
    if (imgedit == '') {
      imgedit = "https://img.icons8.com/color/256/cola.png";
    }
    if (name == '') {
      name = todo['name'];
    }
    if (price == '') {
      price = todo['price'];
    }
    if (categoria == '') {
      categoria = todo['categoria'];
    }

    final body = {
      "name": name,
      "price": price,
      "quantity": "1",
      "categoria": categoria,
    };

    //enviar los datos al server para actualizar
    final url = 'https://abet24.fly.dev/api-yisus/update-product/$id';
    final uri = Uri.parse(url);
    final response = await http.put(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    //mostrar si se envio o fallo, osea el estado
    if (response.statusCode == 200) {
      showSuccessMessage('Producto Editado');
    } else {
      showErrorMeesage('Error al editar');
    }
  }

//POST

  Future<void> submitData() async {
    //obtener los datos del formulario
    final name = nameController.text;
    final price = priceController.text;
    //final quantity = quantityController.text;
    final categoria = categoriaController.text;
    var img = imgController.text;

    //METODO HTTP HEAD PARA VERIFICAR EL EMCABEZADO

    Future<bool> verificarEnlace(String enlace) async {
      try {
        http.Response respuesta = await http.get(Uri.parse(enlace));
        return respuesta.statusCode == 200;
      } catch (excepcion) {
        return false;
      }
    }

    bool enlaceExiste = await verificarEnlace(img);
    if (enlaceExiste) {
      print("El enlace existe.");
      img = imgController.text;
    } else {
      print("El enlace no existe.");
      img = "https://img.icons8.com/ultraviolet/256/cancel.png";
    }

    //enviamos un body con el modelo de la api :)
    if (img == '') {
      img = "https://img.icons8.com/color/256/cola.png";
    }

    final body = {
      "name": name,
      "price": price,
      "quantity": "1",
      "categoria": categoria,
    };

    //enviar los datos al server
    const url = 'https://abet24.fly.dev/api-yisus/add-product';
    final uri = Uri.parse(url);
    final response = await http.post(uri,
        body: jsonEncode(body), headers: {'Content-Type': 'application/json'});

    //mostrar si se envio o fallo, osea el estado
    if (response.statusCode == 200) {
      showSuccessMessage('Producto guardado');
      nameController.text = '';
      priceController.text = '';
      //quantityController.text = '';
      categoriaController.text = '';
      imgController.text = '';
    } else {
      showErrorMeesage('Error al guardar producto');
    }
  }
  //ESTO ES PARA DAR DATALLE  EN LA PANTALLA

  void showErrorMeesage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
