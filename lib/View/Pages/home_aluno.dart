import 'package:espectrum_front/View/Pages/selecao_paciente.dart';
import 'package:espectrum_front/View/Pages/tela_cadastro_professor.dart';
import 'package:espectrum_front/View/Pages/tela_vincular_professor.dart';
import 'package:espectrum_front/View/Widgets/botao_grande.dart';
import 'package:espectrum_front/View/Widgets/cabecalho_padrao.dart';
import 'package:flutter/material.dart';

import '../Widgets/drawer_padrao.dart';
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

  @override
  void initState() {
    super.initState();
    _carregarPacientes();
  }

  // 🟢 MÉTODO ATUALIZADO PARA USAR O VINCULO SERVICE
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 64,
              width: 64,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: cores.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.asset(
                "assets/Images/Logo.png",
                fit: BoxFit.fitWidth,
              ),
            ),

            // boas vindas
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 343),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 5),
                    Text(
                      'Bem vindo ao Espectrum Savvy!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: cores.onSurface,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Nosso App tem como intuito ajudar no preenchimento e realização do protocolo Socially Savvy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                        color: cores.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // card de duvidas
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 343),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: cores.onPrimary.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(Icons.info, color: cores.tertiary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Dúvidas quanto ao protocolo?',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w100,
                                color: cores.tertiary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 301),
                        child: Container(
                          width: double.infinity,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [cores.tertiary, cores.secondary],
                            ),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () => print('Botão pressionado!'),
                            child: const Text(
                              "Informações",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),
            Text(
              'Que bom ter você de volta!', // Dá pra puxar o nome do terapeuta aqui depois!
              style: TextStyle(fontSize: 25, color: cores.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),

            // card de progresso (Agora dinâmico com a quantidade de pacientes)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 343),
              child: Container(
                width: double.infinity,
                height: 96,
                decoration: BoxDecoration(
                  color: cores.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        _isLoading
                            ? 'Carregando protocolos...'
                            : 'Você tem ${_pacientes.length} protocolos disponíveis',
                        style: TextStyle(color: cores.onPrimary),
                      ),
                      const SizedBox(height: 20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          height: 12,
                          child: LinearProgressIndicator(
                            backgroundColor: cores.onPrimary.withOpacity(0.3),
                            value: _isLoading
                                ? null
                                : (_pacientes.isNotEmpty
                                      ? 1.0
                                      : 0.0), // Fica animado enquanto carrega
                            valueColor: AlwaysStoppedAnimation<Color>(
                              cores.secondary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            BotaoGrande(
              texto: "Iniciar Protocolo",
              caminho: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SelecaoPaciente(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            BotaoGrande(
              texto: "Cadastrar professor",
              caminho: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CadastroProfessor(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            BotaoGrande(
              texto: "Vincular professor a paciente",
              caminho: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TelaVincularProfessor(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
