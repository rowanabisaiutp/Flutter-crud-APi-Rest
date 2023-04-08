import 'dart:convert';
import 'package:crud_api_rest_flutter/new_api/screen/todo_list.dart';
import 'package:flutter/material.dart';
import 'package:crud_api_rest_flutter/screens/add_page.dart';
import 'package:http/http.dart' as http;

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  List items = [];
  bool isLoading = true;

  //Inicio
  @override
  void initState() {
    super.initState();
    fetchTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //rutas para ir a otras apis xd
        drawer: Drawer(
          child: Column(
            children: [
              /*Container(
              width: 100,
              height: 200,
              margin: const EdgeInsets.all(50),
              //child: Image.network("https://miro.medium.com/v2/resize:fit:640/0*L68utcHXnuEQwaf1."),
            ),*/
              const Text(
                "Mis APis",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              ListTile(
                leading: const Icon(Icons.play_circle_outline_rounded),
                title: const Text("Mi APi"),
                onTap: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TodoListPage2(),
                  ))
                },
              ),
              ListTile(
                leading: const Icon(Icons.play_circle_outline_rounded),
                title: const Text("Api (Jesús ALberto)"),
                onTap: () => {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const TodoListPage(),
                  ))
                },
              ),
            ],
          ),
        ),

        //-------------------

        //BUSCADOR GET/:ID
        appBar: AppBar(
          title: TextField(
            onChanged: (value) {
              Future<void> fetchItem(String id) async {
                var url = 'https://abet24.fly.dev/api-yisus/get-product/$id';
                final uri = Uri.parse(url);
                final response = await http.get(uri);
                //MUESTRA EL GET/:ID
                if (response.statusCode == 201) {
                  // Si la solicitud es exitosa, puedes manejar los datos recibidos aquí
                  print("Estatus 201");
                  final jsonf2 = jsonDecode(response.body);
                  var iterar = [];
                  iterar.add(jsonf2);
                  final item = iterar[0] as Map;
                  final idget = item['_id'] as String;
                  if (value == idget) {
                    // ignore: use_build_context_synchronously
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Producto Encontrado'),
                          content: SingleChildScrollView(
                            child: Card(
                              child: ListTile(
                                //leading: CircleAvatar(child: Text('${index + 1}')),
                                leading: CircleAvatar(),

                                title: Text(item['name']),
                                subtitle: Text('Precio: \$${item['price']}'),
                                trailing: PopupMenuButton(
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      navigateToAEditPage(item);
                                    } else if (value == 'delete') {
                                      deleteById(id);
                                    }
                                  },
                                  itemBuilder: (context) {
                                    return [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Text("Editar"),
                                      ),
                                      /*const PopupMenuItem(
                          value: 'delete',
                          child: Text("Eliminar"),
                          )*/
                                    ];
                                  },
                                ),
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text('Cerrar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                } /*else {
                // Si la solicitud falla, maneja el error aquí
                print(response.body);
                print("Estatus 500");
              }*/
              }

              fetchItem(value);

              void buscar(String nombre) {
                print("SI");
                for (var index in items) {
                  if (index['name'] == nombre) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Producto Encontrado'),
                          content: SingleChildScrollView(
                            child: Card(
                              child: ListTile(
                                //leading: CircleAvatar(child: Text('${index + 1}')),
                                title: Text(index['name']),
                                subtitle: Text('Precio: \$${index['price']}'),
                                trailing: PopupMenuButton(
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      navigateToAEditPage(index);
                                    }
                                  },
                                  itemBuilder: (context) {
                                    return [
                                      const PopupMenuItem(
                                        value: 'edit',
                                        child: Text("Editar"),
                                      ),
                                      /*const PopupMenuItem(
                          value: 'delete',
                          child: Text("Eliminar"),
                          )*/
                                    ];
                                  },
                                ),
                              ),
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text('Cerrar'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              } //-----

              /*
                */

              buscar(value);
            },
          ),
        ),

        //-----------------------------------
        //TDODO EL BODY Y EL GET ALL
        body: Visibility(
          visible: isLoading,
          child: Center(child: CircularProgressIndicator()),
          replacement: RefreshIndicator(
            onRefresh: fetchTodo,
            child: Visibility(
              visible: items.isNotEmpty,
              replacement: Center(
                child: Text(
                  'No hay productos almacenados',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              ),
              child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index] as Map;
                    final id = item['_id'] as String;
                    return Card(
                      child: ListTile(
                        //leading: CircleAvatar(child: Text('${index + 1}')),
                        leading: CircleAvatar(),
                        title: Text(item['name'],
                            style: const TextStyle(fontSize: 25.0)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Precio: \$${item['price']}',
                                style: const TextStyle(fontSize: 15.0)),
                            Text('Categoria: ${item['categoria']}',
                                style: const TextStyle(fontSize: 15.0)),
                          ],
                        ),
                        //Text('Precio: \$${item['price']} --- Cantidad: ${item['quantity']}'),
                        trailing: PopupMenuButton(
                          onSelected: (value) {
                            if (value == 'edit') {
                              navigateToAEditPage(item);
                            } else if (value == 'delete') {
                              deleteById(id);
                            }
                          },
                          itemBuilder: (context) {
                            return [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text("Editar"),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text("Eliminar"),
                              )
                            ];
                          },
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: navigateToAddPage, label: const Text("Agregar")));
  }

//POST
  Future<void> navigateToAddPage() async {
    final route = MaterialPageRoute(builder: (context) => const AddTodoPage());
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

//PUT
  Future<void> navigateToAEditPage(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddTodoPage(todo: item),
    );
    await Navigator.push(context, route);
    setState(() {
      isLoading = true;
    });
    fetchTodo();
  }

  //DETELE
  Future<void> deleteById(String id) async {
    //booralo en la base
    final url = 'https://abet24.fly.dev/api-yisus/delete-product/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);
    if (response.statusCode == 200) {
      //borrarlo del array
      final filtered = items.where((element) => element['_id'] != id).toList();
      showSuccessMessage("Producto eliminado");
      setState(() {
        items = filtered;
      });
    } else {
      showErrorMeesage("error");
    }
  }

  //GET ALL
  Future<void> fetchTodo() async {
    const url = 'https://abet24.fly.dev/api-yisus/get-products';
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final jsonf = jsonDecode(response.body);
      setState(() {
        items = jsonf;
      });

      print("Productos Encontrados");
    } else {}

    setState(() {
      isLoading = false;
    });
  }

  void showErrorMeesage(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Color.fromARGB(255, 255, 17, 0),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void showSuccessMessage(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
