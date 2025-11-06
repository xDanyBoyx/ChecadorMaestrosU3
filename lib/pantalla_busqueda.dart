import 'package:flutter/material.dart';
import 'bdcheck.dart';

class PantallaBusqueda extends StatefulWidget {
  @override
  _PantallaBusquedaState createState() => _PantallaBusquedaState();
}

class _PantallaBusquedaState extends State<PantallaBusqueda> {
  TextEditingController horaCtrl = TextEditingController();
  TextEditingController edificioCtrl = TextEditingController();
  TextEditingController fechaCtrl = TextEditingController();

  List<Map<String, dynamic>> resultados = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Búsqueda avanzada"),
        backgroundColor: Colors.blue.shade300,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Text(
                  "Filtros de búsqueda",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: horaCtrl,
                  decoration: const InputDecoration(
                    labelText: "Hora (opcional)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: edificioCtrl,
                  decoration: const InputDecoration(
                    labelText: "Edificio (opcional)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: fechaCtrl,
                  decoration: const InputDecoration(
                    labelText: "Fecha (YYYY-MM-DD)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                ElevatedButton.icon(
                  icon: const Icon(Icons.search),
                  label: const Text("Buscar"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    List<Map<String, dynamic>> temp = [];

                    if (horaCtrl.text.isNotEmpty && edificioCtrl.text.isNotEmpty) {
                      temp = await DB.BuscarProfesoresPorHoraYEdificio(
                        horaCtrl.text,
                        edificioCtrl.text,
                      );
                    } else if (fechaCtrl.text.isNotEmpty) {
                      temp = await DB.BuscarProfesoresPorFechaAsistencia(
                        fechaCtrl.text,
                      );
                    } else {
                      temp = await DB.BuscarMateriasSinAsistencia();
                    }

                    setState(() {
                      resultados = temp;
                    });
                  },
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: resultados.isEmpty
                      ? const Text("No hay resultados", style: TextStyle(color: Colors.grey))
                      : ListView.builder(
                    itemCount: resultados.length,
                    itemBuilder: (context, index) {
                      final fila = resultados[index];
                      return Card(
                        color: Colors.blue.shade50,
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text(
                            fila.values.first.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            fila.entries
                                .skip(1)
                                .map((e) => "${e.key}: ${e.value}")
                                .join("\n"),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
