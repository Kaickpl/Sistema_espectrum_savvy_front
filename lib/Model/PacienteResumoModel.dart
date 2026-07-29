import 'package:espectrum_front/Model/Enum/GrauAutismo.dart';

class PacienteResumoModel {
  final String id;
  final String nome;
  final String genero;
  final GrauAutismo grauAutismo;
  final DateTime? dataNascimento;

  PacienteResumoModel({
    required this.id,
    required this.nome,
    required this.genero,
    required this.grauAutismo,
    this.dataNascimento,
  });

  /// Idade calculada a partir da data de nascimento, se disponível.
  int? get idade {
    if (dataNascimento == null) return null;
    final hoje = DateTime.now();
    int idade = hoje.year - dataNascimento!.year;
    if (hoje.month < dataNascimento!.month ||
        (hoje.month == dataNascimento!.month &&
            hoje.day < dataNascimento!.day)) {
      idade--;
    }
    return idade;
  }

  factory PacienteResumoModel.fromJson(Map<String, dynamic> json) {
    return PacienteResumoModel(
      id: json['id'],
      nome: json['nome'],
      genero: json['genero'],
      grauAutismo: GrauAutismo.fromString(json['grauAutismo']),
      dataNascimento: json['dataNascimento'] != null
          ? DateTime.parse(json['dataNascimento'])
          : null,
    );
  }
}
