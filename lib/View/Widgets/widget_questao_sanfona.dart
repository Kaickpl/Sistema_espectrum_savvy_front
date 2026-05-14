import 'package:flutter/material.dart';
import 'package:espectrum_front/View/Pages/pagina_questoes_categoria.dart';

class WidgetQuestaoSanfona extends StatefulWidget {
  final QuestaoModelo questao;
  final VoidCallback AoResponder;

  final ExpansibleController controlador;
  final Function(bool) aoMudarEstadoSanfona;

  const WidgetQuestaoSanfona({
    super.key,
    required this.questao,
    required this.AoResponder,
    required this.controlador,
    required this.aoMudarEstadoSanfona
  });

  @override
  State<WidgetQuestaoSanfona> createState() => _WidgetQuestaoSanfonaState();
}

class _WidgetQuestaoSanfonaState extends State<WidgetQuestaoSanfona> {
  final List<int> notasPossiveis = [0, 1, 2, 3, 4];

  final Map<int, String> descricoesNotas = {
    0: "Raramente ou nunca demonstra esta habilidade",
    1: "Demonstra esta habilidade, mas não é consistente",
    2: "Pode demonstrar esta habilidade, mas não é consistente",
    3: "Demonstra consistentemente esta habilidade",
    4: "N/A (não aplicável)",
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: ExpansionTile(
        controller: widget.controlador,
        onExpansionChanged: widget.aoMudarEstadoSanfona,
        shape: Border(),
        collapsedShape: Border(),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.question_mark_rounded,
            size: 16,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),

        title: Text(
          widget.questao.titulo,
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
        ),

        trailing: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: widget.questao.estaRespondida
                ? Colors.green.withOpacity(0.2)
                : Theme.of(context).colorScheme.surfaceVariant,
            shape: BoxShape.circle,
          ),
          child: widget.questao.estaRespondida
              ? Icon(Icons.check, size: 16, color: Colors.green)
              : Icon(Icons.access_time_rounded),
        ),

        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Selecione a pontuação",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),

                Column(
                  children: notasPossiveis.map((nota) {
                    bool selecionado = widget.questao.nota == nota;

                    return Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          setState(() {
                            widget.questao.nota = nota;
                          });
                          widget.AoResponder();
                        },
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: selecionado
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context,).colorScheme.surface.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: selecionado
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.transparent,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: selecionado
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context).colorScheme.surface,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selecionado
                                        ? Theme.of(context).colorScheme.onPrimary
                                        : Theme.of(context).colorScheme.onSurface
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    nota.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: selecionado
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.onSurface
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 12),

                              Expanded(
                                child: Text(
                                  descricoesNotas[nota] ?? "",
                                  style: TextStyle(
                                    fontSize: 14,
                                  color: selecionado
                                    ? Theme.of(context).colorScheme.onPrimary
                                    : Theme.of(context).colorScheme.onSurface,
                                  fontWeight: selecionado
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                                  ),
                                ))
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
