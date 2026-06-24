import 'package:espectrum_front/Model/Enum/GrauAutismo.dart';

class PacienteResumoModel {
  final String id;
  final String nome;
  final String genero;
  final GrauAutismo grauAutismo;

  PacienteResumoModel({
    required this.id,
    required this.nome,
    required this.genero,
    required this.grauAutismo,
  });

  factory PacienteResumoModel.fromJson(Map<String, dynamic> json) {
    return PacienteResumoModel(
      id: json['id'],
      nome: json['nome'],
      genero: json['genero'],
      grauAutismo: GrauAutismo.fromString(json['grauAutismo']),
    );
  }
}
