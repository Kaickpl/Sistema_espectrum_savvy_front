import 'package:flutter/material.dart';

class BotaoAcoesRapidas extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final Icon icone;
  final Color corFundo;
  final Color corLetra;
  final VoidCallback onTap;
  const BotaoAcoesRapidas({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.icone,
    required this.corFundo,
    required this.corLetra,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          height: 90,
          width: 335,
          decoration: BoxDecoration(
            color: corFundo,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: corLetra.withOpacity(0.1)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.surface.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: icone,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(fontSize: 17, color: corLetra),
                    ),
                    Text(
                      subtitulo,
                      style: TextStyle(
                        fontSize: 13,
                        color: corLetra.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                Icon(Icons.arrow_forward_ios, color: corLetra.withOpacity(0.3)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
