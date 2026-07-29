import 'package:espectrum_front/Config/ApiConfig.dart';

class UsuarioServiceTrocarSenha {
  /// Solicita o envio do código de recuperação para o e-mail informado.
  /// O backend sempre responde 200, mesmo se o e-mail não existir
  /// (segurança silenciosa), então não há como saber se o e-mail é válido.
  static Future<void> solicitarReset(String email) async {
    final response = await ApiClient.post(
      '/trocarSenha/solicitar-reset?email=${Uri.encodeComponent(email)}',
      {},
    );

    _validar(response, 'Erro ao solicitar recuperação de senha');
  }

  /// Redefine a senha usando o código de recuperação enviado por e-mail.
  static Future<void> redefinirSenha({
    required String email,
    required String token,
    required String novaSenha,
  }) async {
    final response = await ApiClient.post('/trocarSenha/redefinir-senha', {
      'email': email,
      'token': token,
      'novaSenha': novaSenha,
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
