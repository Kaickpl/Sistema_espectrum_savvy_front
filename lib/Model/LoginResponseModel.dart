class LoginResponseModel {
  final String token;
  final String idUsuario;
  final String nome;
  final String perfil;

  LoginResponseModel({
    required this.token,
    required this.idUsuario,
    required this.nome,
    required this.perfil,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'],
      idUsuario: json['idUsuario'],
      nome: json['nome'],
      perfil: json['perfil'],
    );
  }
}
