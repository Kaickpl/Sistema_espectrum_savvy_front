import 'package:espectrum_front/Model/ApiExceptionModel.dart';
import 'package:espectrum_front/Model/Enum/GrauAutismo.dart';
import 'package:espectrum_front/Model/PacienteResumoModel.dart';
import 'package:espectrum_front/Services/ProtocoloService.dart';
import 'package:espectrum_front/Services/TokenStorage.dart';
import 'package:espectrum_front/Services/VinculoService.dart';
import 'package:espectrum_front/View/Pages/pagina_protocolo.dart';
import 'package:espectrum_front/View/Pages/tela_cadastro_paciente.dart';
import 'package:espectrum_front/View/Widgets/botao_personalizado_filtro.dart';
import 'package:espectrum_front/View/Widgets/cabecalho_padrao.dart';
import 'package:espectrum_front/View/Widgets/cartao_paciente_home.dart';
import 'package:espectrum_front/View/Widgets/drawer_padrao.dart';
import 'package:flutter/material.dart';

class SelecaoPaciente extends StatefulWidget {
  const SelecaoPaciente({super.key});

  @override
  State<SelecaoPaciente> createState() => _SelecaoPacienteState();
}

class _SelecaoPacienteState extends State<SelecaoPaciente> {
  final TextEditingController meuController = TextEditingController();
  int? nivelSelecionado;
  final naoIniciadoCor = const Color.fromARGB(255, 216, 71, 71);
  final emAndamentoCor = Colors.orange;

  bool _carregando = true;
  String? _erro;
  List<PacienteResumoModel> _pacientes = [];
  List<PacienteResumoModel> pacientesFiltrados = [];
  Map<String, String> _statusPorPaciente = {};

  @override
  void initState() {
    super.initState();
    _carregarPacientes();
  }

  Future<void> _carregarPacientes() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final token = await TokenStorage.lerToken();
      final pacientes = await VinculoService.listarMeusPacientesVinculados(
        token ?? '',
      );
      if (!mounted) return;
      setState(() {
        _pacientes = pacientes;
        pacientesFiltrados = pacientes;
      });
      _carregarStatusDosPacientes(pacientes);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _erro = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(
        () => _erro = "Não foi possível carregar os pacientes vinculados.",
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _carregarStatusDosPacientes(
    List<PacienteResumoModel> pacientes,
  ) async {
    for (final paciente in pacientes) {
      try {
        final status = await ProtocoloService.buscarStatusProtocolo(
          paciente.id,
        );
        if (!mounted) return;
        setState(() {
          _statusPorPaciente[paciente.id] = status;
        });
      } catch (_) {
        // Se falhar para um paciente específico, mantém o status como "Não iniciado".
      }
    }
  }

  void filtrarListaPorNome(String pesquisa) {
    setState(() {
      pacientesFiltrados = _aplicarFiltros(nome: pesquisa);
    });
  }

  void filtrarListaPorNivel(int? nivel) {
    setState(() {
      nivelSelecionado = nivel;
      pacientesFiltrados = _aplicarFiltros(
        nome: meuController.text,
        nivel: nivel,
      );
    });
  }

  List<PacienteResumoModel> _aplicarFiltros({String nome = '', int? nivel}) {
    return _pacientes.where((paciente) {
      final correspondeNome = paciente.nome.toLowerCase().contains(
        nome.toLowerCase(),
      );
      final correspondeNivel =
          nivel == null || _nivel(paciente.grauAutismo) == nivel;
      return correspondeNome && correspondeNivel;
    }).toList();
  }

  int _nivel(GrauAutismo grauAutismo) {
    switch (grauAutismo) {
      case GrauAutismo.nivel1:
        return 1;
      case GrauAutismo.nivel2:
        return 2;
      case GrauAutismo.nivel3:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;

    return Scaffold(
      appBar: CabecalhoPadrao(titulo: 'Seleção de paciente'),
      endDrawer: const DrawerPadrao(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              controller: meuController,
              decoration: InputDecoration(
                hintText: "Buscar paciente por nome...",
                filled: true,
                fillColor: cores.onPrimary.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: cores.onSurface.withOpacity(0.5),
                ),
                suffixIcon: meuController.text.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          meuController.clear();
                          filtrarListaPorNome("");
                        },
                      ),
              ),
              onChanged: filtrarListaPorNome,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(width: 10),
                BotaoPersonalizadoFiltro(
                  onPressed: () => filtrarListaPorNivel(null),
                  texto: 'Todos',
                  corFundo: nivelSelecionado == null
                      ? cores.primary
                      : cores.onPrimary.withOpacity(0.3),
                  corLetra: nivelSelecionado == null
                      ? cores.onPrimary
                      : cores.onSurface.withOpacity(0.5),
                ),
                const SizedBox(width: 10),
                BotaoPersonalizadoFiltro(
                  onPressed: () => filtrarListaPorNivel(1),
                  texto: 'Nível 1',
                  corFundo: nivelSelecionado == 1
                      ? cores.primary
                      : cores.onPrimary.withOpacity(0.3),
                  corLetra: nivelSelecionado == 1
                      ? cores.onPrimary
                      : cores.onSurface.withOpacity(0.5),
                ),
                const SizedBox(width: 10),
                BotaoPersonalizadoFiltro(
                  onPressed: () => filtrarListaPorNivel(2),
                  texto: 'Nível 2',
                  corFundo: nivelSelecionado == 2
                      ? cores.primary
                      : cores.onPrimary.withOpacity(0.3),
                  corLetra: nivelSelecionado == 2
                      ? cores.onPrimary
                      : cores.onSurface.withOpacity(0.5),
                ),
                const SizedBox(width: 10),
                BotaoPersonalizadoFiltro(
                  onPressed: () => filtrarListaPorNivel(3),
                  texto: 'Nível 3',
                  corFundo: nivelSelecionado == 3
                      ? cores.primary
                      : cores.onPrimary.withOpacity(0.3),
                  corLetra: nivelSelecionado == 3
                      ? cores.onPrimary
                      : cores.onSurface.withOpacity(0.5),
                ),
                const SizedBox(width: 10),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: cores.primary,
                foregroundColor: cores.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CadastroPaciente(),
                ),
              ),
              child: const Text('Adicionar Paciente'),
            ),
          ),
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator())
                : _erro != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(_erro!, style: TextStyle(color: cores.error)),
                    ),
                  )
                : pacientesFiltrados.isEmpty
                ? Center(
                    child: Text(
                      "Nenhum paciente vinculado encontrado.",
                      style: TextStyle(color: cores.onSurface.withOpacity(0.6)),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(8),
                    itemCount: pacientesFiltrados.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final p = pacientesFiltrados[index];
                      final statusProtocolo = _statusPorPaciente[p.id];
                      final emAndamento = statusProtocolo == 'EM_ANDAMENTO';
                      return CartaoPacienteHome(
                        nomePaciente: p.nome,
                        nivel: _nivel(p.grauAutismo),
                        idade: p.idade ?? 0,
                        status: emAndamento ? 'Em andamento' : 'Não iniciado',
                        corStatus: emAndamento
                            ? emAndamentoCor
                            : naoIniciadoCor,
                        textoBotaoPrincipal: emAndamento
                            ? 'Continuar'
                            : 'Iniciar',
                        onContinuar: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaginaProtocolo(
                                pacienteId: p.id,
                                nomePaciente: p.nome,
                              ),
                            ),
                          );
                        },
                        onHistorico: () {},
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
