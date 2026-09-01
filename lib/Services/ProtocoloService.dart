import 'package:espectrum_front/Config/ApiConfig.dart';
import 'package:espectrum_front/Model/Protocolo/ProtocoloSessaoModel.dart';
import 'ApiService.dart';
import 'TokenStorage.dart';

class ProtocoloService {
  // 1. Iniciar Sessão (POST)
  static Future<ProtocoloSessaoModel> iniciarSessao(String pacienteId) async {
    final token = await TokenStorage.lerToken();

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
  static Future<void> atualizarPontuacao(
    String atividadeId,
    String novaPontuacao,
  ) async {
    final token = await TokenStorage.lerToken();

    final response = await ApiClient.put('/api/atividade/$atividadeId', {
      'pontuacao': novaPontuacao,
    }, token: token);

    // Verifica se a atualização foi bem sucedida
    ApiService.decodeOrThrow(response);
  }

  static Future<void> encerrarSessao(String sessaoId) async {
    final token = await TokenStorage.lerToken();

    final response = await ApiClient.put(
      '/api/sessao/$sessaoId/finalizar',
      {}, // Body vazio
      token: token,
    );

    // Verifica se o encerramento foi bem sucedido
    ApiService.decodeOrThrow(response);
  }

  // 3. Salvar progresso (POST)
  static Future<ProtocoloSessaoModel> salvarProgresso(String sessaoId) async {
    final token = await TokenStorage.lerToken();

    final response = await ApiClient.post(
      '/api/sessao/$sessaoId/salvar',
      {}, // Body vazio
      token: token,
    );

    final json = ApiService.decodeOrThrow(response) as Map<String, dynamic>;
    return ProtocoloSessaoModel.fromJson(json);
  }

  // 4. Buscar status do protocolo de um paciente (GET)
  static Future<String> buscarStatusProtocolo(String pacienteId) async {
    final token = await TokenStorage.lerToken();

    final response = await ApiClient.get(
      '/api/sessao/paciente/$pacienteId',
      token: token,
    );

    // O backend retorna 400 quando o paciente ainda não possui nenhuma sessão
    if (response.statusCode == 400) {
      return 'NAO_INICIADO';
    }

    final json = ApiService.decodeOrThrow(response) as List<dynamic>;
    final sessoes = json
        .map((s) => ProtocoloSessaoModel.fromJson(s as Map<String, dynamic>))
        .toList();

    final temSessaoEmAndamento = sessoes.any(
      (s) => s.statusProtocolo == 'EM_ANDAMENTO',
    );

    return temSessaoEmAndamento ? 'EM_ANDAMENTO' : 'NAO_INICIADO';
  }
}
