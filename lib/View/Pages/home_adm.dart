import 'package:espectrum_front/View/Widgets/cartao_acoes_rapidas.dart';
import 'package:espectrum_front/View/Widgets/cartao_aluno.dart';
import 'package:espectrum_front/View/Widgets/cartao_relatorio.dart';
import 'package:flutter/material.dart';

class HomeAdm extends StatefulWidget {
  const HomeAdm({super.key});

  @override
  State<HomeAdm> createState() => _HomeAdmState();
}

class _HomeAdmState extends State<HomeAdm> {
  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    final coresPrimaria = cores.primary;
    final corSecundaria = cores.secondary;
    final corTerciaria = cores.tertiary;
    final corLetras = cores.onSurface;
    final corFundo = tema.scaffoldBackgroundColor;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: corFundo,
        foregroundColor: cores.onSecondary,
        actions: [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 146,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bem-vindo de volta',
                      style: TextStyle(
                        color: corLetras.withOpacity(0.4),
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Painel administrativo',
                      style: TextStyle(fontSize: 28),
                    ),
                  ],
                ),
              ),
            ),
            // resumo geral
            Container(
              height: 200,
              width: 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumo Geral',
                    style: TextStyle(
                      fontSize: 20,
                      color: corLetras.withOpacity(0.6),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // total de pacientes
                      Container(
                        height: 170,
                        width: 115,
                        decoration: BoxDecoration(
                          color: cores.surface.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: corLetras.withOpacity(0.1),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: coresPrimaria.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Icon(Icons.group, color: coresPrimaria),
                              ),
                            ),
                            Text('148', style: TextStyle(fontSize: 25)),
                            Text(
                              'Total de pacientes',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: corLetras.withOpacity(0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // protocolos em aberto
                      Container(
                        height: 170,
                        width: 115,
                        decoration: BoxDecoration(
                          color: cores.surface.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: corLetras.withOpacity(0.1),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: corSecundaria.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Icon(
                                  Icons.note_add,
                                  color: corSecundaria,
                                ),
                              ),
                            ),
                            Text('34', style: TextStyle(fontSize: 25)),
                            Text(
                              'Protocolos   em Aberto',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: corLetras.withOpacity(0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                      //relatorios gerados
                      Container(
                        height: 170,
                        width: 115,
                        decoration: BoxDecoration(
                          color: cores.surface.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: corLetras.withOpacity(0.1),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: corTerciaria.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Icon(
                                  Icons.bar_chart,
                                  color: corTerciaria,
                                ),
                              ),
                            ),
                            Text('92', style: TextStyle(fontSize: 25)),
                            Text(
                              'Relatórios gerados',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: corLetras.withOpacity(0.4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            //ações rapidas
            Container(
              width: 350,
              height: 330,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ações rapidas',
                    style: TextStyle(
                      fontSize: 20,
                      color: corLetras.withOpacity(0.6),
                    ),
                  ),
                  SizedBox(height: 10),
                  // cadastrar novo terapeuta
                  BotaoAcoesRapidas(
                    titulo: 'Cadastrar novo terapeuta',
                    subtitulo: 'Adicionar profissional ao sistema',
                    icone: Icon(Icons.person_add, color: cores.onPrimary),
                    corFundo: coresPrimaria,
                    corLetra: cores.onPrimary,
                    onTap: () {
                      print('Navegar pra tela de cadastrar novo terapeuta');
                    },
                  ),
                  // gerenciar pacientes
                  BotaoAcoesRapidas(
                    titulo: 'Gerenciar Pacientes',
                    subtitulo: 'Editar e organizar pacientes',
                    icone: Icon(Icons.groups, color: corTerciaria),
                    corFundo: corFundo,
                    corLetra: corLetras,
                    onTap: () {
                      print('ir pra tela de gerenciar pacietes');
                    },
                  ),
                  // configurações do sistema
                  BotaoAcoesRapidas(
                    titulo: 'Configurações do sistema',
                    subtitulo: 'Preferências e permissões',
                    icone: Icon(Icons.settings, color: coresPrimaria),
                    corFundo: corFundo,
                    corLetra: corLetras,
                    onTap: () {
                      print('ir pra configurações do sistema');
                    },
                  ),
                ],
              ),
            ),
            //relatorios recentes
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('RELATÓRIOS RECENTES'),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          print('ir pra pagina de ver todos os relatorios');
                        },
                        child: Text(
                          'Ver todos',
                          style: TextStyle(color: coresPrimaria),
                        ),
                      ),
                    ],
                  ),
                  CartaoRelatorio(
                    titulo: 'Relatório Mensal - Maio 2025',
                    status: 'Concluído',
                    data: DateTime(25, 07, 08),
                    nomeTerapeuta: 'Dr. Marcos Souza',
                  ),
                  CartaoRelatorio(
                    titulo: 'Relatório Mensal - Maio 2025',
                    status: 'Em progresso',
                    data: DateTime(25, 07, 08),
                    nomeTerapeuta: 'Dr. Pedro Alves',
                  ),
                  CartaoRelatorio(
                    titulo: 'Relatório Mensal - Maio 2025',
                    status: 'Concluído',
                    data: DateTime(25, 07, 8),
                    nomeTerapeuta: 'Dra. Ana Lima',
                  ),
                ],
              ),
            ),
            //gestao de alunos
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Gestão de alunos'),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          print('ir pra pagina de ver todos os relatorios');
                        },
                        child: Text(
                          'Ver todos',
                          style: TextStyle(color: coresPrimaria),
                        ),
                      ),
                    ],
                  ),
                  CartaoAluno(nome: 'Ana Souza', numPacientes: 4),
                  CartaoAluno(nome: 'Carlos Mendes', numPacientes: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
