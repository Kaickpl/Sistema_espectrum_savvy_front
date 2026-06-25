import 'package:espectrum_front/Model/Enum/GrauAutismo.dart';

/// Representa um paciente já vinculado a um terapeuta, incluindo o id
/// do próprio vínculo (necessário para a ação de desvincular).
class PacienteVinculadoModel {
  final String idVinculo;
  final String idPaciente;
  final String nome;
  final String genero;
  final GrauAutismo grauAutismo;

  PacienteVinculadoModel({
    required this.idVinculo,
    required this.idPaciente,
    required this.nome,
    required this.genero,
    required this.grauAutismo,
  });

  factory PacienteVinculadoModel.fromJson(Map<String, dynamic> json) {
    return PacienteVinculadoModel(
      idVinculo: json['idVinculo'],
      idPaciente: json['idPaciente'],
      nome: json['nome'],
      genero: json['genero'],
      grauAutismo: GrauAutismo.fromString(json['grauAutismo']),
    );
  }
}
