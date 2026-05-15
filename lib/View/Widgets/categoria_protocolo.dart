import 'package:flutter/material.dart';
import 'package:espectrum_front/View/Pages/pagina_questoes_categoria.dart';

class RetornoDaCategoria {
  final int questoesRespondidas;
  final String comentarioSalvo;

  RetornoDaCategoria({
    required this.questoesRespondidas,
    required this.comentarioSalvo,
  });
}

class CategoriaProtocolo extends StatefulWidget {

  final IconData iconeCategoria;
  final String nomeCategoria;
  final List<QuestaoModelo> questoesDestaCategoria;
  final VoidCallback aoAtualizar;

  CategoriaProtocolo({
    super.key,
    required this.iconeCategoria,
    required this.nomeCategoria,
    required this.questoesDestaCategoria,
    required this.aoAtualizar
  });

  @override
  State<CategoriaProtocolo> createState() => _CategoriaProtocoloState();
}

class _CategoriaProtocoloState extends State<CategoriaProtocolo> {
  String meuTextoSalvo = "";

  int get questoesRespondidas => widget.questoesDestaCategoria.where((q) => q.estaRespondida).length;
  int get totalDeQuestoes => widget.questoesDestaCategoria.length;

  void abrirTelaDeQuestoes() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaginaQuestoesCategoria(
          comentarioInicial: meuTextoSalvo,
          nomeCategoria: widget.nomeCategoria,
          totalDeQuestoes: totalDeQuestoes,
          iconeCategoria: widget.iconeCategoria,
          questoesDaCategoria: widget.questoesDestaCategoria,
        ),
      ),
    );

      setState(() {
        if (resultado != null && resultado is RetornoDaCategoria) {
        meuTextoSalvo = resultado.comentarioSalvo;
      }
      
      });

      widget.aoAtualizar();
    }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: abrirTelaDeQuestoes,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
            child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(widget.iconeCategoria,
                    color: Theme.of(context).colorScheme.onPrimary,),
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      '${widget.nomeCategoria}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    ),
                  ),
              
              questoesRespondidas == totalDeQuestoes && totalDeQuestoes> 0
                  ? Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                    )
                  : Text(
                      '(${questoesRespondidas}/${widget.questoesDestaCategoria.length}) completas',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
            ],
        ),
        ),
        ),
      );
  }
}
