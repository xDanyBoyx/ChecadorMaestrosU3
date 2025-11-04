import 'package:checador_asistencia_u3/profesor.dart';
import 'package:flutter/material.dart';

class MyCheck extends StatefulWidget {
  const MyCheck({super.key});

  @override
  State<MyCheck> createState() => _MyCheckState();
}

class _MyCheckState extends State<MyCheck> {
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bienvenido al checador"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: contenido(),
      drawer: Drawer(),
    );
  }
}
