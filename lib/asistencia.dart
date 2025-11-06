class Asistencia {
  int? idasistencia;
  int nhorario;
  String fecha;
  bool asistencia;

  Asistencia({
    this.idasistencia,
    required this.nhorario,
    required this.fecha,
    required this.asistencia,
  });

  Map<String, dynamic> toJSON() {
    return {
      'NHORARIO': nhorario,
      'FECHA': fecha,
      'ASISTENCIA': asistencia ? 1 : 0,
    };
  }

  factory Asistencia.fromMap(Map<String, dynamic> m) {
    return Asistencia(
      idasistencia: m['IDASISTENCIA'],
      nhorario: m['NHORARIO'],
      fecha: m['FECHA'],
      asistencia: (m['ASISTENCIA'] == 1),
    );
  }
}
