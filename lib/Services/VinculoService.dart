import 'package:espectrum_front/Config/ApiConfig.dart';
import 'package:espectrum_front/Model/PacienteResumoModel.dart';
import 'package:espectrum_front/Model/PacienteVinculadoModel.dart';
import 'ApiService.dart';

class VinculoService {
  /// Lista os pacientes já vinculados ao terapeuta informado.
  static Future<List<PacienteVinculadoModel>> listarPacientesVinculados(
    String token,
    String idTerapeuta,
  ) async {
    final response = await ApiClient.get(
      '/vinculos/terapeuta/$idTerapeuta/pacientes',
      token: token,
    );

    final json = ApiService.decodeOrThrow(response) as List<dynamic>;
    return json
        .map((item) => PacienteVinculadoModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Lista os pacientes da clínica que ainda não estão vinculados ao
  /// terapeuta informado, disponíveis para vinculação.
  static Future<List<PacienteResumoModel>> listarPacientesDisponiveis(
    String token,
    String idTerapeuta,
  ) async {
    final response = await ApiClient.get(
      '/vinculos/terapeuta/$idTerapeuta/pacientes-disponiveis',
      token: token,
    );

    final json = ApiService.decodeOrThrow(response) as List<dynamic>;
    return json
        .map((item) => PacienteResumoModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Cria o vínculo entre um paciente e um terapeuta.
  static Future<void> vincularPaciente({
    required String token,
    required String idPaciente,
    required String idTerapeuta,
  }) async {
    final response = await ApiClient.post(
      '/vinculos',
      {'idPaciente': idPaciente, 'idUsuario': idTerapeuta},
      token: token,
    );
    ApiService.decodeOrThrow(response);
  }

  /// Desfaz o vínculo entre um paciente e um terapeuta.
  static Future<void> desvincularPaciente(String token, String idVinculo) async {
    final response = await ApiClient.delete('/vinculos/$idVinculo', token: token);
    ApiService.decodeOrThrow(response);
  }
}
