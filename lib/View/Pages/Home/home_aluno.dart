import 'package:espectrum_front/View/Pages/Protocol/selecao_paciente.dart';
import 'package:espectrum_front/View/Pages/Auth/tela_cadastro_professor.dart';
import 'package:espectrum_front/View/Pages/manager/tela_vincular_professor.dart';
import 'package:espectrum_front/View/Widgets/cabecalho_padrao.dart';
import 'package:espectrum_front/View/Widgets/cartao_acao_home.dart';
import 'package:flutter/material.dart';

import '../../Widgets/drawer_padrao.dart';
import 'package:espectrum_front/Services/VinculoService.dart';
import 'package:espectrum_front/Model/PacienteResumoModel.dart';
import 'package:espectrum_front/Services/TokenStorage.dart';

class HomeAluno extends StatefulWidget {
  const HomeAluno({super.key});

  @override
  State<HomeAluno> createState() => _HomeAlunoState();
}

class _HomeAlunoState extends State<HomeAluno> {
  List<PacienteResumoModel> _pacientes = [];
  bool _isLoading = true;
  String? _nomeUsuario;

  @override
  void initState() {
    super.initState();
    _carregarPacientes();
    _carregarNomeUsuario();
  }

  Future<void> _carregarNomeUsuario() async {
    final nome = await TokenStorage.lerNome();
    if (mounted) {
      setState(() {
        _nomeUsuario = nome;
      });
    }
  }

  String get _saudacao {
    final hora = DateTime.now().hour;
    if (hora < 12) return 'Bom dia';
    if (hora < 18) return 'Boa tarde';
    return 'Boa noite';
  }

  Future<void> _carregarPacientes() async {
    try {
      // 1. Pega o token salvo no celular
      final token = await TokenStorage.lerToken();

      if (token == null) {
        throw Exception("Sessão expirada. Por favor, faça login novamente.");
      }

      // 2. Chama o seu serviço novo
      final pacientesData = await VinculoService.listarMeusPacientesVinculados(
        token,
      );

      if (mounted) {
        setState(() {
          _pacientes = pacientesData;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;

    return Scaffold(
      backgroundColor: tema.scaffoldBackgroundColor,
      appBar: CabecalhoPadrao(titulo: 'Socially Savvy'),
      endDrawer: DrawerPadrao(),
      body: RefreshIndicator(
        onRefresh: _carregarPacientes,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    _nomeUsuario != null && _nomeUsuario!.isNotEmpty
                        ? '$_saudacao, $_nomeUsuario!'
                        : 'Que bom ter você de volta!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: cores.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Preencha e realize o protocolo Socially Savvy.',
                    style: TextStyle(
                      fontSize: 13,
                      color: cores.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 14),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: cores.surfaceContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.groups_rounded,
                            size: 15,
                            color: cores.onSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _isLoading
                                ? 'Carregando...'
                                : '${_pacientes.length} ${_pacientes.length == 1 ? "paciente vinculado" : "pacientes vinculados"}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: cores.onSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Text(
                    'O que você deseja fazer?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: cores.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),

                  CartaoAcaoHome(
                    icone: Icons.play_circle_fill_rounded,
                    titulo: "Iniciar Protocolo",
                    subtitulo: "Escolha um paciente e comece uma sessão",
                    destaque: true,
                    aoTocar: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SelecaoPaciente(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CartaoAcaoHome(
                    icone: Icons.person_add_alt_1_rounded,
                    titulo: "Cadastrar professor",
                    subtitulo: "Adicione um novo professor ao sistema",
                    aoTocar: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CadastroProfessor(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  CartaoAcaoHome(
                    icone: Icons.link_rounded,
                    titulo: "Vincular professor a paciente",
                    subtitulo: "Conecte um professor a um paciente",
                    aoTocar: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TelaVincularProfessor(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Central de dúvidas em breve por aqui.',
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: cores.onSurface.withOpacity(0.3),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.help_outline_rounded,
                            size: 18,
                            color: cores.tertiary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Dúvidas quanto ao protocolo?',
                              style: TextStyle(
                                fontSize: 12.5,
                                color: cores.onSurface,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 13,
                            color: cores.onSurface.withOpacity(0.4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
