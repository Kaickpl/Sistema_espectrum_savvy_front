import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:espectrum_front/Model/ApiExceptionModel.dart';

class ApiService {
  /// Decodifica a resposta do backend, lançando [ApiException] (com a
  /// mensagem vinda do próprio backend) quando o status não for 2xx.
  static dynamic decodeOrThrow(http.Response response) {
    final decoded = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    if (decoded is Map<String, dynamic>) {
      throw ApiException.fromJson(decoded);
    }

    throw ApiException(
      message: 'Erro ao comunicar com o servidor (status ${response.statusCode})',
      status: response.statusCode,
    );
  }
}
