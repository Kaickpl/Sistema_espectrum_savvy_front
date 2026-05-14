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

  int get totalRespondidasGeral{
    int cont = 0;
    cont+= questoesAtencao.where((q) => q.estaRespondida).length;
    cont+= questoesBrincadeira.where((q) => q.estaRespondida).length;
    return cont;
  }

  int get totalQuestoesGeral{
    return questoesAtencao.length + questoesAtencao.length;
  }

  @override
  void dispose() {
    _comentariosController.dispose();
    super.dispose();
  }

  @override
  void initState(){
    super.initState();
      questoesAtencao =  [
                    QuestaoModelo(id: 1, titulo: "Se atenta para o objeto apresentado?"),
                    QuestaoModelo(id: 2, titulo: "Repete o próprio comportamento para manter interação social?"),
                    QuestaoModelo(id: 3, titulo: "Repete ação com brinquedo para manter interação social?"),
                    QuestaoModelo(id: 4, titulo: "Usa contato visual para manter interação social?"),
                    QuestaoModelo(id: 5, titulo: "Segue um ponto ou gesticula em direção ao objeto?"),
                    QuestaoModelo(id: 6, titulo: "Fixa o olhar em objetos?"),
                    QuestaoModelo(id: 7, titulo: "Mostra outros objetos e estabelece contato visual para compartilhar interesse?"),
                    QuestaoModelo(id: 8, titulo: "Aponta para objetos e estabelece contato visual para compartilhar interesse?"),
                    QuestaoModelo(id: 9, titulo: "Comenta sobre o que está fazendo ou sobre o que o outro está fazendo?"),
    ];

    questoesBrincadeira = [
      QuestaoModelo(id: 4, titulo: "Brinca de forma funcional com os brinquedos?"),
      QuestaoModelo(id: 5, titulo: "Engaja em brincadeiras de faz de conta simples?"),
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
                  subtitulo: "Protocolo Socially Savvy para análise\n do comportamento social no\n contexto da criança",
                  textoInstrucoes: "Este protocolo foi desenvolvido para auxiliar na análise do comportamento social de crianças em diferentes contextos.",
                  tituloComentario: "Comentários sobre o protocolo",
                  dicaTextoComentario: "Anote aqui suas observações gerais sobre o protocolo, comportamento da criança, etc.",
                  controller: _comentariosController,
                ),

                SizedBox(height: 8),

                CategoriaProtocolo(
                  nomeCategoria: "Atenção Compartilhada",
                  iconeCategoria: Icons.announcement,
                  questoesDestaCategoria: questoesAtencao,
                  aoAtualizar: () {
                    setState((){});
                  },
                ),

                // CategoriaProtocolo(
                //   iconeCategoria: Icons.toys,
                //   nomeCategoria: "Brincadeira Compartilhada",
                //   questoesRespondidasInicias: 3,
                //   totalDeQuestoes: 24,
                // ),

                // CategoriaProtocolo(
                //   iconeCategoria: Icons.self_improvement,
                //   nomeCategoria: "Auto-Regulação",
                //   questoesRespondidasInicias: 0,
                //   totalDeQuestoes: 18,
                // ),

                // CategoriaProtocolo(
                //   iconeCategoria: Icons.emoji_emotions,
                //   nomeCategoria: "Social/Emocional",
                //   questoesRespondidasInicias: 0,
                //   totalDeQuestoes: 6,
                // ),

                // CategoriaProtocolo(
                //   iconeCategoria: Icons.social_distance,
                //   nomeCategoria: "Linguagem Social",
                //   questoesRespondidasInicias: 0,
                //   totalDeQuestoes: 24,
                // ),

                // CategoriaProtocolo(
                //   iconeCategoria: Icons.class_outlined,
                //   nomeCategoria: "Sala de Aula/Comportamento em Grupo",
                //   questoesRespondidasInicias: 0,
                //   totalDeQuestoes: 23,
                // ),

                // CategoriaProtocolo(
                //   iconeCategoria: Icons.sign_language,
                //   nomeCategoria: "Linguagem não Verbal",
                //   questoesRespondidasInicias: 6,
                //   totalDeQuestoes: 6,
                // ),
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
                  onPressed: () {},
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
                  onPressed: () {},
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
