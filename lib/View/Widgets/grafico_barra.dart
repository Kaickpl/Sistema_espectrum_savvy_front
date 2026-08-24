import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficoBarra extends StatelessWidget {
  final double pontAtencaoCompartilhada;
  final double pontBrincarSocial;
  final double pontAutoRegulacao;
  final double pontSocialEmocional;
  final double pontLinguagemSocial;
  final double pontComportamentos;
  final double pontLinguagemSocialNaoVerbal;
  const GraficoBarra({
    super.key,
    required this.pontAtencaoCompartilhada,
    required this.pontBrincarSocial,
    required this.pontAutoRegulacao,
    required this.pontSocialEmocional,
    required this.pontLinguagemSocial,
    required this.pontComportamentos,
    required this.pontLinguagemSocialNaoVerbal,
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
                      texto = 'Atencao Compartilhada';
                      break;
                    case 1:
                      texto = 'Brincar Social';
                      break;
                    case 2:
                      texto = 'Auto Regulacao';
                      break;
                    case 3:
                      texto = 'Social/Emocional';
                      break;
                    case 4:
                      texto = 'Linguagem Social';
                      break;
                    case 5:
                      texto = 'Comportamentos de Grupo e de Sala de Aula';
                      break;
                    case 6: 
                      texto = 'Linguagem Social Não Verbal';
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
                  toY: pontAtencaoCompartilhada,
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
                  toY: pontBrincarSocial,
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
                  toY: pontAutoRegulacao,
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
                  toY: pontSocialEmocional,
                  color: const Color.fromARGB(255, 203, 145, 253),
                  width: 40,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            BarChartGroupData(
              x: 4,
              barRods: [
                BarChartRodData(
                  toY: pontLinguagemSocial,
                  color: const Color.fromARGB(255, 255, 239, 18),
                  width: 40,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            BarChartGroupData(
              x: 5,
              barRods: [
                BarChartRodData(
                  toY: pontComportamentos,
                  color: const Color.fromARGB(255, 84, 68, 255),
                  width: 40,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            BarChartGroupData(
              x: 6,
              barRods: [
                BarChartRodData(
                  toY: pontLinguagemSocialNaoVerbal,
                  color: const Color.fromARGB(255, 128, 255, 147),
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
