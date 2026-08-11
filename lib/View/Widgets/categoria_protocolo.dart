import 'package:espectrum_front/Model/Protocolo/AtividadeSessaoModel.dart';
import 'package:espectrum_front/View/Pages/Protocol/pagina_questoes_categoria.dart';
import 'package:flutter/material.dart';

class CategoriaProtocolo extends StatefulWidget {
  final IconData iconeCategoria;
  final String nomeCategoria;
  final String nomePaciente;
  final String categoriaSessaoId;
  final String sessaoId;
  final List<AtividadeSessaoModel> questoesDestaCategoria;
  final VoidCallback aoAtualizar;

  CategoriaProtocolo({
    super.key,
    required this.iconeCategoria,
    required this.nomeCategoria,
    required this.nomePaciente,
    required this.categoriaSessaoId,
    required this.sessaoId,
    required this.questoesDestaCategoria,
    required this.aoAtualizar,
  });

  @override
  State<CategoriaProtocolo> createState() => _CategoriaProtocoloState();
}

class _CategoriaProtocoloState extends State<CategoriaProtocolo> {
  int get questoesRespondidas =>
      widget.questoesDestaCategoria.where((q) => q.pontuacao != null).length;
  int get totalDeQuestoes => widget.questoesDestaCategoria.length;

  void abrirTelaDeQuestoes() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaginaQuestoesCategoria(
          nomeCategoria: widget.nomeCategoria,
          nomePaciente: widget.nomePaciente,
          categoriaSessaoId: widget.categoriaSessaoId,
          sessaoId: widget.sessaoId,
          totalDeQuestoes: totalDeQuestoes,
          iconeCategoria: widget.iconeCategoria,
          questoesDaCategoria: widget.questoesDestaCategoria,
        ),
      ),
    );

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
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.30),
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
                child: Icon(
                  widget.iconeCategoria,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),

              SizedBox(width: 12),

              Expanded(
                child: Text(
                  '${widget.nomeCategoria}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              questoesRespondidas == totalDeQuestoes && totalDeQuestoes > 0
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
                        ).colorScheme.onSecondary.withOpacity(0.6),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
