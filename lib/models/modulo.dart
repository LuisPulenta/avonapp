class Modulo {
  int idModulo = 0;
  String nombre = '';
  String nroVersion = '';
  String link = '';
  String fechaRelease = '';
  int actualizOblig = 0;

  Modulo(
      {required this.idModulo,
      required this.nombre,
      required this.nroVersion,
      required this.link,
      required this.fechaRelease,
      required this.actualizOblig});

  Modulo.fromJson(Map<String, dynamic> json) {
    idModulo = json['idModulo'];
    nombre = json['nombre'];
    nroVersion = json['nroVersion'];
    link = json['link'];
    fechaRelease = json['fechaRelease'];
    actualizOblig = json['actualizOblig'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['idModulo'] = idModulo;
    data['nombre'] = nombre;
    data['nroVersion'] = nroVersion;
    data['link'] = link;
    data['fechaRelease'] = fechaRelease;
    data['actualizOblig'] = actualizOblig;
    return data;
  }
}
