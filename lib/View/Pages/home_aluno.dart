import 'package:espectrum_front/View/Pages/selecao_paciente.dart';
import 'package:espectrum_front/View/Pages/tela_cadastro_professor.dart';
import 'package:espectrum_front/View/Pages/tela_vincular_professor.dart';
import 'package:espectrum_front/View/Widgets/botao_grande.dart';
import 'package:espectrum_front/View/Widgets/cabecalho_padrao.dart';
import 'package:espectrum_front/View/Widgets/cartao_paciente_home.dart';
import 'package:flutter/material.dart';
import 'package:espectrum_front/View/Pages/pagina_protocolo.dart';

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
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _carregarPacientes();
  }

  Future<void> _carregarPacientes() async {
    try {
      // 1. Pega o token salvo no celular
      final token = await TokenStorage.lerToken();
      
      if (token == null) {
        throw Exception("Sessão expirada. Por favor, faça login novamente.");
      }

      // 2. Chama o seu serviço novo
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
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    final emProgressoCor = Colors.orange;
    final aguardandoCor = Colors.blue;

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
            SizedBox(
              height: 193,
              width: 343,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    'Bem vindo ao Espectrum Savvy!',
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

            // card de duvidas
            Container(
              height: 145,
              width: 343,
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
                  Container(
                    width: 301,
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
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
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
            Container(
              height: 96,
              width: 343,
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
                        ? 'Carregando testes...' 
                        : 'Você tem ${_pacientes.length} testes disponíveis',
                      style: TextStyle(color: cores.onPrimary),
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: 12,
                        child: LinearProgressIndicator(
                          backgroundColor: cores.onPrimary.withOpacity(0.3),
                          value: _isLoading ? null : (_pacientes.isNotEmpty ? 1.0 : 0.0), // Fica animado enquanto carrega
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

            const SizedBox(height: 20),

            Container(
              height: 70,
              width: 343,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Icon(Icons.info, color: cores.primary),
                  const SizedBox(width: 10),
                  Text(
                    'Seus Pacientes:',
                    style: TextStyle(color: cores.onSurface),
                  ),
                ],
              ),
            ),


            if (_isLoading)
              const CircularProgressIndicator()
            else if (_errorMessage != null)
              Text("Erro ao carregar pacientes: $_errorMessage", style: const TextStyle(color: Colors.red))
            else if (_pacientes.isEmpty)
              const Text("Você ainda não tem pacientes vinculados.", style: TextStyle(color: Colors.grey))
            else
              ..._pacientes.map((paciente) {
                final String id = paciente.id;
                final String nome = paciente.nome;
                
                // Mapeando dados do JSON pro seu CartaoPacienteHome
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: CartaoPacienteHome(
                    nomePaciente: nome,
                    data: DateTime.now(), // Temporário, o ideal é vir do banco
                    nivel: 1, // Temporário (ou ler de paciente.grauAutismo se existir no DTO)
                    idade: 5, // Temporário
                    status: 'Aguardando', // Pode virar dinâmico depois
                    corStatus: aguardandoCor,
                    onContinuar: () {
                      // 🟢 NAVEGA PARA O PROTOCOLO DESSE PACIENTE!
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaginaProtocolo(
                            pacienteId: id,
                            nomePaciente: nome,
                          ),
                        ),
                      );
                    },
                    onHistorico: () => print('Acessando Histórico do paciente: $nome'),
                  ),
                );
              }),

            const SizedBox(height: 20),
            
            // 🟢 OS SEUS BOTÕES ORIGINAIS CONTINUAM AQUI EMBAIXO INTACTOS
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