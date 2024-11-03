import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Page2(),
    );
  }
}

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  List<Map<String, dynamic>> _computadoras = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = await DatabaseHelper.instance.database;
    final computers = await db.query('computadoras');
    setState(() {
      _computadoras = computers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Página 2'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Regresa a la página anterior
          },
        ),
      ),
      body: Container(
        color: Colors.blue, // Color de fondo azul
        child: ListView.builder(
          itemCount: _computadoras.length,
          itemBuilder: (context, index) {
            final computadora = _computadoras[index];
            return ListTile(
              title: Text(
                'Procesador: ${computadora['procesador']}',
                style: TextStyle(color: Colors.white), // Color del texto
              ),
              subtitle: Text(
                'Disco Duro: ${computadora['discoDuro']}, RAM: ${computadora['ram']}',
                style: TextStyle(color: Colors.white), // Color del texto
              ),
              onTap: () => _showOptionsDialog(context, computadora),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showOptionsDialog(
      BuildContext context, Map<String, dynamic> computadora) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Seleccione una opción'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
                _showUpdateFormDialog(context, computadora);
              },
              child: Text('Actualizar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cierra el diálogo
                _deleteData(computadora['id']);
              },
              child: Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateFormDialog(
      BuildContext context, Map<String, dynamic> computadora) {
    final _formKey = GlobalKey<FormState>();
    String? procesador = computadora['procesador'];
    String? discoDuro = computadora['discoDuro'];
    String? ram = computadora['ram'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Actualizar Computadora'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: procesador,
                  decoration: InputDecoration(labelText: 'Procesador'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el procesador';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    procesador = value;
                  },
                ),
                TextFormField(
                  initialValue: discoDuro,
                  decoration: InputDecoration(labelText: 'Disco Duro'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el disco duro';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    discoDuro = value;
                  },
                ),
                TextFormField(
                  initialValue: ram,
                  decoration: InputDecoration(labelText: 'RAM'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa la RAM';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    ram = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _updateData(computadora['id'], procesador, discoDuro, ram);
                  Navigator.of(context).pop(); // Cierra el diálogo
                }
              },
              child: Text('Actualizar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteData(int id) async {
    final db = await DatabaseHelper.instance.database;
    await db.delete('computadoras', where: 'id = ?', whereArgs: [id]);
    _loadData(); // Carga los datos nuevamente
  }

  Future<void> _updateData(
      int id, String? procesador, String? discoDuro, String? ram) async {
    final db = await DatabaseHelper.instance.database;
    await db.update(
      'computadoras',
      {
        'procesador': procesador,
        'discoDuro': discoDuro,
        'ram': ram,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    _loadData(); // Carga los datos nuevamente
  }

  void _showFormDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String? procesador;
    String? discoDuro;
    String? ram;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Computadora'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Procesador'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el procesador';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    procesador = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Disco Duro'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa el disco duro';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    discoDuro = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'RAM'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingresa la RAM';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    ram = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _insertData(procesador, discoDuro, ram);
                  Navigator.of(context).pop(); // Cierra el diálogo
                }
              },
              child: Text('Guardar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _insertData(
      String? procesador, String? discoDuro, String? ram) async {
    final db = await DatabaseHelper.instance.database;
    await db.insert(
      'computadoras',
      {
        'procesador': procesador,
        'discoDuro': discoDuro,
        'ram': ram,
      },
    );
    _loadData(); // Carga los datos nuevamente
  }
}

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('computadoras.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    String path = join(await getDatabasesPath(), filePath);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE computadoras (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        procesador TEXT NOT NULL,
        discoDuro TEXT NOT NULL,
        ram TEXT NOT NULL
      )
    ''');
  }
}
