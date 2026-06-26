import 'package:espectrum_front/Config/ApiConfig.dart';
import 'package:espectrum_front/Model/PacienteResumoModel.dart';
import 'package:espectrum_front/Model/PacienteVinculadoModel.dart';
import 'package:espectrum_front/Model/VinculoEscolarModel.dart';
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
        .map(
          (item) =>
              PacienteVinculadoModel.fromJson(item as Map<String, dynamic>),
        )
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
        .map(
          (item) => PacienteResumoModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  /// Lista os pacientes vinculados ao terapeuta atualmente logado.
  static Future<List<PacienteResumoModel>> listarMeusPacientesVinculados(
    String token,
  ) async {
    final response = await ApiClient.get(
      '/vinculos/meus-pacientes',
      token: token,
    );

    final json = ApiService.decodeOrThrow(response) as List<dynamic>;
    return json
        .map(
          (item) => PacienteResumoModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  /// Cria o vínculo entre um paciente e um terapeuta.
  static Future<void> vincularPaciente({
    required String token,
    required String idPaciente,
    required String idTerapeuta,
    String? anoLetivo,
  }) async {
    final response = await ApiClient.post('/vinculos', {
      'idPaciente': idPaciente,
      'idUsuario': idTerapeuta,
      if (anoLetivo != null) 'anoLetivo': anoLetivo,
    }, token: token);
    ApiService.decodeOrThrow(response);
  }

  /// Desfaz o vínculo entre um paciente e um terapeuta.
  static Future<void> desvincularPaciente(
    String token,
    String idVinculo,
  ) async {
    final response = await ApiClient.delete(
      '/vinculos/$idVinculo',
      token: token,
    );
    ApiService.decodeOrThrow(response);
  }

  /// Lista os professores vinculados a um paciente.
  static Future<List<VinculoEscolarModel>> listarVinculosEscolares(
    String token,
    String idPaciente,
  ) async {
    final response = await ApiClient.get(
      '/pacientes/$idPaciente',
      token: token,
    );

    final json = ApiService.decodeOrThrow(response) as Map<String, dynamic>;
    final vinculos = json['vinculosProfessor'] as List<dynamic>? ?? [];
    return vinculos
        .map(
          (item) => VinculoEscolarModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  /// Desfaz o vínculo entre um paciente e um professor.
  static Future<void> desvincularProfessor(
    String token,
    String idVinculo,
  ) async {
    final response = await ApiClient.delete(
      '/vinculos/escolares/$idVinculo',
      token: token,
    );
    ApiService.decodeOrThrow(response);
  }
}
