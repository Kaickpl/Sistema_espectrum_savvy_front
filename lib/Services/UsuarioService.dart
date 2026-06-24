import 'package:espectrum_front/Config/ApiConfig.dart';

class UsuarioService {
  static Future<void> verificarEmail(String email) async {
    final response = await ApiClient.get(
      '/auth/verificar-email?email=${Uri.encodeComponent(email)}',
    );

    _validar(response, 'Email não encontrado');
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

    _validar(response, 'Erro ao trocar senha');
  }

  /// Valida resposta de endpoints que retornam TEXTO puro (não JSON).
  static void _validar(response, String mensagemPadrao) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;

    final msg = response.body.isNotEmpty ? response.body : mensagemPadrao;
    throw Exception(msg);
  }
}
