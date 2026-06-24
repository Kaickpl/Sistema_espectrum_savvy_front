import 'package:espectrum_front/Config/ApiConfig.dart';
import 'package:espectrum_front/Model/LoginResponseModel.dart';

import 'ApiService.dart';
import 'TokenStorage.dart';


class AuthService {
  static Future<LoginResponseModel> login(String login, String senha) async {
    final response = await ApiClient.post('/auth/login', {
      'login': login,
      'senha': senha,
    });

    final json = ApiService.decodeOrThrow(response) as Map<String, dynamic>;
    final loginResponse = LoginResponseModel.fromJson(json);

    await TokenStorage.salvarSessao(
      token: loginResponse.token,
      idUsuario: loginResponse.idUsuario,
      nome: loginResponse.nome,
      perfil: loginResponse.perfil,
    );

    return loginResponse;
  }

  static Future<void> logout() async {
    await TokenStorage.limparSessao();
  }
}
