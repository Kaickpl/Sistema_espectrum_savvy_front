import 'CategoriaSessaoModel.dart';

class ProtocoloSessaoModel {
  final String id;
  final String statusProtocolo;
  final List<CategoriaSessaoModel> categoriasSessao;
  final String? criadoPorNome;
  final String? pacienteId;
  final String? pacienteNome;

  ProtocoloSessaoModel({
    required this.id,
    required this.statusProtocolo,
    required this.categoriasSessao,
    this.criadoPorNome,
    this.pacienteId,
    this.pacienteNome,
  });

  factory ProtocoloSessaoModel.fromJson(Map<String, dynamic> json) {
    return ProtocoloSessaoModel(
      id: json['id'] ?? '',
      statusProtocolo: json['statusProtocolo'] ?? 'DESCONHECIDO',
      criadoPorNome: json['criadoPorNome'],
      pacienteId: json['pacienteId'],
      pacienteNome: json['pacienteNome'] ?? 'Paciente Desconhecido',
      categoriasSessao: json['categoriasSessao'] != null
          ? (json['categoriasSessao'] as List<dynamic>)
              .map((c) => CategoriaSessaoModel.fromJson(c))
              .toList()
          : [], 
    );
  }
}