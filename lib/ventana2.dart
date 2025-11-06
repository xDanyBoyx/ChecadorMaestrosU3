import 'package:checador_asistencia_u3/asistencia.dart';
import 'package:checador_asistencia_u3/horario.dart';
import 'profesor.dart';
import 'package:flutter/material.dart';
import 'bdcheck.dart';
import 'materia.dart';
import 'pantalla_busqueda.dart';

class MyCheck extends StatefulWidget {
  const MyCheck({super.key});

  @override
  State<MyCheck> createState() => _MyCheckState();
}

class _MyCheckState extends State<MyCheck> {
  List<Profesor> listaP = [];
  List<Materia> listaM = [];
  List<Horario> listaH = [];
  List<Asistencia> listaA = [];
  bool fabExpanded = false;
  final nombre = TextEditingController();
  final nprofesor = TextEditingController();
  final carrera = TextEditingController();
  final nmat = TextEditingController();
  final descripcion = TextEditingController();
  final hora = TextEditingController();
  final edificio = TextEditingController();
  final salon = TextEditingController();
  final fecha = TextEditingController();

  void actualizarListaP() async {
    List<Profesor> temp = await DB.MostrarProfesor();
    setState(() {
      listaP = temp;
    });
  }

  void actualizarListaM() async {
    List<Materia> tempM = await DB.MostrarMaterias();
    setState(() {
      listaM = tempM;
    });
  }

  void actualizarListaH() async {
    List<Horario> tempH = await DB.MostrarHorarios();
    setState(() {
      listaH = tempH;
    });
  }

  void actualizarListaA() async {
    List<Asistencia> tempA = await DB.MostrarAsistencia();
    setState(() {
      listaA = tempA;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    actualizarListaP();
    actualizarListaM();
    actualizarListaH();
    actualizarListaA();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            "BIENVENIDO AL CHECADOR",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.indigo.shade300,
          bottom: TabBar(
            tabs: [
              Tab(text: "PROFESORES", icon: Icon(Icons.people)),
              Tab(text: "HORARIOS", icon: Icon(Icons.access_time_outlined)),
              Tab(text: "ASISTENCIAS", icon: Icon(Icons.edit_note_outlined)),
              Tab(text: "MATERIAS", icon: Icon(Icons.apple)),
            ],
            labelStyle: TextStyle(color: Colors.red, fontSize: 16),
            unselectedLabelStyle: TextStyle(color: Colors.white, fontSize: 12),
            indicatorWeight: 5,
          ),
        ),
        body: TabBarView(
          children: [
            dataProfesor(),
            dataHorario(),
            dataAsistencia(),
            dataMateria(),
          ],
        ),
        floatingActionButton: buildExpandableFAB(),
      ),
    );
  }

  Widget dataProfesor() {
    //actualizarListaP();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurpleAccent, Colors.white, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ListView.builder(
        itemCount: listaP.length,
        itemBuilder: (context, contador) {
          return Card(
            child: ListTile(
              onTap: () {
                nombre.text = listaP[contador].nombre;
                carrera.text = listaP[contador].carrera ?? "SIN DATA";
                showDialog(
                  context: context,
                  builder: (context) {
                    return Card(
                      child: ListView(
                        children: [
                          Text(
                            "Actualización de Profesor '" +
                                listaP[contador].nprofesor.toString() +
                                "'",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(labelText: "NOMBRE: "),
                            controller: nombre,
                          ),
                          SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(labelText: "CARRERA: "),
                            controller: carrera,
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsetsGeometry.symmetric(
                              horizontal: 110,
                            ),
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Profesor p = Profesor(
                                      nprofesor: listaP[contador].nprofesor,
                                      nombre: nombre.text,
                                      carrera: carrera.text,
                                    );

                                    DB.ActualizarProfesor(p).then((respuesta) {
                                      if (respuesta <= 0) {
                                        setState(() {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "ERROR: NO SE HA REALIZADO LA ACTUALIZACIÓN",
                                                style: TextStyle(
                                                  backgroundColor: Colors.red,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                      }
                                    });
                                    LimpiarRegistro();
                                    actualizarListaP();
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "ENVIAR",
                                    style: TextStyle(color: Colors.green),
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
              title: Text("NOMBRE: " + listaP[contador].nombre),
              subtitle: Text("CÓDIGO: " + listaP[contador].nprofesor),
              leading: Text(listaP[contador].carrera ?? "SIN DATA"),
              trailing: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          "ADVERTENCIA!!!",
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                        content: Text(
                          "¿ESTAS SEGURO QUE DESEAS ELIMINAR A EL PROFESOR " +
                              listaP[contador].nombre +
                              "?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              DB.EliminarProfesor(listaP[contador].nprofesor);
                              actualizarListaP();
                              Navigator.pop(context);
                            },
                            child: Text("ELIMINAR"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("CANCELAR"),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.delete),
                style: IconButton.styleFrom(foregroundColor: Colors.red),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget dataHorario() {
    //actualizarListaH();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurpleAccent, Colors.white, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ListView.builder(
        itemCount: listaH.length,
        itemBuilder: (context, contador) {
          return Card(
            child: ListTile(
              onTap: () {
                hora.text = listaH[contador].hora;
                edificio.text = listaH[contador].edificio;
                salon.text = listaH[contador].salon;
                showDialog(
                  context: context,
                  builder: (context) {
                    String? profesorSeleccionado;
                    String? materiaSeleccionada;
                    return Card(
                      child: ListView(
                        children: [
                          Text(
                            "Actualización de Horario '" +
                                listaH[contador].nhorario.toString() +
                                "'",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 400),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: "Profesor",
                                border: OutlineInputBorder(),
                              ),
                              isExpanded: true,
                              items: listaP.map((prof) {
                                return DropdownMenuItem(
                                  value: prof.nprofesor,
                                  child: Text(
                                    "${prof.nombre} (${prof.nprofesor})",
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                profesorSeleccionado = value;
                              },
                            ),
                          ),
                          SizedBox(height: 10),

                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 400),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: "Materia",
                                border: OutlineInputBorder(),
                              ),
                              isExpanded: true,
                              items: listaM.map((mat) {
                                return DropdownMenuItem(
                                  value: mat.nmat,
                                  child: Text(
                                    "${mat.descripcion} (${mat.nmat})",
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                materiaSeleccionada = value;
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(labelText: "HORA: "),
                            controller: hora,
                          ),
                          SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                              labelText: "EDIFICIO: ",
                            ),
                            controller: edificio,
                          ),
                          SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(labelText: "SALÓN: "),
                            controller: salon,
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsetsGeometry.symmetric(
                              horizontal: 110,
                            ),
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Horario h = Horario(
                                      nhorario: listaH[contador].nhorario,
                                      nprofesor: profesorSeleccionado!,
                                      nmat: materiaSeleccionada!,
                                      hora: hora.text,
                                      edificio: edificio.text,
                                      salon: salon.text,
                                    );

                                    DB.ActualizarHorario(h).then((respuesta) {
                                      if (respuesta <= 0) {
                                        setState(() {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "ERROR: NO SE HA REALIZADO LA ACTUALIZACIÓN",
                                                style: TextStyle(
                                                  backgroundColor: Colors.red,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                      }
                                    });
                                    LimpiarRegistro();
                                    actualizarListaH();
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "ENVIAR",
                                    style: TextStyle(color: Colors.green),
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
              title: Text(
                "N. HORARIO: " +
                    listaH[contador].nhorario.toString() +
                    "\nN. PROFESOR: " +
                    listaH[contador].nprofesor +
                    "\nN. MATERIA: " +
                    listaH[contador].nmat,
              ),
              subtitle: Text(
                "HORA: " +
                    listaH[contador].hora +
                    "\nEDIFICIO: " +
                    listaH[contador].edificio +
                    "\nSALÓN: " +
                    listaH[contador].salon,
              ),
              trailing: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          "ADVERTENCIA!!!",
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                        content: Text(
                          "¿ESTAS SEGURO QUE DESEAS ELIMINAR ESTE HORARIO " +
                              listaH[contador].nhorario.toString() +
                              "?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              DB.EliminarHorario(listaH[contador].nhorario);
                              actualizarListaH();
                              Navigator.pop(context);
                            },
                            child: Text("ELIMINAR"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("CANCELAR"),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.delete),
                style: IconButton.styleFrom(foregroundColor: Colors.red),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget dataAsistencia() {
    //actualizarListaA();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurpleAccent, Colors.white, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ListView.builder(
        itemCount: listaA.length,
        itemBuilder: (context, contador) {
          return Card(
            child: ListTile(
              onTap: () {
                int? horarioSeleccionado = listaA[contador].nhorario;
                bool? asistenciaSeleccionada = listaA[contador].asistencia;
                TextEditingController fechaController = TextEditingController(text: listaA[contador].fecha);

                showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: SingleChildScrollView(
                        child: FractionallySizedBox(
                          child: Card(
                            color: Colors.grey[100],
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: StatefulBuilder(
                                builder: (context, setStateDialog) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Actualizar Asistencia",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        ),
                                      ),
                                      SizedBox(height: 20),

                                      DropdownButtonFormField<int>(
                                        decoration: InputDecoration(
                                          labelText: "Horario",
                                        ),
                                        value: horarioSeleccionado,
                                        isExpanded: true,
                                        items: listaH.map((hor) {
                                          return DropdownMenuItem<int>(
                                            value: hor.nhorario,
                                            child: Text("ID: ${hor.nhorario} (${hor.nprofesor}) - ${hor.hora}"),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          setStateDialog(() => horarioSeleccionado = value);
                                        },
                                      ),
                                      SizedBox(height: 10),

                                      TextField(
                                        controller: fechaController,
                                        decoration: InputDecoration(
                                          labelText: "Fecha (YYYY-MM-DD)",
                                        ),
                                      ),
                                      SizedBox(height: 10),

                                      DropdownButtonFormField<bool>(
                                        decoration: InputDecoration(
                                          labelText: "Asistencia",
                                        ),
                                        value: asistenciaSeleccionada,
                                        items: const [
                                          DropdownMenuItem(
                                            value: true,
                                            child: Text("Presente"),
                                          ),
                                          DropdownMenuItem(
                                            value: false,
                                            child: Text("Ausente"),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          setStateDialog(() => asistenciaSeleccionada = value);
                                        },
                                      ),
                                      SizedBox(height: 20),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          TextButton(
                                            onPressed: () async {
                                              if (horarioSeleccionado == null ||
                                                  fechaController.text.isEmpty ||
                                                  asistenciaSeleccionada == null) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text("Completa todos los campos"),
                                                    backgroundColor: Colors.orange,
                                                  ),
                                                );
                                                return;
                                              }

                                              Asistencia actualizada = Asistencia(
                                                idasistencia: listaA[contador].idasistencia,
                                                nhorario: horarioSeleccionado!,
                                                fecha: fechaController.text,
                                                asistencia: asistenciaSeleccionada!,
                                              );

                                              int respuesta = await DB.ActualizarAsistencia(actualizada);

                                              if (respuesta > 0) {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text("Asistencia actualizada correctamente"),
                                                    backgroundColor: Colors.green,
                                                  ),
                                                );
                                                actualizarListaA();
                                                Navigator.pop(context);
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text("Error al actualizar asistencia"),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                );
                                              }
                                            },
                                            child:  Text(
                                              "Guardar Cambios",
                                              style: TextStyle(color: Colors.green),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: Text(
                                              "Cancelar",
                                              style: TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              title: Text(
                "ID ASISTENCIA: " +
                    listaA[contador].idasistencia.toString()),
              subtitle: Text(
                "N. HORARIO: " +
                    listaA[contador].nhorario.toString() +
                    "\nFECHA: " +
                    listaA[contador].fecha +
                "\nASISTENCIA: " +
                    listaA[contador].asistencia.toString(),
              ),
              trailing: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          "ADVERTENCIA!!!",
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                        content: Text(
                          "¿ESTAS SEGURO QUE DESEAS ELIMINAR LA ASISTENCIA " +
                              listaA[contador].idasistencia.toString() +
                              "?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              DB.EliminarAsistencia(listaA[contador].idasistencia);
                              actualizarListaA();
                              Navigator.pop(context);
                            },
                            child: Text("ELIMINAR"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("CANCELAR"),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.delete),
                style: IconButton.styleFrom(foregroundColor: Colors.red),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget dataMateria() {
    //actualizarListaM();
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurpleAccent, Colors.white, Colors.blueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: ListView.builder(
        itemCount: listaM.length,
        itemBuilder: (context, contador) {
          return Card(
            child: ListTile(
              onTap: () {
                descripcion.text = listaM[contador].descripcion;
                showDialog(
                  context: context,
                  builder: (context) {
                    return Card(
                      child: ListView(
                        children: [
                          Text(
                            "Actualización de Materia '" +
                                listaM[contador].nmat.toString() +
                                "'",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          SizedBox(height: 20),
                          TextField(
                            decoration: InputDecoration(
                              labelText: "DESCRIPCIÓN: ",
                            ),
                            controller: descripcion,
                          ),
                          SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsetsGeometry.symmetric(
                              horizontal: 110,
                            ),
                            child: Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Materia m = Materia(
                                      nmat: listaM[contador].nmat,
                                      descripcion: descripcion.text,
                                    );

                                    DB.ActualizarMateria(m).then((respuesta) {
                                      if (respuesta <= 0) {
                                        setState(() {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "ERROR: NO SE HA REALIZADO LA ACTUALIZACIÓN",
                                                style: TextStyle(
                                                  backgroundColor: Colors.red,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                      }
                                    });
                                    LimpiarRegistro();
                                    actualizarListaM();
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "ENVIAR",
                                    style: TextStyle(color: Colors.green),
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
              title: Text("DESCRIPCIÓN: " + listaM[contador].descripcion),
              subtitle: Text("NMAT: " + listaM[contador].nmat),
              trailing: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          "ADVERTENCIA!!!",
                          style: TextStyle(color: Colors.red, fontSize: 20),
                        ),
                        content: Text(
                          "¿ESTAS SEGURO QUE DESEAS ELIMINAR ESTA MATERIA " +
                              listaM[contador].descripcion +
                              "?",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              DB.EliminarMateira(listaM[contador].nmat);
                              actualizarListaM();
                              Navigator.pop(context);
                            },
                            child: Text("ELIMINAR"),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("CANCELAR"),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.delete),
                style: IconButton.styleFrom(foregroundColor: Colors.red),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildExpandableFAB() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        if (fabExpanded) ...[
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Builder(
                builder: (context) {
                  return FloatingActionButton(
                    backgroundColor: Colors.red.shade200,
                    heroTag: "fab_crear",
                    onPressed: () {
                      final tabIndex = DefaultTabController.of(context)!.index;

                      setState(() => fabExpanded = false);

                      switch (tabIndex) {
                        case 0:
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Card(
                                child: ListView(
                                  children: [
                                    Text(
                                      "Registro de Profesor",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                      ),
                                    ),
                                    SizedBox(height: 20),
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
                                        horizontal: 110,
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
                                                }
                                              });
                                              LimpiarRegistro();
                                              actualizarListaP();
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
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
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
                          break;
                        case 1:
                          showDialog(
                            context: context,
                            builder: (context) {
                              String? profesorSeleccionado;
                              String? materiaSeleccionada;

                              return Center(
                                child: SingleChildScrollView(
                                  child: FractionallySizedBox(
                                    child: Card(
                                      color: Colors.grey[100],
                                      child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Registro de Horario",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24,
                                                ),
                                              ),
                                              SizedBox(height: 20),

                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth: 400,
                                                ),
                                                child: DropdownButtonFormField<String>(
                                                  decoration: InputDecoration(
                                                    labelText: "Profesor",
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  isExpanded: true,
                                                  items: listaP.map((prof) {
                                                    return DropdownMenuItem(
                                                      value: prof.nprofesor,
                                                      child: Text(
                                                        "${prof.nombre} (${prof.nprofesor})",
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    profesorSeleccionado =
                                                        value;
                                                  },
                                                ),
                                              ),
                                              SizedBox(height: 10),

                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth: 400,
                                                ),
                                                child: DropdownButtonFormField<String>(
                                                  decoration: InputDecoration(
                                                    labelText: "Materia",
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  isExpanded: true,
                                                  items: listaM.map((mat) {
                                                    return DropdownMenuItem(
                                                      value: mat.nmat,
                                                      child: Text(
                                                        "${mat.descripcion} (${mat.nmat})",
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    materiaSeleccionada = value;
                                                  },
                                                ),
                                              ),
                                              SizedBox(height: 10),

                                              TextField(
                                                decoration: InputDecoration(
                                                  labelText: "Hora",
                                                ),
                                                controller: hora,
                                              ),
                                              SizedBox(height: 10),

                                              TextField(
                                                decoration: InputDecoration(
                                                  labelText: "Edificio",
                                                ),
                                                controller: edificio,
                                              ),
                                              SizedBox(height: 10),

                                              TextField(
                                                decoration: InputDecoration(
                                                  labelText: "Salón",
                                                ),
                                                controller: salon,
                                              ),
                                              SizedBox(height: 20),

                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  TextButton(
                                                    onPressed: () async {
                                                      if (profesorSeleccionado ==
                                                              null ||
                                                          materiaSeleccionada ==
                                                              null) {
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              "Selecciona profesor y materia",
                                                            ),
                                                          ),
                                                        );
                                                        return;
                                                      }

                                                      final horario = Horario(
                                                        nprofesor:
                                                            profesorSeleccionado!,
                                                        nmat:
                                                            materiaSeleccionada!,
                                                        hora: hora.text,
                                                        edificio: edificio.text,
                                                        salon: salon.text,
                                                      );

                                                      final respuesta =
                                                          await DB.InsertarHorario(
                                                            horario,
                                                          );

                                                      if (respuesta <= 0) {
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              "Error al insertar horario",
                                                            ),
                                                          ),
                                                        );
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                          context,
                                                        ).showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              "Horario registrado correctamente",
                                                            ),
                                                          ),
                                                        );
                                                        actualizarListaH();
                                                        LimpiarRegistro();
                                                        Navigator.pop(context);
                                                      }
                                                    },
                                                    child: Text(
                                                      "Guardar",
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
                                                      "Cancelar",
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                          break;
                        case 2:
                          showDialog(
                            context: context,
                            builder: (context) {
                              int? horarioSeleccionado;
                              bool? asistenciaSeleccionada;
                              TextEditingController fecha = TextEditingController();

                              return Center(
                                child: SingleChildScrollView(
                                  child: FractionallySizedBox(
                                    child: Card(
                                      color: Colors.grey[100],
                                      child: Padding(
                                        padding: EdgeInsets.all(20),
                                        child: StatefulBuilder(
                                          builder: (BuildContext context, StateSetter setStateDialog) {
                                            return Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "Registro de Asistencia",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 24,
                                                  ),
                                                ),
                                                SizedBox(height: 20),

                                                DropdownButtonFormField<int>(
                                                  decoration: InputDecoration(
                                                    labelText: "Horario",
                                                  ),
                                                  items: listaH.map((hor) {
                                                    return DropdownMenuItem<int>(
                                                      value: hor.nhorario,
                                                      child: Text(
                                                        "ID: ${hor.nhorario} (${hor.nprofesor}) - ${hor.hora}",
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    setStateDialog(() {
                                                      horarioSeleccionado = value;
                                                    });
                                                  },
                                                ),
                                                SizedBox(height: 10),

                                                TextField(
                                                  controller: fecha,
                                                  decoration: InputDecoration(
                                                    labelText: "Fecha (YYYY-MM-DD)",
                                                  ),
                                                ),
                                                SizedBox(height: 10),

                                                DropdownButtonFormField<bool>(
                                                  decoration: InputDecoration(
                                                    labelText: "Asistencia",
                                                  ),
                                                  value: asistenciaSeleccionada,
                                                  items: [
                                                    DropdownMenuItem(
                                                      value: true,
                                                      child: Text("Presente"),
                                                    ),
                                                    DropdownMenuItem(
                                                      value: false,
                                                      child: Text("Ausente"),
                                                    ),
                                                  ],
                                                  onChanged: (value) {
                                                    setStateDialog(() {
                                                      asistenciaSeleccionada = value;
                                                    });
                                                  },
                                                ),
                                                SizedBox(height: 20),

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    TextButton(
                                                      onPressed: () async {
                                                        if (horarioSeleccionado == null ||
                                                            fecha.text.isEmpty ||
                                                            asistenciaSeleccionada == null) {
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                              content:
                                                              Text("Completa todos los campos"),
                                                              backgroundColor: Colors.orange,
                                                            ),
                                                          );
                                                          return;
                                                        }

                                                        Asistencia nueva = Asistencia(
                                                          nhorario: horarioSeleccionado!,
                                                          fecha: fecha.text,
                                                          asistencia: asistenciaSeleccionada!,
                                                        );

                                                        int respuesta =
                                                        await DB.InsertarAsistencia(nueva);

                                                        if (respuesta > 0) {
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  "Asistencia registrada correctamente"),
                                                              backgroundColor: Colors.green,
                                                            ),
                                                          );
                                                          actualizarListaA();
                                                          Navigator.pop(context);
                                                        } else {
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(
                                                              content: Text(
                                                                  "Error al registrar asistencia"),
                                                              backgroundColor: Colors.red,
                                                            ),
                                                          );
                                                        }
                                                      },
                                                      child: Text(
                                                        "Guardar",
                                                        style: TextStyle(color: Colors.green),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text(
                                                        "Cancelar",
                                                        style: TextStyle(color: Colors.red),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                          break;
                        case 3:
                        default:
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Card(
                                child: ListView(
                                  children: [
                                    Text(
                                      "Registro de Materia",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    TextField(
                                      decoration: InputDecoration(
                                        labelText: "NMAT: ",
                                      ),
                                      controller: nmat,
                                    ),
                                    SizedBox(height: 20),
                                    TextField(
                                      decoration: InputDecoration(
                                        labelText: "DESCRIPCIÓN: ",
                                      ),
                                      controller: descripcion,
                                    ),
                                    SizedBox(height: 20),
                                    Padding(
                                      padding: EdgeInsetsGeometry.symmetric(
                                        horizontal: 110,
                                      ),
                                      child: Row(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              Materia m = Materia(
                                                nmat: nmat.text,
                                                descripcion: descripcion.text,
                                              );

                                              DB.CrearMateria(m).then((
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
                                                }
                                              });
                                              LimpiarRegistro();
                                              actualizarListaM();
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
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
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
                          break;
                      }
                    },
                    child: Icon(Icons.add),
                  );
                },
              ),

              SizedBox(height: 10),

              Builder(
                builder: (context) {
                  return FloatingActionButton(
                    heroTag: "fab_buscar",
                    backgroundColor: Colors.blue.shade200,
                    onPressed: () {
                      setState(() => fabExpanded = false);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PantallaBusqueda(),
                        ),
                      );
                    },
                    child: const Icon(Icons.search),
                  );
                },
              ),

              const SizedBox(height: 80),
            ],
          ),
        ],

        FloatingActionButton(
          backgroundColor: Colors.white,
          heroTag: "fab_main",
          onPressed: () {
            setState(() {
              fabExpanded = !fabExpanded;
            });
          },
          child: Icon(fabExpanded ? Icons.close : Icons.menu),
        ),
      ],
    );
  }

  Widget? LimpiarRegistro() {
    nombre.text = "";
    nprofesor.text = "";
    carrera.text = "";
    nmat.text = "";
    descripcion.text = "";
    hora.text = "";
    edificio.text = "";
    salon.text = "";
  }
}
