import 'package:espectrum_front/Model/Enum/Perfil.dart';

class UsuarioModel {
  final String id;
  final String numeroTelefone;
  final String email;
  final String nome;
  final String cpf;
  final Perfil tipo;
  final bool isActive;
  final String? codigoConvite;

  UsuarioModel({
    required this.id,
    required this.numeroTelefone,
    required this.email,
    required this.nome,
    required this.cpf,
    required this.tipo,
    required this.isActive,
    this.codigoConvite,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'],
      numeroTelefone: json['numeroTelefone'],
      email: json['email'],
      nome: json['nome'],
      cpf: json['cpf'],
      tipo: Perfil.fromString(json['tipo']),
      isActive: json['isActive'] ?? json['active'] ?? true,
      codigoConvite: json['codigoConvite'],
    );
  }
}
