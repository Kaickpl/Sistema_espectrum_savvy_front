import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficoTeia extends StatelessWidget {
  final List<String> categorias;
  final List<double> valores;
  const GraficoTeia({
    super.key,
    required this.categorias,
    required this.valores,
  });

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return SizedBox(
      height: 300,
      child: RadarChart(
        RadarChartData(
          tickCount: 5,
          ticksTextStyle: const TextStyle(fontSize: 10, color: Colors.grey),
          titleTextStyle: TextStyle(fontSize: 11, color: cores.onSurface),
          getTitle: (index, angle) => RadarChartTitle(
            text: index >= 0 && index < categorias.length
                ? categorias[index].replaceAll(' ', '\n')
                : '',
          ),
          dataSets: [
            RadarDataSet(
              fillColor: cores.primary.withOpacity(0.3),
              borderColor: cores.onPrimary,
              entryRadius: 4,
              dataEntries: [
                for (final valor in valores) RadarEntry(value: valor),
              ],
            ),
          ],
        ),
        swapAnimationDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}
