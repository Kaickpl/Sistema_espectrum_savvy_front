// ignore_for_file: file_names

import 'package:espectrum_front/Config/ApiConfig.dart';
import 'package:espectrum_front/Model/TerapeutaModel.dart';
import 'package:espectrum_front/Model/TerapeutaResumoModel.dart';
import 'ApiService.dart';

class TerapeutaService {
  /// Busca os terapeutas da clínica do admin logado, já com a
  /// quantidade de pacientes vinculados a cada um.
  static Future<List<TerapeutaResumoModel>> buscarResumoPorAdmin(
    String token,
  ) async {
    final response = await ApiClient.get(
      '/terapeuta/admin/resumo',
      token: token,
    );

    final json = ApiService.decodeOrThrow(response) as List<dynamic>;
    return json
        .map(
          (item) => TerapeutaResumoModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  /// Desativa a conta do terapeuta (lixeira no card do terapeuta).
  static Future<void> desativarTerapeuta(String token, String id) async {
    final response = await ApiClient.delete('/terapeuta/$id', token: token);
    ApiService.decodeOrThrow(response);
  }

  /// Reativa a conta de um terapeuta previamente desativado.
  static Future<TerapeutaModel> reativarTerapeuta(
    String token,
    String id,
  ) async {
    final response = await ApiClient.patch(
      '/terapeuta/$id/reativar',
      null,
      token,
    );
    final json = ApiService.decodeOrThrow(response) as Map<String, dynamic>;
    return TerapeutaModel.fromJson(json);
  }

  /// Aprova o cadastro pendente de um terapeuta (feito pelo admin).
  static Future<TerapeutaModel> aprovarCadastro(String token, String id) async {
    final response = await ApiClient.put(
      '/admin/terapeuta/$id',
      {},
      token: token,
    );
    final json = ApiService.decodeOrThrow(response) as Map<String, dynamic>;
    return TerapeutaModel.fromJson(json);
  }

  /// Busca todos os terapeutas da clínica do admin logado, incluindo os
  /// desativados, para a tela de gerenciamento de terapeutas.
  static Future<List<TerapeutaModel>> buscarTodosPorAdmin(String token) async {
    final response = await ApiClient.get(
      '/terapeuta/admin/todos',
      token: token,
    );

    final json = ApiService.decodeOrThrow(response) as List<dynamic>;
    return json
        .map((item) => TerapeutaModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Busca os terapeutas com cadastro pendente de aprovação, usados para
  /// alimentar o indicador de notificação no painel do admin.
  static Future<List<TerapeutaModel>> buscarPendentes(String token) async {
    final response = await ApiClient.get(
      '/terapeuta/admin/pendentes',
      token: token,
    );

    final json = ApiService.decodeOrThrow(response) as List<dynamic>;
    return json
        .map((item) => TerapeutaModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

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
    final response = await ApiClient.post('/cadastro/cadastro-admin', {
      'nome': nome,
      'email': email,
      'numeroTelefone': numeroTelefone,
      'senha': senha,
      'cpf': cpf,
      'matricula': matricula,
      'periodo': periodo,
    }, token: token);

    final json = ApiService.decodeOrThrow(response) as Map<String, dynamic>;
    return TerapeutaModel.fromJson(json);
  }
}
