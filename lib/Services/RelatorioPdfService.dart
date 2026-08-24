import 'dart:typed_data';
import 'package:espectrum_front/Model/RelatorioEvolucaoModel.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class RelatorioPdfService {
  static Future<Uint8List> gerarPdf(
    RelatorioEvolucaoModel relatorio, {
    required int intervaloMeses,
  }) async {
    final documento = pw.Document();
    final geradoEm = DateTime.now();

    documento.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => _cabecalho(relatorio, intervaloMeses),
        footer: (context) => _rodape(context, geradoEm),
        build: (context) => [
          pw.SizedBox(height: 16),
          _secaoTitulo('Histórico evolutivo'),
          _tabelaEvolucao(relatorio),
          pw.SizedBox(height: 20),
          _secaoTitulo('Comparativo por categoria'),
          _tabelaComparativo(relatorio),
          pw.SizedBox(height: 20),
          _secaoTitulo('Histórico de observações'),
          _listaObservacoes(relatorio),
          pw.SizedBox(height: 20),
        ],
      ),
    );

    return documento.save();
  }

  static pw.Widget _cabecalho(
    RelatorioEvolucaoModel relatorio,
    int intervaloMeses,
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
          'Período analisado: últimos $intervaloMeses meses',
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

  static pw.Widget _tabelaEvolucao(RelatorioEvolucaoModel relatorio) {
    if (relatorio.evolucaoTemporal.isEmpty) {
      return _textoVazio('Nenhum dado de evolução no período selecionado.');
    }
    return pw.TableHelper.fromTextArray(
      headers: const ['Sessão', 'Data', 'Média geral (/5)'],
      data: [
        for (var i = 0; i < relatorio.evolucaoTemporal.length; i++)
          [
            '${i + 1}',
            relatorio.evolucaoTemporal[i].data != null
                ? _formatarData(relatorio.evolucaoTemporal[i].data!)
                : '-',
            relatorio.evolucaoTemporal[i].mediaGeral.toStringAsFixed(1),
          ],
      ],
      headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
      cellStyle: const pw.TextStyle(fontSize: 10),
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
    );
  }

  static pw.Widget _tabelaComparativo(RelatorioEvolucaoModel relatorio) {
    if (relatorio.comparativoCategorias.isEmpty) {
      return _textoVazio(
        'Nenhuma categoria pontuada no período selecionado.',
      );
    }
    final entradas = relatorio.comparativoCategorias.entries.toList();
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

  static pw.Widget _listaObservacoes(RelatorioEvolucaoModel relatorio) {
    if (relatorio.observacoes.isEmpty) {
      return _textoVazio('Nenhuma observação registrada.');
    }
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        for (final obs in relatorio.observacoes)
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
                pw.Text(obs.comentario, style: const pw.TextStyle(fontSize: 10)),
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
