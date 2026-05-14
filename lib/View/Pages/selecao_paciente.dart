import 'package:espectrum_front/View/Widgets/botao_personalizado_filtro.dart';
import 'package:espectrum_front/View/Widgets/cabecalho_padrao.dart';
import 'package:espectrum_front/View/Widgets/cartao_paciente_home.dart';
import 'package:flutter/material.dart';

class SelecaoPaciente extends StatefulWidget {
  const SelecaoPaciente({super.key});

  @override
  State<SelecaoPaciente> createState() => _SelecaoPacienteState();
}

class _SelecaoPacienteState extends State<SelecaoPaciente> {
  final TextEditingController meuController = TextEditingController();
  int? nivelSelecionado;
  final concluidoCor = const Color.fromARGB(255, 37, 163, 41);
  final emProgressoCor = const Color.fromARGB(255, 216, 163, 71);
  final naoIniciadoCor = const Color.fromARGB(255, 216, 71, 71);
  final List<Map<String, dynamic>> dadosPacientes = [
    {
      'nome': 'Lucas Martins',
      'data': DateTime(2026, 4, 21),
      'nivel': 2,
      'idade': 3,
      'status': 'Em progresso',
    },
    {
      'nome': 'Sofia Almeida',
      'data': DateTime(2026, 8, 12),
      'nivel': 3,
      'idade': 1,
      'status': 'Concluído',
    },
    {
      'nome': 'João Silva',
      'data': DateTime(2026, 5, 10),
      'nivel': 1,
      'idade': 5,
      'status': 'Não iniciado',
    },
  ];

  List<Map<String, dynamic>> pacientesFiltrados = [];

  @override
  void initState() {
    super.initState();
    pacientesFiltrados = dadosPacientes;
  }

  void filtrarListaPorNome(String pesquisa) {
    setState(() {
      pacientesFiltrados = dadosPacientes
          .where(
            (paciente) =>
                paciente['nome'].toLowerCase().contains(pesquisa.toLowerCase()),
          )
          .toList();
    });
  }

  void filtrarListaPorNivel(int? nivel) {
    setState(() {
      nivelSelecionado = nivel;
      if (nivel == null) {
        pacientesFiltrados = dadosPacientes;
      } else {
        pacientesFiltrados = dadosPacientes
            .where((paciente) => paciente['nivel'] == nivel)
            .toList();
      }
    });
  }

  Color definirCorStatus(String status) {
    if (status == 'Concluído') {
      return concluidoCor;
    }
    if (status == 'Em progresso') {
      return emProgressoCor;
    }
    return naoIniciadoCor;
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;

    return Scaffold(
      appBar: CabecalhoPadrao(titulo: 'Seleção de paciente'),
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
                  print('Botão pressionada!');
                },
                child: Text(
                  'Adicionar Paciente',
                  style: TextStyle(fontSize: 19, color: Colors.white),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                final pacienteAtual = pacientesFiltrados[index];
                return CartaoPacienteHome(
                  nomePaciente: pacienteAtual['nome'],
                  data: pacienteAtual['data'],
                  nivel: pacienteAtual['nivel'],
                  idade: pacienteAtual['idade'],
                  status: pacienteAtual['status'],
                  corStatus: definirCorStatus(pacienteAtual['status']),
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
