import 'package:flutter/material.dart';
import 'pages/adminiistrar.dart';

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
      home: AdminHomePage(),
    );
  }
}

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido Administrador'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text('Menú de Navegación'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Página 1'),
              onTap: () {
                // Cierra el menú y permanece en Página 1
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Administrar'),
              onTap: () {
                // Navegar a Página 2
                Navigator.pop(context); // Cierra el drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Page2()),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.blue, // Color de fondo azul
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Descripción de la Zona del Administrador',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Como administrador, puedes agregar, eliminar y actualizar computadoras en esta zona. '
                  'Asegúrate de gestionar los recursos adecuadamente y mantener todo en orden.',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Image.asset(
                  'assets/img1.jpg', // Asegúrate de tener esta imagen en tu carpeta assets
                  height: 200,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
