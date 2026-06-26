import 'package:espectrum_front/Config/coresPadrao.dart';
import 'package:espectrum_front/View/Widgets/botao_grande.dart';
import 'package:espectrum_front/View/Widgets/cabecalho_padrao.dart';
import 'package:espectrum_front/View/Widgets/cartao_paciente_sem_historico.dart';
import 'package:espectrum_front/View/Widgets/drawer_padrao.dart';
import 'package:espectrum_front/View/Widgets/info_home_professor_e_responsavel.dart';
import 'package:flutter/material.dart';
import 'package:espectrum_front/View/Pages/pagina_protocolo.dart';

import 'package:espectrum_front/Services/VinculoService.dart';
import 'package:espectrum_front/Model/PacienteResumoModel.dart';
import 'package:espectrum_front/Services/TokenStorage.dart';


class HomeProfessor extends StatefulWidget {
  const HomeProfessor({super.key});

  @override
  State<HomeProfessor> createState() => _HomeProfessorState();
}

class _HomeProfessorState extends State<HomeProfessor> {
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

      final pacientesData = await VinculoService.listarMeusPacientesVinculados(token);
      
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
                InfoHomeProfessorEResponsavel(nomePerfil: "Professor"),

                const SizedBox(height: 20),

                // 🟢 LÓGICA DE EXIBIÇÃO DINÂMICA
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_errorMessage != null)
                  Text("Erro ao carregar pacientes: $_errorMessage", style: const TextStyle(color: Colors.red))
                else if (_pacientes.isEmpty)
                  const Text("Você ainda não tem pacientes vinculados.", style: TextStyle(color: Colors.grey))
                else
                  // Espalha a lista dinâmica de Cartões
                  ..._pacientes.map((paciente) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () {
                          // 🟢 Clicar no cartão leva para o Protocolo com o ID e Nome certos!
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
                        child: CartaoPacienteHomeSemHistorico(
                          nomePaciente: paciente.nome,
                          data: DateTime.now(), // Temporário (ou pega do DTO)
                          idade: 5, // Temporário
                          status: "Em Progresso", // Temporário
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
                          }
                        ),
                      ),
                    );
                  }).toList(),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: BotaoGrande(
          texto: "Iniciar Protocolo",
          caminho: () {
            // 🟢 AQUI ESTAVA A DAR ERRO! 
            // A PaginaProtocolo precisa de pacienteId. 
            // O ideal para este botão genérico é ir para a tela de Seleção de Paciente:
            
            /* Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => const SelecaoPaciente()),
            ); */
            
            // Se não tiveres a tela de seleção pronta, podes mostrar um alerta temporário:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Por favor, clique no cartão de um paciente acima para iniciar o protocolo!')),
            );
          },
        ),
      ),
    );
  }
}