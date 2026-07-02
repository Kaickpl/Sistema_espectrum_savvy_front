import 'package:espectrum_front/Config/ApiConfig.dart';
import 'package:espectrum_front/Model/PacienteDetalheModel.dart';
import 'package:espectrum_front/Model/ResponsavelModel.dart';

import 'ApiService.dart';

class PacienteService {
  /// Cadastra um paciente e o seu responsável em uma única operação.
  /// Requer um usuário autenticado com perfil SUPERVISOR_ESTAGIO ou TERAPEUTA.
  static Future<ResponsavelModel> cadastrarPacienteEResponsavel({
    required String token,
    required String numeroTelefone,
    required String cpfResponsavel,
    required String nomeResponsavel,
    String? emailResponsavel,
    String? grauParentesco,
    required Map<String, dynamic> infosPaciente,
  }) async {
    final response = await ApiClient.post('/cadastro/paciente-responsavel', {
      'numeroTelefone': numeroTelefone,
      'cpfResponsavel': cpfResponsavel,
      'nomeResponsavel': nomeResponsavel,
      'emailResponsavel': emailResponsavel,
      'grauParentesco': grauParentesco,
      'infosPaciente': infosPaciente,
    }, token: token);

    final json = ApiService.decodeOrThrow(response) as Map<String, dynamic>;
    return ResponsavelModel.fromJson(json);
  }

  /// Lista os pacientes vinculados ao usuário logado (terapeuta ou
  /// supervisor de estágio), já filtrados pelo backend por perfil.
  static Future<List<PacienteDetalheModel>> listarPacientes(
    String token,
  ) async {
    final response = await ApiClient.get('/pacientes', token: token);

    final json = ApiService.decodeOrThrow(response) as List<dynamic>;
    return json
        .map(
          (item) => PacienteDetalheModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  /// Busca os dados completos de um paciente para exibição/edição.
  static Future<PacienteDetalheModel> buscarPaciente(
    String token,
    String idPaciente,
  ) async {
    final response = await ApiClient.get(
      '/pacientes/$idPaciente',
      token: token,
    );

    final json = ApiService.decodeOrThrow(response) as Map<String, dynamic>;
    return PacienteDetalheModel.fromJson(json);
  }

  /// Atualiza os dados de um paciente.
  static Future<PacienteDetalheModel> editarPaciente({
    required String token,
    required String idPaciente,
    required Map<String, dynamic> dados,
  }) async {
    final response = await ApiClient.put(
      '/pacientes/$idPaciente',
      dados,
      token: token,
    );

    final json = ApiService.decodeOrThrow(response) as Map<String, dynamic>;
    return PacienteDetalheModel.fromJson(json);
  }

  /// Exclui (desativa) a conta de um paciente.
  static Future<void> excluirPaciente(String token, String idPaciente) async {
    final response = await ApiClient.delete(
      '/pacientes/$idPaciente',
      token: token,
    );
    ApiService.decodeOrThrow(response);
  }
}
