import 'package:espectrum_front/Config/ApiConfig.dart';
import 'package:espectrum_front/Model/UsuarioModel.dart';
import 'ApiService.dart';
import 'TokenStorage.dart';

class UsuarioService {
  /// Busca os dados do perfil do usuário autenticado.
  static Future<UsuarioModel> buscarPerfil(String token) async {
    final response = await ApiClient.get('/usuario/perfil', token: token);
    final json = ApiService.decodeOrThrow(response) as Map<String, dynamic>;
    return UsuarioModel.fromJson(json);
  }

  /// Atualiza nome, email e telefone do usuário autenticado.
  static Future<UsuarioModel> editarPerfil({
    required String token,
    required String nome,
    required String email,
    required String numeroTelefone,
  }) async {
    final response = await ApiClient.put('/usuario/perfil', {
      'nome': nome,
      'email': email,
      'numeroTelefone': numeroTelefone,
    }, token: token);

    final json = ApiService.decodeOrThrow(response) as Map<String, dynamic>;
    final novoToken = json['token'] as String;
    await TokenStorage.atualizarToken(novoToken);

    return UsuarioModel.fromJson(json['usuario'] as Map<String, dynamic>);
  }

  /// Desativa a conta do usuário autenticado.
  static Future<UsuarioModel> desativarConta(String token) async {
    final response = await ApiClient.patch('/usuario/desativar', null, token);
    final json = ApiService.decodeOrThrow(response) as Map<String, dynamic>;
    return UsuarioModel.fromJson(json);
  }

  /// Reativa a conta do usuário autenticado.
  static Future<UsuarioModel> reativarConta(String token) async {
    final response = await ApiClient.patch('/usuario/reativar', null, token);
    final json = ApiService.decodeOrThrow(response) as Map<String, dynamic>;
    return UsuarioModel.fromJson(json);
  }

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
