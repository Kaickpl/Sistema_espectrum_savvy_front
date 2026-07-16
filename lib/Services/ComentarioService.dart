import 'package:espectrum_front/Config/ApiConfig.dart';
import 'package:espectrum_front/Model/Protocolo/ComentarioModel.dart';
import 'ApiService.dart';
import 'TokenStorage.dart';

class ComentarioService {
  static Future<ComentarioModel> comentarProtocolo(
    String sessaoId,
    String comentario,
  ) async {
    final token = await TokenStorage.lerToken();

    final response = await ApiClient.post('/api/comentario/sessao/$sessaoId', {
      'comentario': comentario,
    }, token: token);

    final json = ApiService.decodeOrThrow(response) as Map<String, dynamic>;
    return ComentarioModel.fromJson(json);
  }

  static Future<ComentarioModel> comentarCategoria(
    String categoriaSessaoId,
    String comentario,
  ) async {
    final token = await TokenStorage.lerToken();

    final response = await ApiClient.post(
      '/api/comentario/categoria/$categoriaSessaoId',
      {'comentario': comentario},
      token: token,
    );

    final json = ApiService.decodeOrThrow(response) as Map<String, dynamic>;
    return ComentarioModel.fromJson(json);
  }

  static Future<List<ComentarioModel>> buscarComentariosProtocolo(
    String sessaoId,
  ) async {
    final token = await TokenStorage.lerToken();

    final response = await ApiClient.get(
      '/api/comentario/sessao/$sessaoId',
      token: token,
    );

    final json = ApiService.decodeOrThrow(response) as List<dynamic>;
    return json
        .map((c) => ComentarioModel.fromJson(c as Map<String, dynamic>))
        .toList();
  }

  static Future<List<ComentarioModel>> buscarComentariosCategoria(
    String categoriaSessaoId,
  ) async {
    final token = await TokenStorage.lerToken();

    final response = await ApiClient.get(
      '/api/comentario/categoria/$categoriaSessaoId',
      token: token,
    );

    final json = ApiService.decodeOrThrow(response) as List<dynamic>;
    return json
        .map((c) => ComentarioModel.fromJson(c as Map<String, dynamic>))
        .toList();
  }
}
