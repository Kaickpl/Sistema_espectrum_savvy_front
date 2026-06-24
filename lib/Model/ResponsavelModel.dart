import 'package:espectrum_front/Model/PacienteResumoModel.dart';

class ResponsavelModel {
  final String idResponsavel;
  final String numeroTelefone;
  final String? email;
  final String nome;
  final String? grauParentesco;
  final List<PacienteResumoModel> pacientesTutelados;

  ResponsavelModel({
    required this.idResponsavel,
    required this.numeroTelefone,
    this.email,
    required this.nome,
    this.grauParentesco,
    required this.pacientesTutelados,
  });

  factory ResponsavelModel.fromJson(Map<String, dynamic> json) {
    return ResponsavelModel(
      idResponsavel: json['idResponsavel'],
      numeroTelefone: json['numeroTelefone'],
      email: json['email'],
      nome: json['nome'],
      grauParentesco: json['grauParentesco'],
      pacientesTutelados: (json['pacientesTutelados'] as List<dynamic>? ?? [])
          .map((e) => PacienteResumoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
