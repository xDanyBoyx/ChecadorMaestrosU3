class Horario {
  int? nhorario;
  String nprofesor;
  String nmat;
  String hora;
  String edificio;
  String salon;

  Horario({
    this.nhorario,
    required this.nprofesor,
    required this.nmat,
    required this.hora,
    required this.edificio,
    required this.salon,
  });
  Map<String, dynamic> toJSON() {
    return {
      'nprofesor': nprofesor,
      'nmat': nmat,
      'hora': hora,
      'edificio': edificio,
      'salon': salon,
    };
  }
}
