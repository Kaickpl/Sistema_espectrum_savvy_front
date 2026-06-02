import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficoBarra extends StatelessWidget {
  final double pontLinguagem;
  final double pontMotor;
  final double pontCognitivo;
  final double pontSocial;
  const GraficoBarra({
    super.key,
    required this.pontLinguagem,
    required this.pontMotor,
    required this.pontCognitivo,
    required this.pontSocial,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    return SizedBox(
      height: 300,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 5,
          minY: 0,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) => FlLine(
              color: cores.onSurface.withOpacity(0.05),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
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
                reservedSize: 30,
                interval: 1,
                getTitlesWidget: (value, meta) => SideTitleWidget(
                  meta: meta,
                  child: Text(
                    value.toInt().toString(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  String texto = '';
                  switch (value.toInt()) {
                    case 0:
                      texto = 'Linguagem';
                      break;
                    case 1:
                      texto = 'Motor';
                      break;
                    case 2:
                      texto = 'Cognitivo';
                      break;
                    case 3:
                      texto = 'Social';
                      break;
                  }
                  return SideTitleWidget(
                    meta: meta,
                    child: Text(
                      texto,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: pontLinguagem,
                  color: const Color(0xFF66A3FF),
                  width: 40,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: pontMotor,
                  color: const Color(0xFF33D69F),
                  width: 40,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            BarChartGroupData(
              x: 2,
              barRods: [
                BarChartRodData(
                  toY: pontCognitivo,
                  color: const Color(0xFFFFD44D),
                  width: 40,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            BarChartGroupData(
              x: 3,
              barRods: [
                BarChartRodData(
                  toY: pontSocial,
                  color: const Color(0xFFFFADC7),
                  width: 40,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
