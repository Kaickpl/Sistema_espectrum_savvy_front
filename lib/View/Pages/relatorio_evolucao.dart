import 'package:espectrum_front/View/Widgets/botao_personalizado_filtro_relatorio.dart';
import 'package:espectrum_front/View/Widgets/cartaoObservacao.dart';
import 'package:espectrum_front/View/Widgets/cartao_paciente_relatorio.dart';
import 'package:espectrum_front/View/Widgets/cartao_pontuacoes.dart';
import 'package:espectrum_front/View/Widgets/grafico_barra.dart';
import 'package:espectrum_front/View/Widgets/grafico_linha_ano.dart';
import 'package:espectrum_front/View/Widgets/grafico_linha_semestre.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RelatorioEvolucao extends StatefulWidget {
  const RelatorioEvolucao({super.key});

  @override
  State<RelatorioEvolucao> createState() => _RelatorioEvolucaoState();
}

class _RelatorioEvolucaoState extends State<RelatorioEvolucao> {
  int? intervaloSelecionado;
  void escolherTipoGrafico(int intervalo) {
    setState(() {
      intervaloSelecionado = intervalo;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório de evolução'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const CartaoPacienteRelatorio(
              nomePaciente: 'Ismael Lins',
              idade: 3,
              nivel: 2,
              nomeTerapeuta: 'Dra. Ana Silva',
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Filtros de Análise'),
                  const SizedBox(height: 10),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        BotaoPersonalizadoFiltroRelatorio(
                          titulo: 'Últimos 6 meses',
                          icone: Icon(
                            Icons.calendar_month,
                            color: cores.onSurface.withOpacity(0.7),
                          ),
                          selecionado: intervaloSelecionado == 6,
                          onTap: () {
                            escolherTipoGrafico(6);
                          },
                        ),
                        BotaoPersonalizadoFiltroRelatorio(
                          titulo: 'Último ano',
                          icone: Icon(
                            Icons.calendar_month,
                            color: cores.onSurface.withOpacity(0.7),
                          ),
                          selecionado: intervaloSelecionado == 12,
                          onTap: () {
                            escolherTipoGrafico(12);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 300,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cores.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Histórico evolutivo',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        //grafico de Linha
                        intervaloSelecionado == 6
                            ? GraficoLinhaSemestre(
                                pont1: 3,
                                pont2: 2,
                                pont3: 4,
                                pont4: 4,
                                pont5: 1,
                                pont6: 2,
                              )
                            : GraficoLinhaAno(
                                pont1: 3,
                                pont2: 2,
                                pont3: 4,
                                pont4: 4,
                                pont5: 1,
                                pont6: 2,
                                pont7: 3,
                                pont8: 2,
                                pont9: 4,
                                pont10: 4,
                                pont11: 1,
                                pont12: 2,
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  //Comparativo por categoria
                  Container(
                    decoration: BoxDecoration(
                      color: cores.surface,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const Text(
                            'Comparativo por categoria',
                            style: TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 10),
                          intervaloSelecionado == 6
                              ? GraficoBarra(
                                  pontLinguagem: 2,
                                  pontMotor: 1,
                                  pontCognitivo: 3,
                                  pontSocial: 1,
                                )
                              : GraficoBarra(
                                  pontLinguagem: 3,
                                  pontMotor: 3,
                                  pontCognitivo: 5,
                                  pontSocial: 2,
                                ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  //historico de observações
                  Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Histórico de observações',
                              style: TextStyle(fontSize: 18),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                print(
                                  'ir pra pagina de ver todos os observações',
                                );
                              },
                              child: Text(
                                'Ver tudo',
                                style: TextStyle(color: cores.tertiary),
                              ),
                            ),
                          ],
                        ),
                        CartaoObservacao(
                          status: 'Linguagem Receptiva',
                          data: DateTime(2023, 10, 12),
                          titulo: 'Identificação de objetos',
                          texto:
                              'João demonstrou excelente progresso na identificação de animais. Conseguiu apontar 8 de 10 figuras corretamente sem ajuda física.',
                        ),
                        CartaoObservacao(
                          status: 'Motor fino',
                          data: DateTime(2023, 10, 12),
                          titulo: 'Movimento de Pinça',
                          texto:
                              'Apresentou leve resistência no início, mas após modelação, conseguiu transferir pequenos blocos entre potes por 3 minutos contínuos.',
                        ),
                      ],
                    ),
                  ),
                  //ultimas pontuações
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Últimas pontuações',
                              style: TextStyle(fontSize: 18),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                print(
                                  'ir pra pagina de ver todos os observações',
                                );
                              },
                              child: Text(
                                'Ver tudo',
                                style: TextStyle(color: cores.tertiary),
                              ),
                            ),
                          ],
                        ),
                        CartaoPontuacoes(
                          titulo: 'Contato visual',
                          icone: Icon(
                            Icons.remove_red_eye,
                            color: cores.tertiary,
                          ),
                          numSessao: 2,
                          data: DateTime(2026, 5, 3),
                          pontuacao: 4.5,
                        ),
                        CartaoPontuacoes(
                          titulo: 'Contato visual',
                          icone: Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: cores.tertiary,
                          ),
                          numSessao: 2,
                          data: DateTime(2026, 5, 3),
                          pontuacao: 4.5,
                        ),
                        CartaoPontuacoes(
                          titulo: 'Imitação motora',
                          icone: Icon(Icons.handshake, color: cores.tertiary),
                          numSessao: 2,
                          data: DateTime(2026, 5, 3),
                          pontuacao: 4.5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
