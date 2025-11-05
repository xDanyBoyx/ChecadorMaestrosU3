import 'package:checador_asistencia_u3/profesor.dart';
import 'package:flutter/material.dart';
import 'bdcheck.dart';

class MyCheck extends StatefulWidget {
  const MyCheck({super.key});

  @override
  State<MyCheck> createState() => _MyCheckState();
}

class _MyCheckState extends State<MyCheck> {
  List<Profesor> listaP = [];
  bool fabExpanded = false;

  void actualizarListaP() async {
    List<Profesor> temp = await DB.MostrarProfesor();
    setState(() {
      listaP = temp;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    actualizarListaP();
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
    actualizarListaP();
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
    return Text("HOLA 2");
  }

  Widget dataAsistencia() {
    return Text("HOLA 3");
  }

  Widget dataMateria() {
    return Text("HOLA 4");
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
              // Usamos Builder para que el context esté debajo del DefaultTabController
              Builder(
                builder: (context) {
                  return FloatingActionButton(
                    backgroundColor: Colors.red.shade200,
                    heroTag: "fab_crear",
                    onPressed: () {
                      // Ahora sí podemos obtener el índice correctamente
                      final tabIndex = DefaultTabController.of(context)!.index;

                      // cerramos el menú
                      setState(() => fabExpanded = false);

                      switch (tabIndex) {
                        case 0:
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Crear PROFESOR")),
                          );
                          break;
                        case 1:
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Crear HORARIO")),
                          );
                          break;
                        case 2:
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Crear ASISTENCIA")),
                          );
                          break;
                        case 3:
                        default:
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Crear MATERIA")),
                          );
                          break;
                      }
                    },
                    child: const Icon(Icons.add),
                  );
                },
              ),

              const SizedBox(height: 10),

              // El botón buscar también envuelto en Builder (opcional)
              Builder(
                builder: (context) {
                  return FloatingActionButton(
                    heroTag: "fab_buscar",
                    backgroundColor: Colors.blue.shade200,
                    onPressed: () {
                      final tabIndex = DefaultTabController.of(context)!.index;
                      setState(() => fabExpanded = false);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Buscar en pestaña $tabIndex")),
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

        // FAB principal: no necesita Builder porque no consulta el TabController
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

}
