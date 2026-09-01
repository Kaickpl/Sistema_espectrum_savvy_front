import 'package:espectrum_front/Model/RelatorioEvolucaoModel.dart';
import 'package:flutter/material.dart';

class TabelaComparativoAplicacoes extends StatelessWidget {
  final List<String> categorias;
  final PontoEvolucaoModel inicial;
  final PontoEvolucaoModel final_;

  const TabelaComparativoAplicacoes({
    super.key,
    required this.categorias,
    required this.inicial,
    required this.final_,
  });

  Widget _linha(
    BuildContext context,
    String rotulo,
    double valorInicial,
    double valorFinal, {
    bool destaque = false,
  }) {
    final cores = Theme.of(context).colorScheme;
    final delta = valorFinal - valorInicial;
    final corDelta = delta > 0
        ? Colors.green.shade600
        : (delta < 0 ? cores.error : cores.onSurface.withOpacity(0.5));
    final icone = delta > 0
        ? Icons.arrow_upward_rounded
        : (delta < 0 ? Icons.arrow_downward_rounded : Icons.remove_rounded);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              rotulo,
              style: TextStyle(
                fontWeight: destaque ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              valorInicial.toStringAsFixed(1),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              valorFinal.toStringAsFixed(1),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icone, size: 14, color: corDelta),
                const SizedBox(width: 2),
                Text(
                  '${delta > 0 ? '+' : ''}${delta.toStringAsFixed(1)}',
                  style: TextStyle(color: corDelta, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              flex: 3,
              child: Text(
                'Categoria',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Aplic. ${inicial.numeroAplicacao}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Aplic. ${final_.numeroAplicacao}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
            const Expanded(
              flex: 2,
              child: Text(
                'Evolução',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        Divider(color: cores.onSurface.withOpacity(0.1)),
        for (final categoria in categorias)
          _linha(
            context,
            categoria,
            inicial.mediaPorCategoria[categoria] ?? 0,
            final_.mediaPorCategoria[categoria] ?? 0,
          ),
        Divider(color: cores.onSurface.withOpacity(0.1)),
        _linha(
          context,
          'Média geral do protocolo',
          inicial.mediaGeral,
          final_.mediaGeral,
          destaque: true,
        ),
      ],
    );
  }
}
