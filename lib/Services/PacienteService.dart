import 'package:espectrum_front/Config/ApiConfig.dart';
import 'package:espectrum_front/Model/ResponsavelModel.dart';

import 'ApiService.dart';

class PacienteService {
  /// Cadastra um paciente e o seu responsável em uma única operação.
  /// Requer um usuário autenticado com perfil ADMIN ou TERAPEUTA.
  static Future<ResponsavelModel> cadastrarPacienteEResponsavel({
    required String token,
    required String numeroTelefone,
    required String cpfResponsavel,
    required String nomeResponsavel,
    String? emailResponsavel,
    String? grauParentesco,
    required Map<String, dynamic> infosPaciente,
  }) async {
    final response = await ApiClient.post(
      '/cadastro/paciente-responsavel',
      {
        'numeroTelefone': numeroTelefone,
        'cpfResponsavel': cpfResponsavel,
        'nomeResponsavel': nomeResponsavel,
        'emailResponsavel': emailResponsavel,
        'grauParentesco': grauParentesco,
        'infosPaciente': infosPaciente,
      },
      token: token,
    );

    final json = ApiService.decodeOrThrow(response) as Map<String, dynamic>;
    return ResponsavelModel.fromJson(json);
  }
}
