import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficoTeia extends StatelessWidget {
  final double pontAtencaoCompartilhada;
  final double pontBrincarSocial;
  final double pontAutoRegulacao;
  final double pontSocialEmocional;
  final double pontLinguagemSocial;
  final double pontComportamentos;
  final double pontLinguagemSocialNaoVerbal;
  const GraficoTeia({
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
    final cores = Theme.of(context).colorScheme;

    return SizedBox(
      height: 300,
      child: RadarChart(
        RadarChartData(
          tickCount: 5,
          ticksTextStyle: const TextStyle(fontSize: 10, color: Colors.grey),
          titleTextStyle: TextStyle(fontSize: 11, color: cores.onSurface),
          getTitle: (index, angle) {
            switch(index){
              case 0:
                return const RadarChartTitle(text: 'Atenção\nCompartilhada');
              case 1:
                return const RadarChartTitle(text: 'Brincar\nSocial');
              case 2:
                return const RadarChartTitle(text: 'Auto\nRegulação');
              case 3:
                return const RadarChartTitle(text: 'Social/\nEmocional');
              case 4:
                return const RadarChartTitle(text: 'Linguagem\nSocial');
              case 5:
                return const RadarChartTitle(text: 'Comportamentos');
              case 6:
                return const RadarChartTitle(text: 'Não\nVerbal');
              default:
                return const RadarChartTitle(text: '');
            }
          },
          dataSets: [
            RadarDataSet(
              fillColor: cores.primary.withOpacity(0.3),
              borderColor: cores.onPrimary,
              entryRadius: 4,
              dataEntries: [
                RadarEntry(value: pontAtencaoCompartilhada),
                RadarEntry(value: pontBrincarSocial),
                RadarEntry(value: pontAutoRegulacao),
                RadarEntry(value: pontSocialEmocional),
                RadarEntry(value: pontLinguagemSocial),
                RadarEntry(value: pontComportamentos),
                RadarEntry(value: pontLinguagemSocialNaoVerbal),
              ]
            )
          ]
        ),
        swapAnimationDuration: const Duration(milliseconds: 400),
      ),
    );
  }
}