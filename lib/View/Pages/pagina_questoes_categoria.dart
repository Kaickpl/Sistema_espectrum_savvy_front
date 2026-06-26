import 'package:espectrum_front/View/Widgets/drawer_padrao.dart';
import 'package:espectrum_front/View/Widgets/widget_questao_sanfona.dart';
import 'package:flutter/material.dart';
import 'package:espectrum_front/View/Widgets/info_questoes_e_nome_paciente.dart';
import 'package:espectrum_front/View/Widgets/categoria_protocolo.dart';
import 'package:espectrum_front/Model/Protocolo/AtividadeSessaoModel.dart';
import 'package:espectrum_front/Services/ProtocoloService.dart';

class PaginaQuestoesCategoria extends StatefulWidget {
  final String nomeCategoria;
  final int totalDeQuestoes;
  final IconData iconeCategoria;
  final String comentarioInicial;
  final List<AtividadeSessaoModel> questoesDaCategoria;

  const PaginaQuestoesCategoria({
    super.key,
    required this.nomeCategoria,
    required this.totalDeQuestoes,
    required this.iconeCategoria,
    required this.comentarioInicial,
    required this.questoesDaCategoria,
    
  });

  @override
  State<PaginaQuestoesCategoria> createState() =>
      _PaginaQuestoesCategoriaState();
}

class _PaginaQuestoesCategoriaState extends State<PaginaQuestoesCategoria> {
  late TextEditingController _comentariosController;

  int? indexSanfonaAberta;
  late List<ExpansibleController> controlesDasSanfonas;

  @override
  void initState() {
    super.initState();
    _comentariosController = TextEditingController(
      text: widget.comentarioInicial,
    );

    controlesDasSanfonas = List.generate(
      widget.questoesDaCategoria.length,
      (index) => ExpansibleController(),
    );
  }

  int get quantidadeRespondidas {
    return widget.questoesDaCategoria.where((q) => q.pontuacao != null).length;
  }

  void voltar() {
    final pacoteDeRetorno = RetornoDaCategoria(
      questoesRespondidas:
          0, // Substituir pelo valor real de questões respondidas
      comentarioSalvo: _comentariosController.text,
    );
    Navigator.pop(context, pacoteDeRetorno);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) {
          return;
        }
        voltar();
      },

      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.nomeCategoria,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onBackground,
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: Theme.of(context).colorScheme.onBackground,
              size: 28,
            ),
            onPressed: () => voltar(),
          ),
          shape: Border(
            bottom: BorderSide(
              color: Color.fromARGB(255, 193, 195, 199),
              width: 1,
            ),
          ),
        ),
        body: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  InfoQuestoesENomePaciente(
                    nomePaciente: "João Silva",
                    questoesRespondidas: quantidadeRespondidas,
                    totalDeQuestoes: widget.questoesDaCategoria.length,
                    iconePrincipal: widget.iconeCategoria,
                    tituloPrincipal: widget.nomeCategoria,
                    subtitulo:
                        "Questões relacionadas à ${widget.nomeCategoria.toLowerCase()}",
                    textoInstrucoes:
                        "Responda as questões abaixo relacionadas à ${widget.nomeCategoria.toLowerCase()} para ajudar na análise do comportamento social da criança.",
                    tituloComentario: "Comentários sobre a categoria",
                    dicaTextoComentario:
                        "Anote aqui suas observações gerais sobre as questões desta categoria, comportamento da criança, etc.",
                    controller: _comentariosController,
                  ),

                  SizedBox(height: 16),

                  Text(
                    "Questões",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: Theme.of(context).colorScheme.onSecondary),
                  ),

                  SizedBox(height: 12),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: widget.questoesDaCategoria.length,
                    itemBuilder: (context, index) {
                      final questao = widget.questoesDaCategoria[index];
                      return WidgetQuestaoSanfona(
                        questao: questao,

                        AoResponder: () async {
                          try { 
                            await ProtocoloService.atualizarPontuacao(
                              questao.id,
                              questao.pontuacao.toString(),
                            );
                          } catch (e) {
                            print("Erro ao atualizar pontuação: $e");
                          }
                          
                          setState(() {});
                        },
                        controlador: controlesDasSanfonas[index],
                        aoMudarEstadoSanfona: (estaAbrindo) {
                          if (estaAbrindo) {
                            // Se a pessoa clicou pra abrir essa, fecha a que estava aberta antes!
                            if (indexSanfonaAberta != null &&
                                indexSanfonaAberta != index) {
                              controlesDasSanfonas[indexSanfonaAberta!]
                                  .collapse();
                            }
                            // Atualiza a memória dizendo que ESSA é a nova sanfona aberta
                            indexSanfonaAberta = index;
                          } else {
                            // Se a pessoa clicou pra fechar a sanfona que já estava aberta
                            if (indexSanfonaAberta == index) {
                              indexSanfonaAberta = null; // Limpa a memória
                            }
                          }
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        endDrawer: DrawerPadrao(),
      ),
    );
  }
}
