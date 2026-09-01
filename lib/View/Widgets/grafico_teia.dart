import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SerieRadarRelatorio {
  final String label;
  final List<double> valores;
  final Color cor;

  const SerieRadarRelatorio({
    required this.label,
    required this.valores,
    required this.cor,
  });
}

class GraficoTeia extends StatelessWidget {
  final List<String> categorias;
  final List<double> valores;
  final List<SerieRadarRelatorio>? series;

  const GraficoTeia({
    super.key,
    required this.categorias,
    required this.valores,
    this.series,
  });

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final multiplasSeries = series != null && series!.isNotEmpty;

    return SizedBox(
      height: multiplasSeries ? 340 : 300,
      child: Column(
        children: [
          Expanded(
            child: RadarChart(
              RadarChartData(
                tickCount: 5,
                ticksTextStyle: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
                titleTextStyle: TextStyle(fontSize: 11, color: cores.onSurface),
                getTitle: (index, angle) => RadarChartTitle(
                  text: index >= 0 && index < categorias.length
                      ? categorias[index].replaceAll(' ', '\n')
                      : '',
                ),
                dataSets: multiplasSeries
                    ? [
                        for (final serie in series!)
                          RadarDataSet(
                            fillColor: serie.cor.withOpacity(0.15),
                            borderColor: serie.cor,
                            borderWidth: 2,
                            entryRadius: 3,
                            dataEntries: [
                              for (final valor in serie.valores)
                                RadarEntry(value: valor),
                            ],
                          ),
                      ]
                    : [
                        RadarDataSet(
                          fillColor: cores.primary.withOpacity(0.3),
                          borderColor: cores.onPrimary,
                          entryRadius: 4,
                          dataEntries: [
                            for (final valor in valores)
                              RadarEntry(value: valor),
                          ],
                        ),
                      ],
              ),
              swapAnimationDuration: const Duration(milliseconds: 400),
            ),
          ),
          if (multiplasSeries) ...[
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 4,
              children: [
                for (final serie in series!)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: serie.cor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(serie.label, style: const TextStyle(fontSize: 11)),
                    ],
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
