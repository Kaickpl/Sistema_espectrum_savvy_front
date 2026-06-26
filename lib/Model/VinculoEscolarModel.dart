class VinculoEscolarModel {
  final String id;
  final String professorNome;
  final String escola;

  VinculoEscolarModel({
    required this.id,
    required this.professorNome,
    required this.escola,
  });

  factory VinculoEscolarModel.fromJson(Map<String, dynamic> json) {
    return VinculoEscolarModel(
      id: json['id'],
      professorNome: json['usuarioVinculado']['nome'],
      escola: json['escola'],
    );
  }
}
