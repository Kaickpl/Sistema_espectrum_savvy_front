class TerapeutaModel {
  final String id;
  final String numeroTelefone;
  final String email;
  final String nome;
  final String? matricula;
  final int periodo;
  final String statusCadastro;

  TerapeutaModel({
    required this.id,
    required this.numeroTelefone,
    required this.email,
    required this.nome,
    this.matricula,
    required this.periodo,
    required this.statusCadastro,
  });

  factory TerapeutaModel.fromJson(Map<String, dynamic> json) {
    return TerapeutaModel(
      id: json['id'],
      numeroTelefone: json['numeroTelefone'],
      email: json['email'],
      nome: json['nome'],
      matricula: json['matricula'],
      periodo: json['periodo'] ?? 0,
      statusCadastro: json['statusCadastro'],
    );
  }
}
