import 'package:checador_asistencia_u3/asistencia.dart';
import 'package:checador_asistencia_u3/horario.dart';
import 'package:checador_asistencia_u3/materia.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'profesor.dart';

class DB {
  static Future<Database> _conectarDB() async {
    return openDatabase(
      join(await getDatabasesPath(), "checador_asistencia_4.db"),
      version: 4,
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
          "CREATE TABLE HORARIO(NHORARIO INTEGER PRIMARY KEY AUTOINCREMENT, NPROFESOR TEXT, NMAT TEXT, HORA TEXT, EDIFICIO TEXT, SALON TEXT, FOREIGN KEY (NPROFESOR) REFERENCES PROFESOR (NPROFESOR) ON DELETE CASCADE ON UPDATE CASCADE,FOREIGN KEY (NMAT) REFERENCES MATERIA (NMAT) ON DELETE CASCADE ON UPDATE CASCADE)",
        );
        await db.execute(
            "CREATE TABLE ASISTENCIA(IDASISTENCIA INTEGER PRIMARY KEY AUTOINCREMENT, NHORARIO INTEGER, FECHA TEXT, ASISTENCIA INTEGER, FOREIGN KEY (NHORARIO) REFERENCES HORARIO (NHORARIO) ON DELETE CASCADE ON UPDATE CASCADE)"
        );
      },
    );
  }

  //FUNCIONES TABLS PROFESOR

  static Future<List<Profesor>> MostrarProfesor() async {
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

  static Future<int> InsertarProfesor(Profesor p) async {
    Database base = await _conectarDB();
    return base.insert("PROFESOR", p.toJSON());
  }

  static Future<int> EliminarProfesor(String nprofesor) async {
    Database base = await _conectarDB();
    return base.delete(
      "PROFESOR",
      where: "NPROFESOR=?",
      whereArgs: [nprofesor],
    );
  }

  static Future<int> ActualizarProfesor(Profesor p) async {
    Database base = await _conectarDB();
    return base.update(
      "PROFESOR",
      p.toJSON(),
      where: "NPROFESOR=?",
      whereArgs: [p.nprofesor],
    );
  }

  //FUNCIONES TABLA MATERIAS
  static Future<List<Materia>> MostrarMaterias() async {
    Database base = await _conectarDB();

    List<Map<String, dynamic>> temp = await base.query("MATERIA");

    return List.generate(temp.length, (contador) {
      return Materia(
        nmat: temp[contador]['NMAT'],
        descripcion: temp[contador]['DESCRIPCION'],
      );
    });
  }

  static Future<int> CrearMateria(Materia m) async {
    Database base = await _conectarDB();
    return base.insert("MATERIA", m.toJSON());
  }

  static Future<int> EliminarMateira(String nmat) async {
    Database base = await _conectarDB();
    return base.delete("MATERIA", where: "NMAT=?", whereArgs: [nmat]);
  }

  static Future<int> ActualizarMateria(Materia m) async {
    Database base = await _conectarDB();
    return base.update(
      "MATERIA",
      m.toJSON(),
      where: "NMAT=?",
      whereArgs: [m.nmat],
    );
  }

  //FUNCIONES TABLA HORARIOS
  static Future<List<Horario>> MostrarHorarios() async {
    Database base = await _conectarDB();

    List<Map<String, dynamic>> temp = await base.query("HORARIO");

    return List.generate(temp.length, (contador) {
      return Horario(
        nhorario: temp[contador]['NHORARIO'],
        nprofesor: temp[contador]['NPROFESOR'],
        nmat: temp[contador]['NMAT'],
        hora: temp[contador]['HORA'],
        edificio: temp[contador]['EDIFICIO'],
        salon: temp[contador]['SALON'],
      );
    });
  }

  static Future<int> InsertarHorario(Horario h) async {
    Database base = await _conectarDB();
    return base.insert("HORARIO", h.toJSON());
  }

  static Future<int> EliminarHorario(int? nhorario) async {
    Database base = await _conectarDB();
    return base.delete(
      "HORARIO",
      where: "NHORARIO=?",
      whereArgs: [nhorario],
    );
  }

  static Future<int> ActualizarHorario(Horario h) async {
    Database base = await _conectarDB();
    return base.update(
      "HORARIO",
      h.toJSON(),
      where: "NHORARIO=?",
      whereArgs: [h.nhorario],
    );
  }

  static Future<List<Asistencia>> MostrarAsistencia() async {
    Database base = await _conectarDB();
    List<Map<String, dynamic>> temp = await base.query("ASISTENCIA");

    return List.generate(temp.length, (i) => Asistencia.fromMap(temp[i]));
  }


  static Future<int> InsertarAsistencia(Asistencia a) async {
    Database base = await _conectarDB();
    return base.insert("ASISTENCIA", a.toJSON());
  }

  static Future<int> EliminarAsistencia(int? idasistencia) async {
    Database base = await _conectarDB();
    return base.delete("ASISTENCIA", where: "idasistencia=?", whereArgs: [idasistencia]);
  }

  static Future<int> ActualizarAsistencia(Asistencia a) async {
    Database base = await _conectarDB();
    return base.update(
      "ASISTENCIA",
      a.toJSON(),
      where: "idasistencia=?",
      whereArgs: [a.idasistencia],
    );
  }

  //BUSQUEDA

  static Future<List<Map<String, dynamic>>> BuscarProfesoresPorHoraYEdificio(
      String hora, String edificio) async {
    final db = await _conectarDB();
    final resultado = await db.rawQuery('''
    SELECT P.nombre AS Profesor, H.hora, H.edificio, H.salon, M.descripcion AS Materia
    FROM HORARIO H
    JOIN PROFESOR P ON H.nprofesor = P.nprofesor
    JOIN MATERIA M ON H.nmat = M.nmat
    WHERE H.hora = ? AND H.edificio = ?
  ''', [hora, edificio]);

    return resultado;
  }

  static Future<List<Map<String, dynamic>>> BuscarProfesoresPorFechaAsistencia(
      String fecha) async {
    final db = await _conectarDB();
    final resultado = await db.rawQuery('''
    SELECT P.nombre AS Profesor, A.fecha, A.asistencia, M.descripcion AS Materia
    FROM ASISTENCIA A
    JOIN HORARIO H ON A.nhorario = H.nhorario
    JOIN PROFESOR P ON H.nprofesor = P.nprofesor
    JOIN MATERIA M ON H.nmat = M.nmat
    WHERE A.fecha = ? AND A.asistencia = 1
  ''', [fecha]);

    return resultado;
  }


  static Future<List<Map<String, dynamic>>> BuscarMateriasSinAsistencia() async {
    final db = await _conectarDB();
    final resultado = await db.rawQuery('''
    SELECT M.descripcion AS Materia, P.nombre AS Profesor, H.hora, H.edificio
    FROM HORARIO H
    JOIN MATERIA M ON H.nmat = M.nmat
    JOIN PROFESOR P ON H.nprofesor = P.nprofesor
    WHERE H.nhorario NOT IN (SELECT nhorario FROM ASISTENCIA)
  ''');
    return resultado;
  }

}
