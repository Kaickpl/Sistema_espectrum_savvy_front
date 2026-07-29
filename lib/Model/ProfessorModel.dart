class ProfessorModel {
  final String idProfessor;
  final String numeroTelefone;
  final String email;
  final String nome;
  final String escola;

  ProfessorModel({
    required this.idProfessor,
    required this.numeroTelefone,
    required this.email,
    required this.nome,
    required this.escola,
  });

  factory ProfessorModel.fromJson(Map<String, dynamic> json) {
    return ProfessorModel(
      idProfessor: json['idProfessor'],
      numeroTelefone: json['numeroTelefone'],
      email: json['email'],
      nome: json['nome'],
      escola: json['escola'],
    );
  }
}
