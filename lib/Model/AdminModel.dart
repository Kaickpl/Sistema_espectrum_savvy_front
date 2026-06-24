import 'package:espectrum_front/Model/Enum/Perfil.dart';

class AdminModel {
  final String idAdmin;
  final String idUsuario;
  final String nome;
  final String numeroTelefone;
  final String email;
  final Perfil tipoPerfil;

  AdminModel({
    required this.idAdmin,
    required this.idUsuario,
    required this.nome,
    required this.numeroTelefone,
    required this.email,
    required this.tipoPerfil,
  });

  factory AdminModel.fromJson(Map<String, dynamic> json) {
    return AdminModel(
      idAdmin: json['idAdmin'],
      idUsuario: json['idUsuario'],
      nome: json['nome'],
      numeroTelefone: json['numeroTelefone'],
      email: json['email'],
      tipoPerfil: Perfil.fromString(json['tipoPerfil']),
    );
  }
}
