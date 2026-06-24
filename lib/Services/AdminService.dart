import 'package:espectrum_front/Config/ApiConfig.dart';
import 'package:espectrum_front/Model/AdminModel.dart';
import 'ApiService.dart';

class AdminService {
  static Future<AdminModel> cadastrarAdmin({
    required String nome,
    required String email,
    required String numeroTelefone,
    required String senha,
    String? cpf,
    required String registroProfissional,
  }) async {
    final response = await ApiClient.post('/cadastro/admin', {
      'nome': nome,
      'email': email,
      'numeroTelefone': numeroTelefone,
      'senha': senha,
      'cpf': cpf,
      'registroProfissional': registroProfissional,
    });

    final json = ApiService.decodeOrThrow(response) as Map<String, dynamic>;
    return AdminModel.fromJson(json);
  }
}
