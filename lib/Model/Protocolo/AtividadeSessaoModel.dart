class AtividadeSessaoModel {
  final String id;
  final String nomeAtividade;
  String? pontuacao;
  int valorPontuacao;

  AtividadeSessaoModel({
    required this.id,
    required this.nomeAtividade,
    this.pontuacao,
    required this.valorPontuacao,
  });

  factory AtividadeSessaoModel.fromJson(Map<String, dynamic> json) {
    return AtividadeSessaoModel(
      id: json['id'],
      nomeAtividade: json['nomeAtividade'],
      pontuacao: json['pontuacao'],
      valorPontuacao: json['valorPontuacao'] ?? 0,
    );
  }
}