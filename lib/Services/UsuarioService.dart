import 'package:espectrum_front/Config/ApiConfig.dart';

class UsuarioService {
  static Future<void> verificarEmail(String email) async {
    final response = await ApiClient.get(
      '/auth/verificar-email?email=${Uri.encodeComponent(email)}',
    );

    if (response.statusCode != 200) {
      final msg = response.body.isNotEmpty
          ? response.body
          : 'Email não encontrado';
      throw Exception(msg);
    }
  }

  static Future<void> recuperarSenha({
    required String email,
    required String novaSenha,
    required String confirmaSenha,
  }) async {
    final response = await ApiClient.post('/auth/recuperar-senha', {
      'email': email,
      'novaSenha': novaSenha,
      'confirmaSenha': confirmaSenha,
    });

    if (response.statusCode != 200) {
      final msg = response.body.isNotEmpty
          ? response.body
          : 'Erro ao trocar senha';
      throw Exception(msg);
    }
  }
}
