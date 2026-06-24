import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persiste a sessão do usuário logado para mantê-lo autenticado
/// entre aberturas do app.
class TokenStorage {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static const String _keyToken = 'token';
  static const String _keyIdUsuario = 'idUsuario';
  static const String _keyNome = 'nome';
  static const String _keyPerfil = 'perfil';

  static Future<void> salvarSessao({
    required String token,
    required String idUsuario,
    required String nome,
    required String perfil,
  }) async {
    await _storage.write(key: _keyToken, value: token);
    await _storage.write(key: _keyIdUsuario, value: idUsuario);
    await _storage.write(key: _keyNome, value: nome);
    await _storage.write(key: _keyPerfil, value: perfil);
  }

  static Future<String?> lerToken() => _storage.read(key: _keyToken);

  static Future<String?> lerIdUsuario() => _storage.read(key: _keyIdUsuario);

  static Future<String?> lerNome() => _storage.read(key: _keyNome);

  static Future<String?> lerPerfil() => _storage.read(key: _keyPerfil);

  static Future<void> limparSessao() async {
    await _storage.deleteAll();
  }
}
