import 'package:flutter/material.dart';
import 'package:espectrum_front/View/Pages/pagina_questoes_categoria.dart';

class CategoriaProtocolo extends StatefulWidget {
  CategoriaProtocolo({
    super.key,
    required this.iconeCategoria,
    required this.nomeCategoria,
    required this.questoesRespondidasInicias,
    required this.totalDeQuestoes,
  });

  final Icon iconeCategoria;
  final String nomeCategoria;
  final int questoesRespondidasInicias;
  final int totalDeQuestoes;

  @override
  State<CategoriaProtocolo> createState() => _CategoriaProtocoloState();
}

class _CategoriaProtocoloState extends State<CategoriaProtocolo> {
  late int questoesRespondidas;

  void initState() {
    super.initState();
    questoesRespondidas = widget.questoesRespondidasInicias;
  }

  void abrirTelaDeQuestoes() async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaginaQuestoesCategoria(
          nomeCategoria: widget.nomeCategoria,
          totalDeQuestoes: widget.totalDeQuestoes,
        ),
      ),
    );

    if (resultado != null && resultado is int) {
      setState(() {
        questoesRespondidas = resultado;
      });
    }
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
                    child: widget.iconeCategoria,
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
              
              questoesRespondidas == widget.totalDeQuestoes
                  ? Icon(
                      Icons.check_circle,
                      color: Theme.of(context).colorScheme.primary,
                      size: 30,
                    )
                  : Text(
                      '(${questoesRespondidas}/${widget.totalDeQuestoes}) completas',
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
