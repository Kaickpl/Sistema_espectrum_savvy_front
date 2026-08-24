import 'package:espectrum_front/Config/ApiConfig.dart';
import 'package:espectrum_front/Model/RelatorioEvolucaoModel.dart';
import 'ApiService.dart';
import 'TokenStorage.dart';

class RelatorioService {
  static Future<RelatorioEvolucaoModel> buscarRelatorioEvolucao(
    String pacienteId, {
    int meses = 6,
  }) async {
    final token = await TokenStorage.lerToken();

    final response = await ApiClient.get(
      '/api/relatorio/evolucao/paciente/$pacienteId?meses=$meses',
      token: token,
    );

    final json = ApiService.decodeOrThrow(response) as Map<String, dynamic>;
    return RelatorioEvolucaoModel.fromJson(json);
  }
}
