import 'package:espectrum_front/View/Widgets/botao_personalizado_filtro_relatorio.dart';
import 'package:espectrum_front/View/Widgets/cartaoObservacao.dart';
import 'package:espectrum_front/View/Widgets/cartao_paciente_relatorio.dart';
import 'package:espectrum_front/View/Widgets/cartao_pontuacoes.dart';
import 'package:espectrum_front/View/Widgets/grafico_barra.dart';
import 'package:espectrum_front/View/Widgets/grafico_linha_ano.dart';
import 'package:espectrum_front/View/Widgets/grafico_linha_semestre.dart';
import 'package:espectrum_front/View/Widgets/grafico_teia.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class RelatorioEvolucao extends StatefulWidget {
  const RelatorioEvolucao({super.key});

  @override
  State<RelatorioEvolucao> createState() => _RelatorioEvolucaoState();
}

class _RelatorioEvolucaoState extends State<RelatorioEvolucao> {
  int? intervaloSelecionado = 6;
  String categoriaSelecionada = 'Média Geral';
  final List<String> categorias = [
    'Média Geral',
    'Atenção Compartilhada',
    'Brincar Social',
    'Auto Regulação',
    'Social/Emocional',
    'Linguagem Social',
    'Comportamentos de Grupo',
    'Linguagem Social Não Verbal'
  ];
  List<double> obterDadosDaCategoria(){
    switch (categoriaSelecionada) {
      case 'Atenção Compartilhada':
        return [1.0, 2.0, 2.5, 3.0, 3.5, 4.0, 4.0, 4.5, 5.0, 5.0, 4.5, 5.0];
      case 'Brincar Social':
        return [2.0, 2.0, 1.5, 2.0, 3.0, 3.0, 3.5, 3.5, 4.0, 4.0, 4.5, 4.0];
      case 'Auto Regulação':
        return [3.0, 3.5, 3.0, 4.0, 4.0, 4.5, 4.5, 4.5, 5.0, 5.0, 4.5, 5.0];
      default: 
        return [3.0, 2.0, 4.0, 4.0, 1.0, 2.0, 3.0, 2.0, 4.0, 4.0, 1.0, 2.0];
    }
  }
  void escolherTipoGrafico(int intervalo) {
    setState(() {
      intervaloSelecionado = intervalo;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    final dadosAtuais = obterDadosDaCategoria();
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
                    height: 350,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cores.surface,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Histórico evolutivo',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            DropdownButton<String>(
                              value: categoriaSelecionada,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              style: TextStyle(color: cores.primary, fontSize: 14),
                              underline: Container(
                                height: 1,
                                color: cores.primary.withOpacity(0.5),
                              ),
                              onChanged: (String? novaCategoria) {
                                if (novaCategoria != null) {
                                  setState(() {
                                    categoriaSelecionada = novaCategoria;
                                  });
                                }
                              },
                              items: categorias.map<DropdownMenuItem<String>>((String valor) {
                                return DropdownMenuItem<String>(
                                  value: valor,
                                  child: Text(valor),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: intervaloSelecionado == 6
                              ? GraficoLinhaSemestre(
                                  pont1: dadosAtuais[0], 
                                  pont2: dadosAtuais[1], 
                                  pont3: dadosAtuais[2], 
                                  pont4: dadosAtuais[3], 
                                  pont5: dadosAtuais[4], 
                                  pont6: dadosAtuais[5],
                                )
                              : GraficoLinhaAno(
                                  pont1: dadosAtuais[0], pont2: dadosAtuais[1], 
                                  pont3: dadosAtuais[2], pont4: dadosAtuais[3], 
                                  pont5: dadosAtuais[4], pont6: dadosAtuais[5],
                                  pont7: dadosAtuais[6], pont8: dadosAtuais[7], 
                                  pont9: dadosAtuais[8], pont10: dadosAtuais[9], 
                                  pont11: dadosAtuais[10], pont12: dadosAtuais[11],
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
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
                          const SizedBox(height: 25),
                          intervaloSelecionado == 6
                          ? GraficoTeia(pontAtencaoCompartilhada: 2
                          , pontBrincarSocial: 1, pontAutoRegulacao: 3, pontSocialEmocional: 1, pontLinguagemSocial: 2, pontComportamentos: 4, pontLinguagemSocialNaoVerbal: 3)
                          : GraficoTeia(pontAtencaoCompartilhada: 3, pontBrincarSocial: 2, pontAutoRegulacao: 4, pontSocialEmocional: 2, pontLinguagemSocial: 3, pontComportamentos: 1, pontLinguagemSocialNaoVerbal: 2)
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
