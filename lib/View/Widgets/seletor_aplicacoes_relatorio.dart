import 'package:espectrum_front/Model/RelatorioEvolucaoModel.dart';
import 'package:flutter/material.dart';

class SeletorAplicacoesRelatorio extends StatelessWidget {
  final List<PontoEvolucaoModel> aplicacoes;
  final Set<int> selecionadas;
  final ValueChanged<int> onToggle;

  const SeletorAplicacoesRelatorio({
    super.key,
    required this.aplicacoes,
    required this.selecionadas,
    required this.onToggle,
  });

  String _formatarData(DateTime? data) {
    if (data == null) return '';
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    return '$dia/$mes/${data.year.toString().substring(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    if (aplicacoes.isEmpty) {
      return Text(
        'Nenhuma aplicação registrada para este paciente.',
        style: TextStyle(color: cores.onSurface.withOpacity(0.5)),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final aplicacao in aplicacoes)
          FilterChip(
            label: Text(
              'Aplicação ${aplicacao.numeroAplicacao}'
              '${aplicacao.data != null ? ' • ${_formatarData(aplicacao.data)}' : ''}',
            ),
            selected: selecionadas.contains(aplicacao.numeroAplicacao),
            selectedColor: cores.primary.withOpacity(0.2),
            checkmarkColor: cores.primary,
            onSelected: (_) => onToggle(aplicacao.numeroAplicacao),
          ),
      ],
    );
  }
}
