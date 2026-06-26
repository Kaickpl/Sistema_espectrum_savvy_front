import 'package:espectrum_front/Model/ApiExceptionModel.dart';
import 'package:espectrum_front/Model/Enum/GrauAutismo.dart';
import 'package:espectrum_front/Model/PacienteResumoModel.dart';
import 'package:espectrum_front/Services/TokenStorage.dart';
import 'package:espectrum_front/Services/VinculoService.dart';
import 'package:espectrum_front/View/Pages/tela_cadastro_paciente.dart';
import 'package:espectrum_front/View/Widgets/botao_personalizado_filtro.dart';
import 'package:espectrum_front/View/Widgets/cabecalho_padrao.dart';
import 'package:espectrum_front/View/Widgets/cartao_paciente_home.dart';
import 'package:flutter/material.dart';

import '../Widgets/drawer_padrao.dart';

/// Tela de seleção de paciente para iniciar o protocolo.
/// Lista os pacientes já vinculados ao terapeuta logado; a aplicação do
/// protocolo em si (progresso, avaliações, atividades) é tratada nas
/// telas de protocolo, não aqui.
class SelecaoPaciente extends StatefulWidget {
  const SelecaoPaciente({super.key});

  @override
  State<SelecaoPaciente> createState() => _SelecaoPacienteState();
}

class _SelecaoPacienteState extends State<SelecaoPaciente> {
  final TextEditingController meuController = TextEditingController();
  int? nivelSelecionado;
  final naoIniciadoCor = const Color.fromARGB(255, 216, 71, 71);

  bool _carregando = true;
  String? _erro;
  List<PacienteResumoModel> _pacientes = [];
  List<PacienteResumoModel> pacientesFiltrados = [];

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
      endDrawer: DrawerPadrao(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // barra de pesquisa
          TextFormField(
            controller: meuController,
            decoration: InputDecoration(
              hintText: "Buscar paciente por nome...",
              hintStyle: TextStyle(color: cores.onSurface.withOpacity(0.5)),
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
                      icon: Icon(Icons.clear),
                      color: cores.onSurface.withOpacity(0.5),
                      onPressed: () {
                        meuController.clear();
                        filtrarListaPorNome("");
                      },
                    ),
            ),
            onChanged: (value) {
              filtrarListaPorNome(value);
              setState(() {});
            },
          ),
          SizedBox(height: 20),
          // filtro
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  BotaoPersonalizadoFiltro(
                    onPressed: () => filtrarListaPorNivel(null),
                    corFundo: nivelSelecionado == null
                        ? cores.primary
                        : cores.onPrimary.withOpacity(0.3),
                    corLetra: nivelSelecionado == null
                        ? cores.onPrimary
                        : cores.onSurface.withOpacity(0.5),
                    texto: 'Todos',
                  ),
                  SizedBox(width: 10),
                  BotaoPersonalizadoFiltro(
                    onPressed: () => filtrarListaPorNivel(1),
                    corFundo: nivelSelecionado == 1
                        ? cores.primary
                        : cores.onPrimary.withOpacity(0.3),
                    corLetra: nivelSelecionado == 1
                        ? cores.onPrimary
                        : cores.onSurface.withOpacity(0.5),
                    texto: 'Nível 1 (Suporte leve)',
                  ),
                  SizedBox(width: 10),
                  BotaoPersonalizadoFiltro(
                    onPressed: () => filtrarListaPorNivel(2),
                    corFundo: nivelSelecionado == 2
                        ? cores.primary
                        : cores.onPrimary.withOpacity(0.3),
                    corLetra: nivelSelecionado == 2
                        ? cores.onPrimary
                        : cores.onSurface.withOpacity(0.5),
                    texto: 'Nível 2 (Suporte moderado)',
                  ),
                  SizedBox(width: 10),
                  BotaoPersonalizadoFiltro(
                    onPressed: () => filtrarListaPorNivel(3),
                    corFundo: nivelSelecionado == 3
                        ? cores.primary
                        : cores.onPrimary.withOpacity(0.3),
                    corLetra: nivelSelecionado == 3
                        ? cores.onPrimary
                        : cores.onSurface.withOpacity(0.5),
                    texto: 'Nível 3 (Muito Suporte)',
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 65,
              width: 375,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: cores.primary,
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CadastroPaciente(),
                    ),
                  );
                },
                child: Text(
                  'Adicionar Paciente',
                  style: TextStyle(fontSize: 19, color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: _carregando
                ? const Center(child: CircularProgressIndicator())
                : _erro != null
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        _erro!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: cores.error),
                      ),
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
                    itemBuilder: (context, index) {
                      final pacienteAtual = pacientesFiltrados[index];
                      return CartaoPacienteHome(
                        nomePaciente: pacienteAtual.nome,
                        nivel: _nivel(pacienteAtual.grauAutismo),
                        idade: pacienteAtual.idade ?? 0,
                        status: 'Não iniciado',
                        corStatus: naoIniciadoCor,
                        textoBotaoPrincipal: 'Iniciar',
                        onContinuar: () {},
                        onHistorico: () {},
                      );
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemCount: pacientesFiltrados.length,
                  ),
          ),
        ],
      ),
    );
  }
}
