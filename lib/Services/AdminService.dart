import 'package:espectrum_front/Config/ApiConfig.dart';
import 'package:espectrum_front/Model/AdminDashboardModel.dart';
import 'package:espectrum_front/Model/AdminModel.dart';
import 'ApiService.dart';

class AdminService {
  /// Busca os números consolidados do painel administrativo
  /// (total de pacientes e de protocolos finalizados na clínica).
  static Future<AdminDashboardModel> buscarDashboard(String token) async {
    final response = await ApiClient.get('/admin/dashboard', token: token);

    final json = ApiService.decodeOrThrow(response) as Map<String, dynamic>;
    return AdminDashboardModel.fromJson(json);
  }

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
