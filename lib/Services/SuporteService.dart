import 'package:espectrum_front/Config/ApiConfig.dart';
import 'ApiService.dart';

class SuporteService {
  /// Envia uma solicitação de suporte do usuário logado.
  static Future<void> enviarSolicitacao(
    String token, {
    required Set<String> categorias,
    required String descricao,
    required String email,
  }) async {
    final response = await ApiClient.post(
      '/suporte',
      {
        'categorias': categorias.toList(),
        'descricao': descricao,
        'email': email,
      },
      token: token,
    );

    ApiService.decodeOrThrow(response);
  }
}
