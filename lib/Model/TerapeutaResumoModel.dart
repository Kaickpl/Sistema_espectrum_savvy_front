class TerapeutaResumoModel {
  final String id;
  final String nome;
  final String statusCadastro;
  final int quantidadePacientes;

  TerapeutaResumoModel({
    required this.id,
    required this.nome,
    required this.statusCadastro,
    required this.quantidadePacientes,
  });

  factory TerapeutaResumoModel.fromJson(Map<String, dynamic> json) {
    return TerapeutaResumoModel(
      id: json['id'],
      nome: json['nome'],
      statusCadastro: json['statusCadastro'],
      quantidadePacientes: json['quantidadePacientes'] ?? 0,
    );
  }
}
