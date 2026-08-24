import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficoLinhaSemestre extends StatelessWidget {
  final List<double> valores;
  final List<String> labels;
  const GraficoLinhaSemestre({
    super.key,
    required this.valores,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    final maxX = (valores.length - 1).clamp(0, double.infinity).toDouble();
    return Expanded(
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: maxX == 0 ? 1 : maxX,
          minY: 0,
          maxY: 5,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 1,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: cores.onSurface.withOpacity(0.1), strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(value.toInt().toString()),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final indice = value.toInt();
                  final texto = indice >= 0 && indice < labels.length
                      ? labels[indice]
                      : '';
                  return SideTitleWidget(
                    meta: meta,
                    space: 8,
                    child: Text(texto, style: const TextStyle(fontSize: 10)),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                for (int i = 0; i < valores.length; i++)
                  FlSpot(i.toDouble(), valores[i]),
              ],
              isCurved: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                      radius: 3,
                      color: cores.surface,
                      strokeWidth: 3,
                      strokeColor: cores.primary,
                    ),
              ),
              color: cores.primary,
              curveSmoothness: 0.3,
              barWidth: 4,
              belowBarData: BarAreaData(
                show: true,
                color: cores.primary.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
