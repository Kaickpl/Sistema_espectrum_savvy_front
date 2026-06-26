class ProfessorResumoModel {
  final String id;
  final String nome;
  final String escola;

  ProfessorResumoModel({
    required this.id,
    required this.nome,
    required this.escola,
  });

  factory ProfessorResumoModel.fromJson(Map<String, dynamic> json) {
    return ProfessorResumoModel(
      id: json['id'],
      nome: json['nome'],
      escola: json['escola'],
    );
  }
}
