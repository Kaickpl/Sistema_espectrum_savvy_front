import 'package:espectrum_front/Config/coresPadrao.dart';
import 'package:espectrum_front/View/Pages/pagina_protocolo.dart';
import 'package:espectrum_front/View/Widgets/botao_grande.dart';
import 'package:espectrum_front/View/Widgets/cabecalho_padrao.dart';
import 'package:espectrum_front/View/Widgets/cartao_paciente_home.dart';
import 'package:espectrum_front/View/Widgets/drawer_padrao.dart';
import 'package:espectrum_front/View/Widgets/info_home_professor_e_responsavel.dart';
import 'package:espectrum_front/View/Widgets/logo_container.dart';
import 'package:flutter/material.dart';

import 'package:espectrum_front/Services/VinculoService.dart';
import 'package:espectrum_front/Model/PacienteResumoModel.dart';
import 'package:espectrum_front/Services/TokenStorage.dart';

class HomeResponsavel extends StatefulWidget {
  const HomeResponsavel({super.key});

  @override
  State<HomeResponsavel> createState() => _HomeResponsavelState();
}

class _HomeResponsavelState extends State<HomeResponsavel> {
  List<PacienteResumoModel> _pacientes = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _carregarPacientes();
  }

  Future<void> _carregarPacientes() async {
    try {
      final token = await TokenStorage.lerToken();
      if (token == null) {
        throw Exception("Sessão expirada. Por favor, faça login novamente.");
      }

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
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CabecalhoPadrao(titulo: "Bem vindo ao Socially Savvy"),
      endDrawer: DrawerPadrao(),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InfoHomeProfessorEResponsavel(nomePerfil: "Responsável"),

                const SizedBox(height: 20),

                CartaoPacienteHome(
                  nomePaciente: "João Silva",
                  nivel: 3,
                  idade: 2,
                  status: "Em Progresso",
                  corStatus: CoresPadrao.emProgressoCor,
                  onContinuar: () {
                    print('a');
                  },
                  onHistorico: () {
                    print('a');
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(17),
        child: BotaoGrande(
          texto: "Iniciar Protocolo",
          caminho: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Por favor, clique em "Continuar" no cartão do paciente acima para iniciar o protocolo!',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
