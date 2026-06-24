import 'package:espectrum_front/Config/ApiConfig.dart';
import 'package:espectrum_front/Model/TerapeutaModel.dart';
import 'ApiService.dart';

class TerapeutaService {
  /// Auto-cadastro público: exige o código de convite do administrador.
  static Future<TerapeutaModel> autoCadastro({
    required String nome,
    required String email,
    required String numeroTelefone,
    required String senha,
    required String cpf,
    required String matricula,
    required int periodo,
    required String codigoConvite,
  }) async {
    final response = await ApiClient.post('/cadastro/auto-cadastro', {
      'nome': nome,
      'email': email,
      'numeroTelefone': numeroTelefone,
      'senha': senha,
      'cpf': cpf,
      'matricula': matricula,
      'periodo': periodo,
      'codigoConvite': codigoConvite,
    });

    final json = ApiService.decodeOrThrow(response) as Map<String, dynamic>;
    return TerapeutaModel.fromJson(json);
  }

  /// Cadastro feito por um administrador autenticado (sem código de convite).
  static Future<TerapeutaModel> cadastroPeloAdmin({
    required String token,
    required String nome,
    required String email,
    required String numeroTelefone,
    required String senha,
    required String cpf,
    required String matricula,
    required int periodo,
  }) async {
    final response = await ApiClient.post(
      '/cadastro/cadastro-admin',
      {
        'nome': nome,
        'email': email,
        'numeroTelefone': numeroTelefone,
        'senha': senha,
        'cpf': cpf,
        'matricula': matricula,
        'periodo': periodo,
      },
      token: token,
    );

    final json = ApiService.decodeOrThrow(response) as Map<String, dynamic>;
    return TerapeutaModel.fromJson(json);
  }
}
