class ComentarioModel {
  final String id;
  final String comentario;
  final DateTime? dataCriacao;
  final String? autorId;
  final String? autorNome;

  ComentarioModel({
    required this.id,
    required this.comentario,
    this.dataCriacao,
    this.autorId,
    this.autorNome,
  });

  factory ComentarioModel.fromJson(Map<String, dynamic> json) {
    return ComentarioModel(
      id: json['id'] ?? '',
      comentario: json['comentario'] ?? '',
      dataCriacao: json['dataCriacao'] != null
          ? DateTime.tryParse(json['dataCriacao'])
          : null,
      autorId: json['autorId'],
      autorNome: json['autorNome'],
    );
  }
}
