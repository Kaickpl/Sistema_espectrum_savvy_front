import 'package:espectrum_front/View/Widgets/campo_anotacao_padrao.dart';
import 'package:flutter/material.dart';

// O nome correto para esse topo da tela!
class InfoQuestoesENomePaciente extends StatelessWidget {
  final IconData iconePrincipal;
  final String tituloPrincipal;
  final String subtitulo;
  final String textoInstrucoes;
  final int questoesRespondidas;
  final int totalDeQuestoes;
  final String nomePaciente;
  final TextEditingController controller;
  final String tituloComentario;
  final String dicaTextoComentario;

  const InfoQuestoesENomePaciente({
    Key? key,
    required this.iconePrincipal,
    required this.tituloPrincipal,
    required this.subtitulo,
    required this.textoInstrucoes,
    required this.questoesRespondidas,
    required this.totalDeQuestoes,
    required this.nomePaciente,
    required this.controller,
    required this.tituloComentario,
    required this.dicaTextoComentario,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double porcentagemProgresso = totalDeQuestoes > 0 
        ? questoesRespondidas / totalDeQuestoes 
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: CircleAvatar(
            radius: 36,
            backgroundColor: Theme.of(context).colorScheme.surface,
            child: Icon(
              iconePrincipal,
              color: Theme.of(context).colorScheme.primary,
              size: 32,
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        Text(
          tituloPrincipal,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSurface, // Ajustado de onBackground
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitulo,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info,
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              const SizedBox(width: 16), // Diminuí um pouco o respiro aqui
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Instruções",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      textoInstrucoes, // Texto dinâmico!
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05), // Sombra mais leve
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      '${questoesRespondidas.toString().padLeft(2, '0')}/'+ '${totalDeQuestoes.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Questões",
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      nomePaciente,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Paciente",
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Progresso",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$questoesRespondidas/$totalDeQuestoes',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  minHeight: 8, // Altura da barrinha
                  value: porcentagemProgresso, // Usa a nossa matemática!
                  backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.10),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16),

        CampoAnotacaoPadrao(controller: controller, titulo: tituloComentario, dicaTexto: dicaTextoComentario)

      ],
    );
  }
}