import 'package:checador_asistencia_u3/ventana2.dart';
import 'package:flutter/material.dart';
import 'profesor.dart';
import 'bdcheck.dart';

class AppCheck extends StatefulWidget {
  const AppCheck({super.key});

  @override
  State<AppCheck> createState() => _AppCheckState();
}

class _AppCheckState extends State<AppCheck> {
  final nombre = TextEditingController();
  final nprofesor = TextEditingController();
  final carrera = TextEditingController();
  bool login = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.white, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          // padding: EdgeInsetsGeometry.all(150),
          children: [
            SizedBox(height: 80),
            Center(
              child: Text(
                "BIENVENIDO AL CHECADOR \nDE MAESTROS",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 60),
            CircleAvatar(child: Icon(Icons.person, size: 150), radius: 80),
            Padding(
              padding: EdgeInsetsGeometry.all(80),
              child: Center(
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        labelText: "USUARIO",
                        icon: Icon(Icons.person),
                      ),
                      controller: nombre,
                    ),
                    SizedBox(height: 20),
                    TextField(
                      decoration: InputDecoration(
                        labelText: "CONTRASEÑA",
                        icon: Icon(Icons.key),
                      ),
                      controller: nprofesor,
                    ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        List<Profesor> profes = await DB.MostrarProfesor();

                        if (profes.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "NO HAY USUARIOS REGISTRADOS",
                                style: TextStyle(
                                  backgroundColor: Colors.redAccent,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          );
                        } else {
                          LoginExitoso(profes, nombre.text, nprofesor.text);
                          if (login == false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "USUARIO O CONTRASEÑA INCORRECTOS",
                                  style: TextStyle(
                                    backgroundColor: Colors.redAccent,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(context, MaterialPageRoute(builder: (x) => MyCheck()));
                          }
                        }
                        LimpiarRegistro();
                      },
                      child: Text("ENTRAR"),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(
                                "REGISTRO DE USUARIO",
                                style: TextStyle(color: Colors.blueAccent),
                              ),
                              content: Column(
                                children: [
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: "NOMBRE: ",
                                    ),
                                    controller: nombre,
                                  ),
                                  SizedBox(height: 20),
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: "CONTRASEÑA: ",
                                    ),
                                    controller: nprofesor,
                                  ),
                                  SizedBox(height: 20),
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: "CARRERA: ",
                                    ),
                                    controller: carrera,
                                  ),
                                  SizedBox(height: 20),
                                  Padding(
                                    padding: EdgeInsetsGeometry.symmetric(
                                      horizontal: 50,
                                    ),
                                    child: Row(
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            Profesor p = Profesor(
                                              nprofesor: nprofesor.text,
                                              nombre: nombre.text,
                                              carrera: carrera.text,
                                            );

                                            DB.InsertarProfesor(p).then((
                                              respuesta,
                                            ) {
                                              if (respuesta <= 0) {
                                                setState(() {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        "ERROR: NO SE HA REALIZADO EL REGISTRO",
                                                        style: TextStyle(
                                                          backgroundColor:
                                                              Colors.red,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                              } else {
                                                setState(() {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        "EXITO: SE HA REALIZADO EL REGISTRO",
                                                        style: TextStyle(
                                                          backgroundColor:
                                                              Colors.green,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });
                                              }
                                            });
                                            LimpiarRegistro();
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "ENVIAR",
                                            style: TextStyle(
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            LimpiarRegistro();
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "CANCELAR",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Text("REGISTRAR"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget? LoginExitoso(List profes, String user, String pass) {
    login = false;

    for (Profesor p in profes) {
      if (p.nombre == user && p.nprofesor == pass) {
        login = true;
        break;
      }
    }
  }

  Widget? LimpiarRegistro(){
    nombre.text = "";
    nprofesor.text = "";
    carrera.text = "";
  }
}
