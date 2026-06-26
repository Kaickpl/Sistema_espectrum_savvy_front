import 'package:espectrum_front/Config/coresPadrao.dart';
import 'package:espectrum_front/View/Pages/pagina_protocolo.dart';
import 'package:espectrum_front/View/Widgets/botao_grande.dart';
import 'package:espectrum_front/View/Widgets/cabecalho_padrao.dart';
import 'package:espectrum_front/View/Widgets/cartao_paciente_home.dart';
import 'package:espectrum_front/View/Widgets/drawer_padrao.dart';
import 'package:espectrum_front/View/Widgets/info_home_professor_e_responsavel.dart';
import 'package:espectrum_front/View/Widgets/logo_container.dart';
import 'package:flutter/material.dart';

// 🟢 NOVOS IMPORTS DA API
import 'package:espectrum_front/Services/VinculoService.dart';
import 'package:espectrum_front/Model/PacienteResumoModel.dart';
import 'package:espectrum_front/Services/TokenStorage.dart';

class HomeResponsavel extends StatefulWidget {
  const HomeResponsavel({super.key});

  @override
  State<HomeResponsavel> createState() => _HomeResponsavelState();
}

class _HomeResponsavelState extends State<HomeResponsavel> {
  // 🟢 Lógica de Estado para os Pacientes
  List<PacienteResumoModel> _pacientes = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _carregarPacientes();
  }

  // 🟢 Método que busca os pacientes reais do banco
  Future<void> _carregarPacientes() async {
    try {
      final token = await TokenStorage.lerToken();
      if (token == null) {
        throw Exception("Sessão expirada. Por favor, faça login novamente.");
      }

      // O VinculoService já está configurado para buscar os pacientes do usuário logado!
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
                InfoHomeProfessorEResponsavel(nomePerfil: "Responsável"),

                const SizedBox(height: 20),

<<<<<<< HEAD
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
                      child: CartaoPacienteHome(
                        nomePaciente: paciente.nome,
                        data: DateTime.now(), // Temporário (ou pega do DTO)
                        nivel: 1, // Temporário
                        idade: 5, // Temporário
                        status: "Em Progresso", // Temporário
                        corStatus: CoresPadrao.emProgressoCor,
                        onContinuar: () {
                          // 🟢 Clicar em "Continuar" leva para o Protocolo com o ID e Nome certos!
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
                          // Aqui irá a navegação para a tela de histórico no futuro
                          print('Acessando Histórico do paciente: ${paciente.nome}');
                        },
                      ),
                    );
                  }).toList(),
=======
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
>>>>>>> 1ce997520104cb49eac07116398eb9efb2cdf111
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
            // Como este é o botão genérico no final da tela e ele precisa do ID do paciente,
            // colocamos um aviso para clicar no cartão do paciente acima!
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Por favor, clique em "Continuar" no cartão do paciente acima para iniciar o protocolo!')),
            );
          },
        ),
      ),
    );
  }
}