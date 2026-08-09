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
        child: RefreshIndicator(
          onRefresh: _carregarPacientes,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      InfoHomeProfessorEResponsavel(nomePerfil: "Responsável"),

                      const SizedBox(height: 20),

                      if (_isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (_errorMessage != null)
                        Text(
                          "Erro ao carregar pacientes: $_errorMessage",
                          style: const TextStyle(color: Colors.red),
                        )
                      else if (_pacientes.isEmpty)
                        const Text(
                          "Você ainda não tem pacientes vinculados.",
                          style: TextStyle(color: Colors.grey),
                        )
                      else
                        ..._pacientes.map((paciente) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: CartaoPacienteHome(
                              nomePaciente: paciente.nome,
                              nivel: 3,
                              idade: 5,
                              status: "Em Progresso",
                              corStatus: CoresPadrao.emProgressoCor,
                              onContinuar: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaginaProtocolo(
                                      pacienteId: paciente.id,
                                      nomePaciente: paciente.nome,
                                    ),
                                  ),
                                );
                              },
                              onHistorico: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaginaProtocolo(
                                      pacienteId: paciente.id,
                                      nomePaciente: paciente.nome,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(17),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
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
        ),
      ),
    );
  }
}
