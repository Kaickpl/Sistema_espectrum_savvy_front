import 'package:espectrum_front/Model/ApiExceptionModel.dart';
import 'package:espectrum_front/Model/RelatorioEvolucaoModel.dart';
import 'package:espectrum_front/Services/RelatorioService.dart';
import 'package:espectrum_front/View/Widgets/botao_personalizado_filtro_relatorio.dart';
import 'package:espectrum_front/View/Widgets/cartaoObservacao.dart';
import 'package:espectrum_front/View/Widgets/cartao_paciente_relatorio.dart';
import 'package:espectrum_front/View/Widgets/cartao_pontuacoes.dart';
import 'package:espectrum_front/View/Widgets/grafico_linha_semestre.dart';
import 'package:espectrum_front/View/Widgets/grafico_teia.dart';
import 'package:flutter/material.dart';

const _mediaGeralLabel = 'Média Geral';
const List<String> _mesesAbreviados = [
  'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
  'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez',
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
  bool _mostrarTodasPontuacoes = false;

  @override
  void initState() {
    super.initState();
    _carregarRelatorio();
  }

  Future<void> _carregarRelatorio() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final relatorio = await RelatorioService.buscarRelatorioEvolucao(
        widget.pacienteId,
        meses: _intervaloSelecionado,
      );
      if (!mounted) return;
      setState(() {
        _relatorio = relatorio;
        if (_categoriaSelecionada != _mediaGeralLabel &&
            !relatorio.categorias.contains(_categoriaSelecionada)) {
          _categoriaSelecionada = _mediaGeralLabel;
        }
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

  void _escolherIntervalo(int meses) {
    if (meses == _intervaloSelecionado) return;
    setState(() => _intervaloSelecionado = meses);
    _carregarRelatorio();
  }

  String _formatarMesAno(DateTime data) {
    return '${_mesesAbreviados[data.month - 1]}/${data.year.toString().substring(2)}';
  }

  IconData _iconeParaAtividade(String categoria) {
    final texto = categoria.toLowerCase();
    if (texto.contains('linguagem')) return Icons.chat_bubble_outline_rounded;
    if (texto.contains('motor')) return Icons.handshake;
    if (texto.contains('social') || texto.contains('brincar')) {
      return Icons.groups_outlined;
    }
    return Icons.remove_red_eye;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório de evolução'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
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
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    final relatorio = _relatorio!;

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

    final observacoesVisiveis = _mostrarTodasObservacoes
        ? relatorio.observacoes
        : relatorio.observacoes.take(3).toList();
    final pontuacoesVisiveis = _mostrarTodasPontuacoes
        ? relatorio.ultimasPontuacoes
        : relatorio.ultimasPontuacoes.take(3).toList();

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
                          titulo: 'Últimos 6 meses',
                          icone: Icon(
                            Icons.calendar_month,
                            color: cores.onSurface.withOpacity(0.7),
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
                      color: cores.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Histórico evolutivo',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 150),
                              child: DropdownButton<String>(
                                value: _categoriaSelecionada,
                                isExpanded: true,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                style: TextStyle(
                                  color: cores.primary,
                                  fontSize: 13,
                                ),
                                underline: Container(
                                  height: 1,
                                  color: cores.primary.withOpacity(0.5),
                                ),
                                onChanged: (String? novaCategoria) {
                                  if (novaCategoria != null) {
                                    setState(
                                      () =>
                                          _categoriaSelecionada = novaCategoria,
                                    );
                                  }
                                },
                                items: categoriasDropdown
                                    .map<DropdownMenuItem<String>>((valor) {
                                      return DropdownMenuItem<String>(
                                        value: valor,
                                        child: Text(
                                          valor,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      );
                                    })
                                    .toList(),
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
                      color: cores.surface,
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
                          const SizedBox(height: 25),
                          relatorio.categorias.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 24,
                                  ),
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
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Histórico de observações',
                        style: TextStyle(fontSize: 18),
                      ),
                      if (relatorio.observacoes.length > 3)
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
                        style: TextStyle(color: cores.onSurface.withOpacity(0.5)),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Últimas pontuações',
                        style: TextStyle(fontSize: 18),
                      ),
                      if (relatorio.ultimasPontuacoes.length > 3)
                        TextButton(
                          onPressed: () => setState(
                            () => _mostrarTodasPontuacoes =
                                !_mostrarTodasPontuacoes,
                          ),
                          child: Text(
                            _mostrarTodasPontuacoes ? 'Ver menos' : 'Ver tudo',
                            style: TextStyle(color: cores.tertiary),
                          ),
                        ),
                    ],
                  ),
                  if (pontuacoesVisiveis.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        'Nenhuma pontuação registrada.',
                        style: TextStyle(color: cores.onSurface.withOpacity(0.5)),
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: pontuacoesVisiveis
                          .map(
                            (p) => CartaoPontuacoes(
                              titulo: p.nomeAtividade,
                              icone: Icon(
                                _iconeParaAtividade(p.categoria),
                                color: cores.tertiary,
                              ),
                              numSessao: p.numeroSessao,
                              data: p.data ?? DateTime.now(),
                              pontuacao: p.pontuacao,
                            ),
                          )
                          .toList(),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
