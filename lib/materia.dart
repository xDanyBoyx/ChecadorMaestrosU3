class Materia {
  String nmat;
  String descripcion;

  Materia({required this.nmat, required this.descripcion});
  Map<String, dynamic> toJSON() {
    return {'nmat': nmat, 'descripcion': descripcion};
  }
}
