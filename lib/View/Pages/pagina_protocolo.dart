import 'package:espectrum_front/View/Widgets/cabecalho_padrao.dart';
import 'package:espectrum_front/View/Widgets/categoria_protocolo.dart';
import 'package:espectrum_front/View/Widgets/drawer_padrao.dart';
import 'package:flutter/material.dart';
import 'package:espectrum_front/View/Widgets/info_questoes_e_nome_paciente.dart';
import 'package:espectrum_front/Model/Protocolo/ProtocoloSessaoModel.dart';
import 'package:espectrum_front/Services/ProtocoloService.dart';

class PaginaProtocolo extends StatefulWidget {
  const PaginaProtocolo({super.key});

  @override
  State<PaginaProtocolo> createState() => _PaginaProtocoloState();
}

class _PaginaProtocoloState extends State<PaginaProtocolo> {

  ProtocoloSessaoModel? sessaoAtual;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    _carregarSessaoDoBackend();
  }

  Future<void> _carregarSessaoDoBackend() async {
    try {
      final protocoloSessao = await ProtocoloService.iniciarSessao("979e4e2e-b31a-4fa3-a938-cf8e4cc9c1fd");
      setState(() {
        sessaoAtual = protocoloSessao;
        isLoading = false;
      });
    } catch (e) {
      print("Erro ao carregar a sessão do protocolo: $e");
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

  if(sessaoAtual == null) {
      return Scaffold(
        body: Center(
          child: Text("Erro ao encontrar os dados do protocolo."),
        ),
      );
    }


    int totalQuestoes = 0;
    int respondidas = 0;

    for (var categoria in sessaoAtual!.categoriasSessao) {
      totalQuestoes += categoria.atividades.length;
      respondidas += categoria.atividades.where((ativ) => ativ.pontuacao != null).length;
    }

    String nomeDoPacienteAtual = "${sessaoAtual!.pacienteNome ?? "Paciente Desconhecido"}";

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CabecalhoPadrao(titulo: "Protocolo: ${sessaoAtual!.pacienteNome ?? "Paciente Desconhecido"}"),
      endDrawer: DrawerPadrao(),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InfoQuestoesENomePaciente(
                  nomePaciente: nomeDoPacienteAtual,
                  questoesRespondidas: respondidas,
                  totalDeQuestoes: totalQuestoes,
                  iconePrincipal: Icons.assignment,
                  tituloPrincipal: "Protocolo de Atendimento",
                  subtitulo:
                      "Protocolo Socially Savvy para análise\n do comportamento social no\n contexto da criança",
                  textoInstrucoes:
                      "Este protocolo foi desenvolvido para auxiliar na análise do comportamento social de crianças em diferentes contextos.",
                  tituloComentario: "Comentários sobre o protocolo",
                  dicaTextoComentario:
                      "Anote aqui suas observações gerais sobre o protocolo, comportamento da criança, etc.",
                  controller: TextEditingController(),
                ),

                SizedBox(height: 8),

                ...sessaoAtual!.categoriasSessao.map((categoriaApi) {
                  return CategoriaProtocolo(
                    nomeCategoria: categoriaApi.nomeCategoria,
                    iconeCategoria: Icons.assignment_turned_in,
                    questoesDestaCategoria: categoriaApi.atividades,
                    aoAtualizar: () {
                      setState(() {});
                    },
                  );
                }) .toList(),

              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          height: 50,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Finalizar",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              SizedBox(width: 10),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Salvar",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
