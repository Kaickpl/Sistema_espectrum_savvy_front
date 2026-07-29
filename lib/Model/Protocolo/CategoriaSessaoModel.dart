import 'AtividadeSessaoModel.dart';
import 'AtividadeSessaoModel.dart';

class CategoriaSessaoModel {
  final String id;
  final String nomeCategoria;
  final List<AtividadeSessaoModel> atividades;

  CategoriaSessaoModel({
    required this.id,
    required this.nomeCategoria,
    required this.atividades,
  });

  factory CategoriaSessaoModel.fromJson(Map<String, dynamic> json) {
    return CategoriaSessaoModel(
      id: json['id'],
      nomeCategoria: json['nomeCategoria'],
      atividades: (json['atividades'] as List<dynamic>)
          .map((a) => AtividadeSessaoModel.fromJson(a))
          .toList(),
    );
  }
}