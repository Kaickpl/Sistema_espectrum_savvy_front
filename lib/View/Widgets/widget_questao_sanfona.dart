import 'package:flutter/material.dart';
import 'package:espectrum_front/View/Pages/pagina_questoes_categoria.dart';
import 'package:espectrum_front/Model/Protocolo/AtividadeSessaoModel.dart';

class WidgetQuestaoSanfona extends StatefulWidget {
  final AtividadeSessaoModel questao;
  final VoidCallback AoResponder;

  // Corrigido o tipo para o controlador nativo do Flutter
  final ExpansionTileController controlador;
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

  // Cores fixas da escala de semáforo (não mudam com o tema)
  final Map<int, Color> coresNotas = {
    0 : Colors.red,
    1 : Colors.orange,
    2 : Colors.amber,
    3 : Colors.green,
    4 : Colors.grey
  };

  bool get estaRespondida => widget.questao.pontuacao != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        // Fundo do cartão sempre obedece o surface do tema atual
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          // Borda sutil com base na cor do texto do cartão
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
        ),
      ),
      child: ExpansionTile(
        controller: widget.controlador,
        onExpansionChanged: widget.aoMudarEstadoSanfona,
        shape: const Border(),
        collapsedShape: const Border(),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.help_outline,
            size: 16,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),

        title: Text(
          widget.questao.nomeAtividade,
          style: TextStyle(
            fontSize: 17, 
            fontWeight: FontWeight.w500,
            // Texto do título obedece o onSurface para dar contraste com o fundo
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),

        trailing: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: estaRespondida
                ? Colors.green.withValues(alpha: 0.2)
                : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: estaRespondida
              ? const Icon(Icons.check, size: 16, color: Colors.green)
              : Icon(
                  Icons.access_time_rounded, 
                  size: 16, 
                  // Ícone do relógio pegando a cor de texto (onSurface) com opacidade
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)
                ),
        ),

        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Selecione a pontuação",
                  style: TextStyle(
                    fontSize: 14, 
                    fontWeight: FontWeight.bold, 
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 12),

                Column(
                  children: notasPossiveis.map((nota) {

                  
                    bool selecionado = estaRespondida && widget.questao.pontuacao == nota.toString();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          setState(() {
                            widget.questao.valorPontuacao = nota;
                            widget.questao.pontuacao = nota.toString();
                          });
                          widget.AoResponder();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            // Se selecionado, fundo fica com 10% da cor da nota. Se não, fica transparente (mostrando a surface do cartão)
                            color: selecionado
                                ? coresNotas[nota]!.withValues(alpha: 0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              // Borda colorida se selecionado, senão uma borda neutra baseada no texto do tema
                              color: selecionado
                                  ? coresNotas[nota]!
                                  : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  // Bolinha totalmente colorida se selecionada
                                  color: selecionado
                                      ? coresNotas[nota]
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: selecionado
                                        ? Colors.transparent
                                        : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3)
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    nota.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      // Se selecionado, o número na bolinha colorida fica branco. Senão, fica com a cor do texto do tema.
                                      color: selecionado
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.onSurface
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Text(
                                  descricoesNotas[nota] ?? "",
                                  style: TextStyle(
                                    fontSize: 14,
                                    // Se selecionado, o texto de descrição pega a cor do semáforo. Senão, usa a cor de texto padrão do tema atual.
                                    color: selecionado
                                      ? coresNotas[nota]
                                      : Theme.of(context).colorScheme.onSurface,
                                    fontWeight: selecionado
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  ),
                                )
                              )
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