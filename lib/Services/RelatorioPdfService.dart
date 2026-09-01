import 'dart:typed_data';
import 'package:espectrum_front/Model/RelatorioEvolucaoModel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

enum ModoExportacaoPdf { geral, individual, evolucao, comparativo }

class RelatorioPdfService {
  static Future<Uint8List> gerarPdf(
    RelatorioEvolucaoModel relatorio, {
    required int intervaloMeses,
    ModoExportacaoPdf modo = ModoExportacaoPdf.geral,
    List<PontoEvolucaoModel>? aplicacoesSelecionadas,
  }) async {
    final documento = pw.Document();
    final geradoEm = DateTime.now();
    final aplicacoes = aplicacoesSelecionadas ?? const [];

    documento.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) =>
            _cabecalho(relatorio, intervaloMeses, modo, aplicacoes),
        footer: (context) => _rodape(context, geradoEm),
        build: (context) => _corpo(relatorio, modo, aplicacoes),
      ),
    );

    return documento.save();
  }

  static List<pw.Widget> _corpo(
    RelatorioEvolucaoModel relatorio,
    ModoExportacaoPdf modo,
    List<PontoEvolucaoModel> aplicacoes,
  ) {
    switch (modo) {
      case ModoExportacaoPdf.geral:
        return [
          pw.SizedBox(height: 16),
          _secaoTitulo('Histórico evolutivo'),
          _tabelaEvolucao(relatorio.evolucaoTemporal),
          pw.SizedBox(height: 20),
          _secaoTitulo('Comparativo por categoria'),
          _tabelaCategorias(relatorio.comparativoCategorias),
          pw.SizedBox(height: 20),
          _secaoTitulo('Histórico de observações'),
          _listaObservacoes(relatorio.observacoes),
          pw.SizedBox(height: 20),
        ];
      case ModoExportacaoPdf.individual:
        final aplicacao = aplicacoes.isNotEmpty ? aplicacoes.first : null;
        return [
          pw.SizedBox(height: 16),
          _secaoTitulo('Pontuação por categoria'),
          aplicacao == null
              ? _textoVazio('Nenhuma aplicação selecionada.')
              : _tabelaCategorias(aplicacao.mediaPorCategoria),
          pw.SizedBox(height: 20),
          _secaoTitulo('Histórico de observações'),
          _listaObservacoes(_observacoesDaSelecao(relatorio, aplicacoes)),
          pw.SizedBox(height: 20),
        ];
      case ModoExportacaoPdf.evolucao:
        return [
          pw.SizedBox(height: 16),
          _secaoTitulo('Evolução das aplicações selecionadas'),
          _tabelaEvolucao(aplicacoes),
          pw.SizedBox(height: 20),
          _secaoTitulo('Comparativo por categoria (aplicações selecionadas)'),
          _tabelaCategorias(
            _mediaCategoriasSobre(aplicacoes, relatorio.categorias),
          ),
          pw.SizedBox(height: 20),
          _secaoTitulo('Histórico de observações'),
          _listaObservacoes(_observacoesDaSelecao(relatorio, aplicacoes)),
          pw.SizedBox(height: 20),
        ];
      case ModoExportacaoPdf.comparativo:
        final ordenadas = [...aplicacoes]
          ..sort((a, b) => a.numeroAplicacao.compareTo(b.numeroAplicacao));
        final inicial = ordenadas.isNotEmpty ? ordenadas.first : null;
        final final_ = ordenadas.isNotEmpty ? ordenadas.last : null;
        return [
          pw.SizedBox(height: 16),
          _secaoTitulo('Comparativo entre aplicações'),
          inicial == null || final_ == null
              ? _textoVazio('Selecione ao menos duas aplicações para comparar.')
              : _tabelaComparativo(relatorio.categorias, inicial, final_),
          pw.SizedBox(height: 20),
          _secaoTitulo('Histórico de observações'),
          _listaObservacoes(_observacoesDaSelecao(relatorio, aplicacoes)),
          pw.SizedBox(height: 20),
        ];
    }
  }

  static List<ObservacaoModel> _observacoesDaSelecao(
    RelatorioEvolucaoModel relatorio,
    List<PontoEvolucaoModel> aplicacoes,
  ) {
    final numeros = aplicacoes.map((a) => a.numeroAplicacao).toSet();
    return relatorio.observacoes
        .where(
          (o) =>
              o.numeroAplicacao == null || numeros.contains(o.numeroAplicacao),
        )
        .toList();
  }

  static Map<String, double> _mediaCategoriasSobre(
    List<PontoEvolucaoModel> pontos,
    List<String> categorias,
  ) {
    final resultado = <String, double>{};
    for (final categoria in categorias) {
      final valores = pontos
          .map((p) => p.mediaPorCategoria[categoria])
          .whereType<double>()
          .toList();
      if (valores.isNotEmpty) {
        resultado[categoria] = valores.reduce((a, b) => a + b) / valores.length;
      }
    }
    return resultado;
  }

  static String _tituloModo(
    ModoExportacaoPdf modo,
    List<PontoEvolucaoModel> aplicacoes,
  ) {
    switch (modo) {
      case ModoExportacaoPdf.geral:
        return 'Visão geral';
      case ModoExportacaoPdf.individual:
        return aplicacoes.isNotEmpty
            ? 'Aplicação ${aplicacoes.first.numeroAplicacao}'
            : 'Aplicação selecionada';
      case ModoExportacaoPdf.evolucao:
        return 'Evolução — aplicações ${aplicacoes.map((a) => a.numeroAplicacao).join(', ')}';
      case ModoExportacaoPdf.comparativo:
        final ordenadas = [...aplicacoes]
          ..sort((a, b) => a.numeroAplicacao.compareTo(b.numeroAplicacao));
        return ordenadas.length >= 2
            ? 'Comparativo — Aplicação ${ordenadas.first.numeroAplicacao} → Aplicação ${ordenadas.last.numeroAplicacao}'
            : 'Comparativo entre aplicações';
    }
  }

  static pw.Widget _cabecalho(
    RelatorioEvolucaoModel relatorio,
    int intervaloMeses,
    ModoExportacaoPdf modo,
    List<PontoEvolucaoModel> aplicacoes,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Relatório de evolução',
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.Text(
          '${relatorio.pacienteNome}'
          '${relatorio.idade != null ? ' • ${relatorio.idade} anos' : ''}'
          '${relatorio.nivelSuporte != null ? ' • TEA Nível ${relatorio.nivelSuporte}' : ''}',
          style: const pw.TextStyle(fontSize: 12),
        ),
        pw.Text(
          'Terapeuta responsável: ${relatorio.nomeTerapeuta}',
          style: const pw.TextStyle(fontSize: 12),
        ),
        pw.Text(
          modo == ModoExportacaoPdf.geral
              ? 'Período analisado: últimos $intervaloMeses meses'
              : _tituloModo(modo, aplicacoes),
          style: const pw.TextStyle(fontSize: 12),
        ),
        pw.Divider(height: 20),
      ],
    );
  }

  static pw.Widget _rodape(pw.Context context, DateTime geradoEm) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          'Gerado em ${_formatarDataHora(geradoEm)}',
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
        ),
        pw.Text(
          'Página ${context.pageNumber} de ${context.pagesCount}',
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
        ),
      ],
    );
  }

  static pw.Widget _secaoTitulo(String texto) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Text(
        texto,
        style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
      ),
    );
  }

  static pw.Widget _tabelaEvolucao(List<PontoEvolucaoModel> pontos) {
    if (pontos.isEmpty) {
      return _textoVazio('Nenhum dado de evolução no período selecionado.');
    }
    return pw.TableHelper.fromTextArray(
      headers: const ['Aplicação', 'Data', 'Média geral (/5)'],
      data: [
        for (final ponto in pontos)
          [
            '${ponto.numeroAplicacao}',
            ponto.data != null ? _formatarData(ponto.data!) : '-',
            ponto.mediaGeral.toStringAsFixed(1),
          ],
      ],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
      cellStyle: const pw.TextStyle(fontSize: 10),
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
    );
  }

  static pw.Widget _tabelaCategorias(Map<String, double> valoresPorCategoria) {
    if (valoresPorCategoria.isEmpty) {
      return _textoVazio('Nenhuma categoria pontuada no período selecionado.');
    }
    final entradas = valoresPorCategoria.entries.toList();
    return pw.TableHelper.fromTextArray(
      headers: const ['Categoria', 'Média (/5)'],
      data: [
        for (final entrada in entradas)
          [entrada.key, entrada.value.toStringAsFixed(1)],
      ],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
      cellStyle: const pw.TextStyle(fontSize: 10),
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
    );
  }

  static List<String> _linhaComparativo(
    String rotulo,
    double valorInicial,
    double valorFinal,
  ) {
    final delta = valorFinal - valorInicial;
    return [
      rotulo,
      valorInicial.toStringAsFixed(1),
      valorFinal.toStringAsFixed(1),
      '${delta > 0 ? '+' : ''}${delta.toStringAsFixed(1)}',
    ];
  }

  static pw.Widget _tabelaComparativo(
    List<String> categorias,
    PontoEvolucaoModel inicial,
    PontoEvolucaoModel final_,
  ) {
    return pw.TableHelper.fromTextArray(
      headers: [
        'Categoria',
        'Aplic. ${inicial.numeroAplicacao}',
        'Aplic. ${final_.numeroAplicacao}',
        'Evolução',
      ],
      data: [
        for (final categoria in categorias)
          _linhaComparativo(
            categoria,
            inicial.mediaPorCategoria[categoria] ?? 0,
            final_.mediaPorCategoria[categoria] ?? 0,
          ),
        _linhaComparativo(
          'Média geral do protocolo',
          inicial.mediaGeral,
          final_.mediaGeral,
        ),
      ],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
      cellStyle: const pw.TextStyle(fontSize: 10),
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
    );
  }

  static pw.Widget _listaObservacoes(List<ObservacaoModel> observacoes) {
    if (observacoes.isEmpty) {
      return _textoVazio('Nenhuma observação registrada.');
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        for (final obs in observacoes)
          pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  '${obs.categoria ?? 'Comentário geral'}'
                  '${obs.dataCriacao != null ? ' — ${_formatarData(obs.dataCriacao!)}' : ''}'
                  '${obs.autorNome != null ? ' — ${obs.autorNome}' : ''}',
                  style: pw.TextStyle(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  obs.comentario,
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
      ],
    );
  }

  static pw.Widget _textoVazio(String texto) {
    return pw.Text(
      texto,
      style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
    );
  }

  static String _formatarData(DateTime data) {
    return '${_doisDigitos(data.day)}/${_doisDigitos(data.month)}/${data.year}';
  }

  static String _formatarDataHora(DateTime data) {
    return '${_formatarData(data)} ${_doisDigitos(data.hour)}:${_doisDigitos(data.minute)}';
  }

  static String _doisDigitos(int valor) => valor.toString().padLeft(2, '0');
}
