import 'package:espectrum_front/Model/Enum/GrauAutismo.dart';
import 'package:espectrum_front/Model/EnderecoModel.dart';

/// Modelo completo do paciente (id + dados editáveis), usado nas telas
/// de visualização e edição de pacientes.
class PacienteDetalheModel {
  final String id;
  final String nome;
  final DateTime? dataNascimento;
  final String genero;
  final String? cpf;
  final GrauAutismo grau;
  final EnderecoModel? endereco;

  PacienteDetalheModel({
    required this.id,
    required this.nome,
    this.dataNascimento,
    required this.genero,
    this.cpf,
    required this.grau,
    this.endereco,
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

  factory PacienteDetalheModel.fromJson(Map<String, dynamic> json) {
    return PacienteDetalheModel(
      id: json['id'],
      nome: json['nome'],
      dataNascimento: json['dataNascimento'] != null
          ? DateTime.parse(json['dataNascimento'])
          : null,
      genero: json['genero'],
      cpf: json['cpf'],
      grau: GrauAutismo.fromString(json['grau']),
      endereco: json['endereco'] != null
          ? EnderecoModel.fromJson(json['endereco'] as Map<String, dynamic>)
          : null,
    );
  }
}
