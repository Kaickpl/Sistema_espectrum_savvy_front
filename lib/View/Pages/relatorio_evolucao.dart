import 'package:espectrum_front/Model/ApiExceptionModel.dart';
import 'package:espectrum_front/Model/RelatorioEvolucaoModel.dart';
import 'package:espectrum_front/Services/RelatorioPdfService.dart';
import 'package:espectrum_front/Services/RelatorioService.dart';
import 'package:espectrum_front/View/Widgets/botao_personalizado_filtro_relatorio.dart';
import 'package:espectrum_front/View/Widgets/cabecalho_padrao.dart';
import 'package:espectrum_front/View/Widgets/cartaoObservacao.dart';
import 'package:espectrum_front/View/Widgets/cartao_paciente_relatorio.dart';
import 'package:espectrum_front/View/Widgets/grafico_linha_semestre.dart';
import 'package:espectrum_front/View/Widgets/grafico_teia.dart';
import 'package:espectrum_front/View/Widgets/seletor_aplicacoes_relatorio.dart';
import 'package:espectrum_front/View/Widgets/tabela_comparativo_aplicacoes.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

const _mediaGeralLabel = 'Média Geral';
const List<String> _mesesAbreviados = [
  'Jan',
  'Fev',
  'Mar',
  'Abr',
  'Mai',
  'Jun',
  'Jul',
  'Ago',
  'Set',
  'Out',
  'Nov',
  'Dez',
];

enum _ModoRelatorio { geral, porAplicacao }

enum _SubModoAplicacao { individual, evolucao, comparativo }

const List<Color> _coresComparativo = [
  Color(0xFF3E6AE1),
  Color(0xFFE0A93E),
  Color(0xFF3EAE6A),
];

class RelatorioEvolucao extends StatefulWidget {
  final String pacienteId;
  final String pacienteNome;

  const RelatorioEvolucao({
    super.key,
    required this.pacienteId,
    required this.pacienteNome,
  });

  @override
  State<RelatorioEvolucao> createState() => _RelatorioEvolucaoState();
}

class _RelatorioEvolucaoState extends State<RelatorioEvolucao> {
  bool _carregando = true;
  String? _erro;
  RelatorioEvolucaoModel? _relatorio;

  int _intervaloSelecionado = 6;
  String _categoriaSelecionada = _mediaGeralLabel;
  bool _mostrarTodasObservacoes = false;
  bool _exportandoPdf = false;

  _ModoRelatorio _modo = _ModoRelatorio.geral;
  _SubModoAplicacao _subModo = _SubModoAplicacao.individual;
  Set<int> _aplicacoesSelecionadas = {};

  @override
  void initState() {
    super.initState();
    _carregarRelatorio();
  }

  int get _mesesParaBusca =>
      _modo == _ModoRelatorio.geral ? _intervaloSelecionado : 0;

  List<PontoEvolucaoModel> get _aplicacoesOrdenadas =>
      _relatorio?.evolucaoTemporal ?? [];

  List<PontoEvolucaoModel> get _aplicacoesFiltradas {
    final filtradas = _aplicacoesOrdenadas
        .where((p) => _aplicacoesSelecionadas.contains(p.numeroAplicacao))
        .toList();
    filtradas.sort((a, b) => a.numeroAplicacao.compareTo(b.numeroAplicacao));
    return filtradas;
  }

  Future<void> _carregarRelatorio() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final relatorio = await RelatorioService.buscarRelatorioEvolucao(
        widget.pacienteId,
        meses: _mesesParaBusca,
      );
      if (!mounted) return;
      setState(() {
        _relatorio = relatorio;
        if (_categoriaSelecionada != _mediaGeralLabel &&
            !relatorio.categorias.contains(_categoriaSelecionada)) {
          _categoriaSelecionada = _mediaGeralLabel;
        }
        _normalizarSelecaoAplicacoes();
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _erro = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(
        () => _erro = 'Não foi possível carregar o relatório de evolução.',
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _normalizarSelecaoAplicacoes() {
    final numeros = _aplicacoesOrdenadas.map((p) => p.numeroAplicacao).toList();
    if (numeros.isEmpty) {
      _aplicacoesSelecionadas = {};
      return;
    }
    switch (_subModo) {
      case _SubModoAplicacao.individual:
        if (_aplicacoesSelecionadas.length != 1 ||
            !numeros.contains(_aplicacoesSelecionadas.first)) {
          _aplicacoesSelecionadas = {numeros.last};
        }
        break;
      case _SubModoAplicacao.evolucao:
        _aplicacoesSelecionadas = _aplicacoesSelecionadas
            .where(numeros.contains)
            .toSet();
        if (_aplicacoesSelecionadas.isEmpty) {
          _aplicacoesSelecionadas = numeros.toSet();
        }
        break;
      case _SubModoAplicacao.comparativo:
        _aplicacoesSelecionadas = _aplicacoesSelecionadas
            .where(numeros.contains)
            .toSet();
        if (_aplicacoesSelecionadas.length < 2) {
          _aplicacoesSelecionadas = numeros.length >= 2
              ? {numeros[numeros.length - 2], numeros.last}
              : numeros.toSet();
        }
        break;
    }
  }

  void _alternarAplicacao(int numero) {
    setState(() {
      switch (_subModo) {
        case _SubModoAplicacao.individual:
          _aplicacoesSelecionadas = {numero};
          break;
        case _SubModoAplicacao.evolucao:
          if (_aplicacoesSelecionadas.contains(numero)) {
            if (_aplicacoesSelecionadas.length > 1) {
              _aplicacoesSelecionadas.remove(numero);
            }
          } else {
            _aplicacoesSelecionadas.add(numero);
          }
          break;
        case _SubModoAplicacao.comparativo:
          if (_aplicacoesSelecionadas.contains(numero)) {
            if (_aplicacoesSelecionadas.length > 2) {
              _aplicacoesSelecionadas.remove(numero);
            }
          } else if (_aplicacoesSelecionadas.length < 3) {
            _aplicacoesSelecionadas.add(numero);
          }
          break;
      }
    });
  }

  void _escolherModo(_ModoRelatorio modo) {
    if (modo == _modo) return;
    setState(() {
      _modo = modo;
      if (modo == _ModoRelatorio.porAplicacao) {
        _subModo = _SubModoAplicacao.individual;
      }
    });
    _carregarRelatorio();
  }

  void _escolherSubModo(_SubModoAplicacao subModo) {
    if (subModo == _subModo) return;
    setState(() {
      _subModo = subModo;
      _normalizarSelecaoAplicacoes();
    });
  }

  ModoExportacaoPdf get _modoExportacaoAtual {
    if (_modo == _ModoRelatorio.geral) return ModoExportacaoPdf.geral;
    switch (_subModo) {
      case _SubModoAplicacao.individual:
        return ModoExportacaoPdf.individual;
      case _SubModoAplicacao.evolucao:
        return ModoExportacaoPdf.evolucao;
      case _SubModoAplicacao.comparativo:
        return ModoExportacaoPdf.comparativo;
    }
  }

  Future<void> _exportarPdf() async {
    if (_relatorio == null || _exportandoPdf) return;
    setState(() => _exportandoPdf = true);
    try {
      final bytes = await RelatorioPdfService.gerarPdf(
        _relatorio!,
        intervaloMeses: _intervaloSelecionado,
        modo: _modoExportacaoAtual,
        aplicacoesSelecionadas: _modo == _ModoRelatorio.porAplicacao
            ? _aplicacoesFiltradas
            : null,
      );
      await Printing.layoutPdf(
        onLayout: (_) async => bytes,
        name: 'relatorio_evolucao_${_relatorio!.pacienteNome}.pdf',
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Não foi possível gerar o PDF do relatório: $e'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _exportandoPdf = false);
    }
  }

  void _escolherIntervalo(int meses) {
    if (meses == _intervaloSelecionado) return;
    setState(() => _intervaloSelecionado = meses);
    _carregarRelatorio();
  }

  String _formatarMesAno(DateTime data) {
    return '${_mesesAbreviados[data.month - 1]}/${data.year.toString().substring(2)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CabecalhoPadrao(titulo: "Relatório de Evolução"),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _erro != null
          ? _buildErro()
          : _buildConteudo(),
    );
  }

  Widget _buildErro() {
    final cores = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _erro!,
              textAlign: TextAlign.center,
              style: TextStyle(color: cores.error),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _carregarRelatorio,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConteudo() {
    final cores = Theme.of(context).colorScheme;
    final relatorio = _relatorio!;

    final observacoesFonte = _modo == _ModoRelatorio.porAplicacao
        ? relatorio.observacoes
              .where(
                (o) =>
                    o.numeroAplicacao == null ||
                    _aplicacoesSelecionadas.contains(o.numeroAplicacao),
              )
              .toList()
        : relatorio.observacoes;
    final observacoesVisiveis = _mostrarTodasObservacoes
        ? observacoesFonte
        : observacoesFonte.take(3).toList();

    return RefreshIndicator(
      onRefresh: _carregarRelatorio,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            CartaoPacienteRelatorio(
              nomePaciente: relatorio.pacienteNome,
              idade: relatorio.idade ?? 0,
              nivel: relatorio.nivelSuporte ?? 0,
              nomeTerapeuta: relatorio.nomeTerapeuta,
              onExportarPdf: _exportarPdf,
              exportando: _exportandoPdf,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Filtros de Análise'),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        BotaoPersonalizadoFiltroRelatorio(
                          titulo: 'Visão Geral',
                          icone: Icon(
                            Icons.insights,
                            color: cores.onSurface.withOpacity(0.7),
                          ),
                          selecionado: _modo == _ModoRelatorio.geral,
                          onTap: () => _escolherModo(_ModoRelatorio.geral),
                        ),
                        BotaoPersonalizadoFiltroRelatorio(
                          titulo: 'Por Aplicação',
                          icone: Icon(
                            Icons.layers_outlined,
                            color: cores.primary.withOpacity(0.7),
                          ),
                          selecionado: _modo == _ModoRelatorio.porAplicacao,
                          onTap: () =>
                              _escolherModo(_ModoRelatorio.porAplicacao),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_modo == _ModoRelatorio.geral)
                    ..._buildSecaoVisaoGeral(relatorio, cores)
                  else
                    ..._buildSecaoPorAplicacao(relatorio, cores),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Histórico de observações',
                        style: TextStyle(fontSize: 18),
                      ),
                      if (observacoesFonte.length > 3)
                        TextButton(
                          onPressed: () => setState(
                            () => _mostrarTodasObservacoes =
                                !_mostrarTodasObservacoes,
                          ),
                          child: Text(
                            _mostrarTodasObservacoes ? 'Ver menos' : 'Ver tudo',
                            style: TextStyle(color: cores.tertiary),
                          ),
                        ),
                    ],
                  ),
                  if (observacoesVisiveis.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Nenhuma observação registrada.',
                        style: TextStyle(
                          color: cores.onSurface.withOpacity(0.5),
                        ),
                      ),
                    )
                  else
                    Column(
                      children: observacoesVisiveis
                          .map(
                            (obs) => CartaoObservacao(
                              status: obs.categoria ?? 'Comentário geral',
                              data: obs.dataCriacao ?? DateTime.now(),
                              titulo: obs.autorNome != null
                                  ? 'Por ${obs.autorNome}'
                                  : 'Observação',
                              texto: obs.comentario,
                            ),
                          )
                          .toList(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildSecaoVisaoGeral(
    RelatorioEvolucaoModel relatorio,
    ColorScheme cores,
  ) {
    final categoriasDropdown = [_mediaGeralLabel, ...relatorio.categorias];

    final valoresGrafico = relatorio.evolucaoTemporal
        .map(
          (p) => _categoriaSelecionada == _mediaGeralLabel
              ? p.mediaGeral
              : (p.mediaPorCategoria[_categoriaSelecionada] ?? 0),
        )
        .toList();
    final labelsGrafico = relatorio.evolucaoTemporal
        .map((p) => p.data != null ? _formatarMesAno(p.data!) : '')
        .toList();

    final valoresTeia = relatorio.categorias
        .map((c) => relatorio.comparativoCategorias[c] ?? 0)
        .toList();

    return [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            BotaoPersonalizadoFiltroRelatorio(
              titulo: 'Últimos 6 meses',
              icone: Icon(
                Icons.calendar_month,
                color: cores.primary.withOpacity(0.7),
              ),
              selecionado: _intervaloSelecionado == 6,
              onTap: () => _escolherIntervalo(6),
            ),
            BotaoPersonalizadoFiltroRelatorio(
              titulo: 'Último ano',
              icone: Icon(
                Icons.calendar_month,
                color: cores.onSurface.withOpacity(0.7),
              ),
              selecionado: _intervaloSelecionado == 12,
              onTap: () => _escolherIntervalo(12),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      Container(
        height: 350,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cores.onPrimary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Histórico evolutivo',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 150),
                  child: DropdownButton<String>(
                    value: _categoriaSelecionada,
                    isExpanded: true,
                    dropdownColor: cores.onPrimary,
                    focusColor: Colors.transparent,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    style: TextStyle(color: cores.primary, fontSize: 13),
                    underline: Container(
                      height: 1,
                      color: cores.primary.withOpacity(0.5),
                    ),
                    onChanged: (String? novaCategoria) {
                      if (novaCategoria != null) {
                        setState(() => _categoriaSelecionada = novaCategoria);
                      }
                    },
                    items: categoriasDropdown.map<DropdownMenuItem<String>>((
                      valor,
                    ) {
                      return DropdownMenuItem<String>(
                        value: valor,
                        child: Text(
                          valor,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: valoresGrafico.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhum dado de evolução no período selecionado.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: cores.onSurface.withOpacity(0.5),
                        ),
                      ),
                    )
                  : GraficoLinhaSemestre(
                      valores: valoresGrafico,
                      labels: labelsGrafico,
                    ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      Container(
        decoration: BoxDecoration(
          color: cores.onSurface.withOpacity(0.05),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Text(
                'Comparativo por categoria',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 50),
              relatorio.categorias.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'Nenhuma categoria pontuada no período selecionado.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: cores.onSurface.withOpacity(0.5),
                        ),
                      ),
                    )
                  : GraficoTeia(
                      categorias: relatorio.categorias,
                      valores: valoresTeia,
                    ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildSecaoPorAplicacao(
    RelatorioEvolucaoModel relatorio,
    ColorScheme cores,
  ) {
    if (_aplicacoesOrdenadas.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text(
            'Nenhuma aplicação registrada para este paciente.',
            textAlign: TextAlign.center,
            style: TextStyle(color: cores.onSurface.withOpacity(0.5)),
          ),
        ),
      ];
    }

    final subModoLegenda = switch (_subModo) {
      _SubModoAplicacao.individual => 'Escolha uma aplicação:',
      _SubModoAplicacao.evolucao => 'Escolha uma ou mais aplicações:',
      _SubModoAplicacao.comparativo =>
        'Escolha 2 ou 3 aplicações para comparar:',
    };

    return [
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            BotaoPersonalizadoFiltroRelatorio(
              titulo: 'Individual',
              icone: Icon(
                Icons.description_outlined,
                color: cores.onSurface.withOpacity(0.7),
              ),
              selecionado: _subModo == _SubModoAplicacao.individual,
              onTap: () => _escolherSubModo(_SubModoAplicacao.individual),
            ),
            BotaoPersonalizadoFiltroRelatorio(
              titulo: 'Evolução',
              icone: Icon(
                Icons.show_chart,
                color: cores.onSurface.withOpacity(0.7),
              ),
              selecionado: _subModo == _SubModoAplicacao.evolucao,
              onTap: () => _escolherSubModo(_SubModoAplicacao.evolucao),
            ),
            BotaoPersonalizadoFiltroRelatorio(
              titulo: 'Comparativo',
              icone: Icon(
                Icons.compare_arrows,
                color: cores.onSurface.withOpacity(0.7),
              ),
              selecionado: _subModo == _SubModoAplicacao.comparativo,
              onTap: () => _escolherSubModo(_SubModoAplicacao.comparativo),
            ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      Text(subModoLegenda, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      SeletorAplicacoesRelatorio(
        aplicacoes: _aplicacoesOrdenadas,
        selecionadas: _aplicacoesSelecionadas,
        onToggle: _alternarAplicacao,
      ),
      const SizedBox(height: 20),
      switch (_subModo) {
        _SubModoAplicacao.individual => _buildIndividual(relatorio, cores),
        _SubModoAplicacao.evolucao => _buildEvolucaoSelecionada(cores),
        _SubModoAplicacao.comparativo => _buildComparativo(relatorio, cores),
      },
    ];
  }

  Widget _buildIndividual(RelatorioEvolucaoModel relatorio, ColorScheme cores) {
    if (_aplicacoesFiltradas.isEmpty) {
      return Text(
        'Selecione uma aplicação para visualizar os detalhes.',
        style: TextStyle(color: cores.onSurface.withOpacity(0.5)),
      );
    }
    final aplicacao = _aplicacoesFiltradas.first;
    final valores = relatorio.categorias
        .map((c) => aplicacao.mediaPorCategoria[c] ?? 0)
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: cores.onPrimary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Aplicação ${aplicacao.numeroAplicacao}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                'Média geral: ${aplicacao.mediaGeral.toStringAsFixed(1)}/5',
                style: TextStyle(
                  color: cores.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          relatorio.categorias.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'Nenhuma categoria pontuada nesta aplicação.',
                    style: TextStyle(color: cores.onSurface.withOpacity(0.5)),
                  ),
                )
              : GraficoTeia(categorias: relatorio.categorias, valores: valores),
        ],
      ),
    );
  }

  Widget _buildEvolucaoSelecionada(ColorScheme cores) {
    final pontos = _aplicacoesFiltradas;
    final valores = pontos
        .map(
          (p) => _categoriaSelecionada == _mediaGeralLabel
              ? p.mediaGeral
              : (p.mediaPorCategoria[_categoriaSelecionada] ?? 0),
        )
        .toList();
    final labels = pontos.map((p) => 'Ap. ${p.numeroAplicacao}').toList();
    final categoriasDropdown = [
      _mediaGeralLabel,
      ...(_relatorio?.categorias ?? []),
    ];

    return Container(
      height: 350,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cores.onPrimary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Evolução das aplicações selecionadas',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 150),
                child: DropdownButton<String>(
                  value: _categoriaSelecionada,
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  style: TextStyle(color: cores.primary, fontSize: 13),
                  underline: Container(
                    height: 1,
                    color: cores.primary.withOpacity(0.5),
                  ),
                  onChanged: (String? novaCategoria) {
                    if (novaCategoria != null) {
                      setState(() => _categoriaSelecionada = novaCategoria);
                    }
                  },
                  items: categoriasDropdown.map<DropdownMenuItem<String>>((
                    valor,
                  ) {
                    return DropdownMenuItem<String>(
                      value: valor,
                      child: Text(
                        valor,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: valores.length < 2
                ? Center(
                    child: Text(
                      'Selecione ao menos duas aplicações para ver a evolução.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: cores.onSurface.withOpacity(0.5)),
                    ),
                  )
                : GraficoLinhaSemestre(valores: valores, labels: labels),
          ),
        ],
      ),
    );
  }

  Widget _buildComparativo(
    RelatorioEvolucaoModel relatorio,
    ColorScheme cores,
  ) {
    final selecionadas = _aplicacoesFiltradas;
    if (selecionadas.length < 2) {
      return Text(
        'Selecione pelo menos duas aplicações para comparar.',
        style: TextStyle(color: cores.onSurface.withOpacity(0.5)),
      );
    }

    final inicial = selecionadas.first;
    final final_ = selecionadas.last;
    final series = [
      for (var i = 0; i < selecionadas.length; i++)
        SerieRadarRelatorio(
          label: 'Aplicação ${selecionadas[i].numeroAplicacao}',
          cor: _coresComparativo[i % _coresComparativo.length],
          valores: relatorio.categorias
              .map((c) => selecionadas[i].mediaPorCategoria[c] ?? 0)
              .toList(),
        ),
    ];

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: cores.onPrimary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Sobreposição por categoria',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              relatorio.categorias.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'Nenhuma categoria pontuada nas aplicações selecionadas.',
                        style: TextStyle(
                          color: cores.onSurface.withOpacity(0.5),
                        ),
                      ),
                    )
                  : GraficoTeia(
                      categorias: relatorio.categorias,
                      valores: const [],
                      series: series,
                    ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: cores.surface,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Evolução ponto a ponto',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              relatorio.categorias.isEmpty
                  ? Text(
                      'Nenhuma categoria pontuada nas aplicações selecionadas.',
                      style: TextStyle(color: cores.onSurface.withOpacity(0.5)),
                    )
                  : TabelaComparativoAplicacoes(
                      categorias: relatorio.categorias,
                      inicial: inicial,
                      final_: final_,
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
