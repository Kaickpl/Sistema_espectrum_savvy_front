import 'package:espectrum_front/Config/ApiConfig.dart';
import 'package:espectrum_front/Model/Protocolo/ProtocoloSessaoModel.dart';
import 'ApiService.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'TokenStorage.dart';

class ProtocoloService {
  
  // 1. Iniciar Sessão (POST)
  static Future<ProtocoloSessaoModel> iniciarSessao(String pacienteId) async {
    
    final token = await TokenStorage.lerToken();

    print("🚨 OLHA O TOKEN AQUI: $token");

    final response = await ApiClient.post(
      '/api/sessao/iniciar/paciente/$pacienteId',
      {}, // Body vazio
      token: token, 
    );

    // Aproveitamos o método de tratamento de erro que o seu amigo criou
    final json = ApiService.decodeOrThrow(response) as Map<String, dynamic>;
    return ProtocoloSessaoModel.fromJson(json);
  }

  // 2. Atualizar Pontuação (PUT)
  static Future<void> atualizarPontuacao(String atividadeId, String novaPontuacao) async {
    final token = await TokenStorage.lerToken();

    final response = await ApiClient.put(
      '/api/atividade/$atividadeId',
      {'pontuacao': novaPontuacao},
      token: token,
    );

    // Verifica se a atualização foi bem sucedida
    ApiService.decodeOrThrow(response);
  }

  static Future<void> encerrarSessao(String sessaoId) async {
    final token = await TokenStorage.lerToken();

    final response = await ApiClient.post(
      '/api/sessao/$sessaoId/encerrar',
      {}, // Body vazio
      token: token,
    );

    // Verifica se o encerramento foi bem sucedido
    ApiService.decodeOrThrow(response);
  }
}