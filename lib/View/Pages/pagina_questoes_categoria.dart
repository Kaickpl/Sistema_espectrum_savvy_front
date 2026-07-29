import 'package:espectrum_front/View/Widgets/drawer_padrao.dart';
import 'package:espectrum_front/View/Widgets/widget_questao_sanfona.dart';
import 'package:flutter/material.dart';
import 'package:espectrum_front/View/Widgets/info_questoes_e_nome_paciente.dart';
import 'package:espectrum_front/View/Widgets/categoria_protocolo.dart';
import 'package:espectrum_front/Model/Protocolo/AtividadeSessaoModel.dart';
import 'package:espectrum_front/Services/ProtocoloService.dart';
import 'package:espectrum_front/Services/ComentarioService.dart';

class PaginaQuestoesCategoria extends StatefulWidget {
  final String nomeCategoria;
  final String nomePaciente;
  final String categoriaSessaoId;
  final int totalDeQuestoes;
  final IconData iconeCategoria;
  final List<AtividadeSessaoModel> questoesDaCategoria;

  const PaginaQuestoesCategoria({
    super.key,
    required this.nomeCategoria,
    required this.nomePaciente,
    required this.categoriaSessaoId,
    required this.totalDeQuestoes,
    required this.iconeCategoria,
    required this.questoesDaCategoria,
  });

  @override
  State<PaginaQuestoesCategoria> createState() =>
      _PaginaQuestoesCategoriaState();
}

class _PaginaQuestoesCategoriaState extends State<PaginaQuestoesCategoria> {
  int? indexSanfonaAberta;
  late List<ExpansibleController> controlesDasSanfonas;
  final TextEditingController _comentarioController = TextEditingController();
  String _ultimoComentarioSalvo = "";

  @override
  void initState() {
    super.initState();

    controlesDasSanfonas = List.generate(
      widget.questoesDaCategoria.length,
      (index) => ExpansibleController(),
    );

    _carregarComentario();
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  Future<void> _carregarComentario() async {
    try {
      final comentarios = await ComentarioService.buscarComentariosCategoria(
        widget.categoriaSessaoId,
      );
      if (comentarios.isEmpty || !mounted) return;

      comentarios.sort(
        (a, b) => (b.dataCriacao ?? DateTime(0)).compareTo(
          a.dataCriacao ?? DateTime(0),
        ),
      );
      setState(() {
        _comentarioController.text = comentarios.first.comentario;
        _ultimoComentarioSalvo = comentarios.first.comentario;
      });
    } catch (e) {
      print("Erro ao carregar comentário da categoria: $e");
    }
  }

  int get quantidadeRespondidas {
    return widget.questoesDaCategoria.where((q) => q.pontuacao != null).length;
  }

  void voltar() async {
    final texto = _comentarioController.text.trim();
    if (texto.isNotEmpty && texto != _ultimoComentarioSalvo) {
      try {
        await ComentarioService.comentarCategoria(
          widget.categoriaSessaoId,
          texto,
        );
      } catch (e) {
        print("Erro ao salvar comentário da categoria: $e");
      }
    }
    if (mounted) Navigator.pop(context);
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
                    nomePaciente: widget.nomePaciente,
                    questoesRespondidas: quantidadeRespondidas,
                    totalDeQuestoes: widget.questoesDaCategoria.length,
                    iconePrincipal: widget.iconeCategoria,
                    tituloPrincipal: widget.nomeCategoria,
                    subtitulo:
                        "Questões relacionadas à ${widget.nomeCategoria.toLowerCase()}",
                    textoInstrucoes:
                        "Responda as questões abaixo relacionadas à ${widget.nomeCategoria.toLowerCase()} para ajudar na análise do comportamento social da criança.",
                    comentarioController: _comentarioController,
                    tituloComentario: "Comentários sobre a categoria",
                    dicaTextoComentario:
                        "Anote aqui suas observações sobre as questões desta categoria.",
                  ),

                  SizedBox(height: 16),

                  Text(
                    "Questões",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
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
                        numeroDaQuestao: index + 1,

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
