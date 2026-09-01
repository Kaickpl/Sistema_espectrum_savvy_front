class PontoEvolucaoModel {
  final String? sessaoId;
  final int numeroAplicacao;
  final DateTime? data;
  final double mediaGeral;
  final Map<String, double> mediaPorCategoria;

  PontoEvolucaoModel({
    this.sessaoId,
    required this.numeroAplicacao,
    required this.data,
    required this.mediaGeral,
    required this.mediaPorCategoria,
  });

  factory PontoEvolucaoModel.fromJson(Map<String, dynamic> json) {
    return PontoEvolucaoModel(
      sessaoId: json['sessaoId'],
      numeroAplicacao: json['numeroAplicacao'] ?? 0,
      data: json['data'] != null ? DateTime.tryParse(json['data']) : null,
      mediaGeral: (json['mediaGeral'] as num?)?.toDouble() ?? 0,
      mediaPorCategoria:
          (json['mediaPorCategoria'] as Map<String, dynamic>? ?? {}).map(
            (chave, valor) => MapEntry(chave, (valor as num).toDouble()),
          ),
    );
  }
}

class ObservacaoModel {
  final String id;
  final String comentario;
  final DateTime? dataCriacao;
  final String? autorNome;
  final String? categoria;
  final int? numeroAplicacao;

  ObservacaoModel({
    required this.id,
    required this.comentario,
    this.dataCriacao,
    this.autorNome,
    this.categoria,
    this.numeroAplicacao,
  });

  factory ObservacaoModel.fromJson(Map<String, dynamic> json) {
    return ObservacaoModel(
      id: json['id'] ?? '',
      comentario: json['comentario'] ?? '',
      dataCriacao: json['dataCriacao'] != null
          ? DateTime.tryParse(json['dataCriacao'])
          : null,
      autorNome: json['autorNome'],
      categoria: json['categoria'],
      numeroAplicacao: json['numeroAplicacao'],
    );
  }
}

class PontuacaoRecenteModel {
  final String nomeAtividade;
  final String categoria;
  final int numeroSessao;
  final DateTime? data;
  final double pontuacao;

  PontuacaoRecenteModel({
    required this.nomeAtividade,
    required this.categoria,
    required this.numeroSessao,
    this.data,
    required this.pontuacao,
  });

  factory PontuacaoRecenteModel.fromJson(Map<String, dynamic> json) {
    return PontuacaoRecenteModel(
      nomeAtividade: json['nomeAtividade'] ?? '',
      categoria: json['categoria'] ?? '',
      numeroSessao: json['numeroSessao'] ?? 0,
      data: json['data'] != null ? DateTime.tryParse(json['data']) : null,
      pontuacao: (json['pontuacao'] as num?)?.toDouble() ?? 0,
    );
  }
}

class RelatorioEvolucaoModel {
  final String pacienteId;
  final String pacienteNome;
  final int? idade;
  final int? nivelSuporte;
  final String nomeTerapeuta;
  final List<String> categorias;
  final List<PontoEvolucaoModel> evolucaoTemporal;
  final Map<String, double> comparativoCategorias;
  final List<ObservacaoModel> observacoes;
  final List<PontuacaoRecenteModel> ultimasPontuacoes;

  RelatorioEvolucaoModel({
    required this.pacienteId,
    required this.pacienteNome,
    this.idade,
    this.nivelSuporte,
    required this.nomeTerapeuta,
    required this.categorias,
    required this.evolucaoTemporal,
    required this.comparativoCategorias,
    required this.observacoes,
    required this.ultimasPontuacoes,
  });

  factory RelatorioEvolucaoModel.fromJson(Map<String, dynamic> json) {
    return RelatorioEvolucaoModel(
      pacienteId: json['pacienteId'] ?? '',
      pacienteNome: json['pacienteNome'] ?? '',
      idade: json['idade'],
      nivelSuporte: json['nivelSuporte'],
      nomeTerapeuta: json['nomeTerapeuta'] ?? 'Não atribuído',
      categorias: (json['categorias'] as List<dynamic>? ?? [])
          .map((c) => c.toString())
          .toList(),
      evolucaoTemporal: (json['evolucaoTemporal'] as List<dynamic>? ?? [])
          .map((p) => PontoEvolucaoModel.fromJson(p as Map<String, dynamic>))
          .toList(),
      comparativoCategorias:
          (json['comparativoCategorias'] as Map<String, dynamic>? ?? {}).map(
            (chave, valor) => MapEntry(chave, (valor as num).toDouble()),
          ),
      observacoes: (json['observacoes'] as List<dynamic>? ?? [])
          .map((o) => ObservacaoModel.fromJson(o as Map<String, dynamic>))
          .toList(),
      ultimasPontuacoes: (json['ultimasPontuacoes'] as List<dynamic>? ?? [])
          .map((p) => PontuacaoRecenteModel.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }
}
