import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficoLinhaAno extends StatelessWidget {
  final double pont1;
  final double pont2;
  final double pont3;
  final double pont4;
  final double pont5;
  final double pont6;
  final double pont7;
  final double pont8;
  final double pont9;
  final double pont10;
  final double pont11;
  final double pont12;
  const GraficoLinhaAno({
    super.key,
    required this.pont1,
    required this.pont2,
    required this.pont3,
    required this.pont4,
    required this.pont5,
    required this.pont6,
    required this.pont7,
    required this.pont8,
    required this.pont9,
    required this.pont10,
    required this.pont11,
    required this.pont12,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    return Expanded(
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: 11,
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
                  String texto = '';
                  switch (value.toInt()) {
                    case 0:
                      texto = 'Jan';
                      break;
                    case 1:
                      texto = 'Fev';
                      break;
                    case 2:
                      texto = 'Mar';
                      break;
                    case 3:
                      texto = 'Abr';
                      break;
                    case 4:
                      texto = 'Mai';
                      break;
                    case 5:
                      texto = 'Jun';
                      break;
                    case 6:
                      texto = 'Jul';
                      break;
                    case 7:
                      texto = 'Ago';
                      break;
                    case 8:
                      texto = 'Set';
                      break;
                    case 9:
                      texto = 'Out';
                      break;
                    case 10:
                      texto = 'Nov';
                      break;
                    case 11:
                      texto = 'Dez';
                      break;
                  }
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
                FlSpot(0, pont1),
                FlSpot(1, pont2),
                FlSpot(2, pont3),
                FlSpot(3, pont4),
                FlSpot(4, pont5),
                FlSpot(5, pont6),
                FlSpot(6, pont7),
                FlSpot(7, pont8),
                FlSpot(8, pont9),
                FlSpot(9, pont10),
                FlSpot(10, pont11),
                FlSpot(11, pont12),
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
