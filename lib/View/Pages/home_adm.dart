import 'package:espectrum_front/View/Pages/tela_cadastro_estagiario.dart';
import 'package:espectrum_front/View/Pages/tela_cadastro_professor.dart';
import 'package:espectrum_front/View/Pages/tela_vincular_pacientes.dart';
import 'package:espectrum_front/View/Widgets/cartao_acoes_rapidas.dart';
import 'package:espectrum_front/View/Widgets/cartao_aluno.dart';
import 'package:espectrum_front/View/Widgets/cartao_relatorio.dart';
import 'package:flutter/material.dart';
import '../Widgets/drawer_padrao.dart';

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
    final corFundo = tema.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        backgroundColor: corFundo,
        elevation: 0,
        foregroundColor: cores.onSurface,
        actions: const [],
      ),
      endDrawer: DrawerPadrao(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bem-vindo de volta',
                    style: TextStyle(
                      color: cores.onSurface.withOpacity(0.5),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Painel administrativo',
                    style: tema.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: cores.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _buildSectionTitle(cores, 'Resumo Geral'),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.68,
              children: [
                _buildCardInformativo(
                  context,
                  titulo: '148',
                  subtitulo: 'Total de pacientes',
                  icone: Icons.group,
                  corIcone: cores.primary,
                ),
                _buildCardInformativo(
                  context,
                  titulo: '34',
                  subtitulo: 'Protocolos em Aberto',
                  icone: Icons.note_add,
                  corIcone: cores.secondary,
                ),
                _buildCardInformativo(
                  context,
                  titulo: '92',
                  subtitulo: 'Relatórios gerados',
                  icone: Icons.bar_chart,
                  corIcone: cores.tertiary,
                ),
              ],
            ),

            const SizedBox(height: 28),

            _buildSectionTitle(cores, 'Ações rápidas'),
            const SizedBox(height: 12),
            Column(
              children: [
                BotaoAcoesRapidas(
                  titulo: 'Cadastrar novo terapeuta',
                  subtitulo: 'Adicionar profissional ao sistema',
                  icone: Icon(Icons.person_add, color: cores.onPrimary),
                  corFundo: cores.primary,
                  corLetra: cores.onPrimary,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CadastroEstagiario(modoAdmin: true),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                BotaoAcoesRapidas(
                  titulo: 'Cadastrar novo professor',
                  subtitulo: 'Adicionar professor ao sistema',
                  icone: Icon(Icons.school, color: cores.onSecondary),
                  corFundo: cores.secondary,
                  corLetra: cores.onSecondary,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CadastroProfessor(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                BotaoAcoesRapidas(
                  titulo: 'Gerenciar Pacientes',
                  subtitulo: 'Editar e organizar pacientes',
                  icone: Icon(Icons.groups, color: cores.onTertiary),
                  corFundo: cores.tertiary,
                  corLetra: cores.onTertiary,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TelaVincularPacientes(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 28),

            _buildSectionHeader(
              cores,
              'RELATÓRIOS RECENTES',
                  () => print('ir pra pagina de ver todos os relatorios'),
            ),
            const SizedBox(height: 8),
            Column(
              children: [
                CartaoRelatorio(
                  titulo: 'Relatório Mensal - Maio 2025',
                  status: 'Concluído',
                  data: DateTime(25, 07, 08),
                  nomeTerapeuta: 'Dr. Marcos Souza',
                ),
                const SizedBox(height: 8),
                CartaoRelatorio(
                  titulo: 'Relatório Mensal - Maio 2025',
                  status: 'Em progresso',
                  data: DateTime(25, 07, 08),
                  nomeTerapeuta: 'Dr. Pedro Alves',
                ),
                const SizedBox(height: 8),
                CartaoRelatorio(
                  titulo: 'Relatório Mensal - Maio 2025',
                  status: 'Concluído',
                  data: DateTime(25, 07, 8),
                  nomeTerapeuta: 'Dra. Ana Lima',
                ),
              ],
            ),

            const SizedBox(height: 28),

            _buildSectionHeader(
              cores,
              'GESTÃO DE ALUNOS',
                  () => print('ir pra pagina de ver todos os alunos'),
            ),
            const SizedBox(height: 8),
            Column(
              children: const [
                CartaoAluno(nome: 'Ana Souza', numPacientes: 4),
                SizedBox(height: 8),
                CartaoAluno(nome: 'Carlos Mendes', numPacientes: 0),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(ColorScheme cores, String titulo) {
    return Text(
      titulo,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: cores.onSurface.withOpacity(0.85),
      ),
    );
  }

  Widget _buildSectionHeader(
      ColorScheme cores,
      String titulo,
      VoidCallback onVerTodos,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          titulo,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.8,
            color: cores.onSurface.withOpacity(0.5),
          ),
        ),
        TextButton(
          onPressed: onVerTodos,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: const Size(0, 0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Ver todos',
            style: TextStyle(
              color: cores.primary,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCardInformativo(
      BuildContext context, {
        required String titulo,
        required String subtitulo,
        required IconData icone,
        required Color corIcone,
      }) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    final isDark = tema.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark
            ? cores.surface.withOpacity(0.5)
            : cores.surfaceContainer.withOpacity(0.18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cores.onSurface.withOpacity(0.06), width: 1),
        boxShadow: [
          BoxShadow(
            color: cores.primary.withOpacity(isDark ? 0.06 : 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: corIcone.withOpacity(0.15),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icone, color: corIcone, size: 22),
          ),
          const SizedBox(height: 10),
          Text(
            titulo,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: cores.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitulo,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: cores.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}
