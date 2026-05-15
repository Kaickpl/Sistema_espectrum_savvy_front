import 'package:espectrum_front/View/Pages/pagina_questoes_categoria.dart';
import 'package:espectrum_front/View/Widgets/cabecalho_padrao.dart';
import 'package:espectrum_front/View/Widgets/categoria_protocolo.dart';
import 'package:espectrum_front/View/Widgets/drawer_padrao.dart';
import 'package:flutter/material.dart';
import 'package:espectrum_front/View/Widgets/info_questoes_e_nome_paciente.dart';

class PaginaProtocolo extends StatefulWidget {
  const PaginaProtocolo({super.key});

  @override
  State<PaginaProtocolo> createState() => _PaginaProtocoloState();
}

class _PaginaProtocoloState extends State<PaginaProtocolo> {
  final String nomePaciente = "João Silva";

  final TextEditingController _comentariosController = TextEditingController();

  late List<QuestaoModelo> questoesAtencao;
  late List<QuestaoModelo> questoesBrincadeira;
  late List<QuestaoModelo> questoesSocialEmocional;

  int get totalRespondidasGeral {
    int cont = 0;
    cont += questoesAtencao.where((q) => q.estaRespondida).length;
    cont += questoesBrincadeira.where((q) => q.estaRespondida).length;
    cont += questoesSocialEmocional.where((q) => q.estaRespondida).length;
    return cont;
  }

  int get totalQuestoesGeral {
    return questoesAtencao.length +
        questoesBrincadeira.length +
        questoesSocialEmocional.length;
  }

  @override
  void dispose() {
    _comentariosController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    questoesAtencao = [
      QuestaoModelo(
        id: 1,
         titulo: "Se atenta para o objeto apresentado?"),
      QuestaoModelo(
        id: 2,
        titulo: "Repete o próprio comportamento para manter interação social?",
      ),
      QuestaoModelo(
        id: 3,
        titulo: "Repete ação com brinquedo para manter interação social?",
      ),
      QuestaoModelo(
        id: 4,
        titulo: "Usa contato visual para manter interação social?",
      ),
      QuestaoModelo(
        id: 5,
        titulo: "Segue um ponto ou gesticula em direção ao objeto?",
      ),
      QuestaoModelo(id: 6, titulo: "Fixa o olhar em objetos?"),
      QuestaoModelo(
        id: 7,
        titulo:
            "Mostra outros objetos e estabelece contato visual para compartilhar interesse?",
      ),
      QuestaoModelo(
        id: 8,
        titulo:
            "Aponta para objetos e estabelece contato visual para compartilhar interesse?",
      ),
      QuestaoModelo(
        id: 9,
        titulo:
            "Comenta sobre o que está fazendo ou sobre o que o outro está fazendo?",
      ),
    ];

    questoesBrincadeira = [
      QuestaoModelo(
        id: 1,
        titulo: "Brinca de forma funcional com os brinquedos?",
      ),
      QuestaoModelo(
        id: 2,
        titulo: "Engaja em brincadeiras de faz de conta simples?",
      ),
      QuestaoModelo(
        id: 3,
        titulo:
            "Brinca paralelamente de 5 a 10 min perto de pares com brinquedos de encaixe (blocos, caminhões, legos?)",
      ),
      QuestaoModelo(
        id: 4,
        titulo:
            "Brinca cooperativamente (da direções para o par e aceita direções do outro) por 5 a 10 min com brinquedo de encaixe?",
      ),
      QuestaoModelo(
        id: 5,
        titulo:
            "Aceita turnos como parte de um jogo e sustenta a atenção até completar o jogo?",
      ),
      QuestaoModelo(
        id: 6,
        titulo:
            "Participa de brincadeiras de áreas extenas com um grupo até o fim da atividade?",
      ),
    ];

    questoesSocialEmocional = [
      QuestaoModelo(
        id: 1,
        titulo: "Reconhece emoções nos outros e nele mesmo?",
      ),
      QuestaoModelo(
        id: 2,
        titulo:
            "Dá uma simples explicação de seu próprio estado emocional ou do outro quando questionado?",
      ),
      QuestaoModelo(id: 3, titulo: "Demonstra empatica pelos outros?"),
      QuestaoModelo(
        id: 4,
        titulo:
            "Expressa emoções negativas sem exibir comportamentos desafiadores?",
      ),
      QuestaoModelo(
        id: 5,
        titulo:
            "Expressa níveis apropriados de entusiasmo sobre as ações ou em relação aos outros?",
      ),
      QuestaoModelo(
        id: 6,
        titulo:
            "Antecipa como um par deve responder ao seu comportamente e responde de acordo?",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CabecalhoPadrao(titulo: "Protocolo: ${nomePaciente}"),
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
                  nomePaciente: nomePaciente,
                  questoesRespondidas: totalRespondidasGeral,
                  totalDeQuestoes: totalQuestoesGeral,
                  iconePrincipal: Icons.assignment,
                  tituloPrincipal: "Protocolo de Atendimento",
                  subtitulo:
                      "Protocolo Socially Savvy para análise\n do comportamento social no\n contexto da criança",
                  textoInstrucoes:
                      "Este protocolo foi desenvolvido para auxiliar na análise do comportamento social de crianças em diferentes contextos.",
                  tituloComentario: "Comentários sobre o protocolo",
                  dicaTextoComentario:
                      "Anote aqui suas observações gerais sobre o protocolo, comportamento da criança, etc.",
                  controller: _comentariosController,
                ),

                SizedBox(height: 8),

                CategoriaProtocolo(
                  nomeCategoria: "Atenção Compartilhada",
                  iconeCategoria: Icons.announcement,
                  questoesDestaCategoria: questoesAtencao,
                  aoAtualizar: () {
                    setState(() {});
                  },
                ),

                CategoriaProtocolo(
                  iconeCategoria: Icons.toys,
                  nomeCategoria: "Brincadeira Compartilhada",
                  questoesDestaCategoria: questoesBrincadeira,
                  aoAtualizar: () {
                    setState(() {});
                  },
                ),

                CategoriaProtocolo(
                  iconeCategoria: Icons.emoji_emotions,
                  nomeCategoria: "Social/Emocional",
                  questoesDestaCategoria: questoesSocialEmocional,
                  aoAtualizar: () {
                    setState(() {});
                  },
                ),
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
