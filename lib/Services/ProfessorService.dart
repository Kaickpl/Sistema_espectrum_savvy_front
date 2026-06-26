import 'package:espectrum_front/Config/ApiConfig.dart';
import 'package:espectrum_front/Model/ProfessorModel.dart';
import 'package:espectrum_front/Model/ProfessorResumoModel.dart';
import 'ApiService.dart';

class ProfessorService {
  /// Lista todos os professores cadastrados no sistema.
  static Future<List<ProfessorResumoModel>> listarProfessores(
    String token,
  ) async {
    final response = await ApiClient.get('/professores', token: token);

    final json = ApiService.decodeOrThrow(response) as List<dynamic>;
    return json
        .map(
          (item) => ProfessorResumoModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  /// Cadastro de Professor feito por um Terapeuta ou Admin autenticado.
  static Future<ProfessorModel> cadastrarProfessor({
    required String token,
    required String nome,
    required String email,
    required String numeroTelefone,
    required String senha,
    required String cpf,
    required String escola,
  }) async {
    final response = await ApiClient.post('/cadastro/professor', {
      'nome': nome,
      'email': email,
      'numeroTelefone': numeroTelefone,
      'senha': senha,
      'cpf': cpf,
      'escola': escola,
    }, token: token);

    final json = ApiService.decodeOrThrow(response) as Map<String, dynamic>;
    return ProfessorModel.fromJson(json);
  }
}
