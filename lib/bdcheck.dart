import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'profesor.dart';

class DB {
  static Future<Database> _conectarDB() async {
    return openDatabase(
      join(await getDatabasesPath(), "checador_asistencia.db"),
      version: 1,
      onConfigure: (db) async {
        await db.execute("PRAGMA foreign_keys = ON");
      },
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE MATERIA(NMAT TEXT PRIMARY KEY, DESCRIPCION TEXT)",
        );
        await db.execute(
          "CREATE TABLE PROFESOR(NPROFESOR TEXT PRIMARY KEY, NOMBRE TEXT, CARRERA TEXT)",
        );
        await db.execute(
          "CREATE TABLE HORARIO(NHORARIO INTEGER PRIMARY KEY AUTOINCREMENT, NPROFESOR TEXT, NMAT TEXT, HORA TEXT, EDIFICIO TEXT, SALON TEXT, "
          "FOREIGN KEY (NPROFESOR) REFERENCES PROFESOR (NPROFESOR) ON DELETE CASCADE ON UPDATE CASCADE,"
          "FOREIGN KEY (NMAT) REFERENCES MATERIA (NMAT) ON DELETE CASCADE ON UPDATE CASCADE)",
        );
        await db.execute(
          "CREATE TABLE ASISTENCIA(IDASISTENCIA INTEGER PRIMARY KEY AUTOINCREMENT, NHORARIO INTEGER, FECHA TEXT, ASISTENCIA BOOLEAN, "
          "FOREIGN KEY (NHORARIO) REFERENCES HORARIO (NHORARIO) ON DELETE CASCADE ON UPDATE CASCADE)",
        );
      },
    );
  }

  static Future<List<Profesor>> MostrarProfesor() async{
    Database base = await _conectarDB();

    List<Map<String, dynamic>> temp = await base.query("PROFESOR");

    return List.generate(temp.length, (contador) {
      return Profesor(
        nprofesor: temp[contador]['NPROFESOR'],
        nombre: temp[contador]['NOMBRE'],
        carrera: temp[contador]['CARRERA'],
      );
    });
  }

  static Future<int> InsertarProfesor(Profesor p) async{
    Database base = await _conectarDB();
    return base.insert("PROFESOR", p.toJSON());
  }

  static Future<int> EliminarProfesor(String nprofesor) async{
    Database base = await _conectarDB();
    return base.delete("PROFESOR", where: "NPROFESOR=?", whereArgs: [nprofesor]);
  }
}
