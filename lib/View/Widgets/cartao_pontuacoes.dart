import 'package:flutter/material.dart';

class CartaoPontuacoes extends StatelessWidget {
  final String titulo;
  final Icon icone;
  final int numSessao;
  final DateTime data;
  final double pontuacao;
  const CartaoPontuacoes({
    super.key,
    required this.titulo,
    required this.icone,
    required this.numSessao,
    required this.data,
    required this.pontuacao,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 80,
        width: 340,
        decoration: BoxDecoration(
          color: cores.surface,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: cores.tertiary.withOpacity(0.2),
                child: icone,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo),
                  Row(
                    children: [
                      Text(
                        'Sessão #${numSessao}',
                        style: TextStyle(
                          color: cores.onSurface.withOpacity(0.6),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.circle,
                          size: 7,
                          color: cores.onSurface.withOpacity(0.6),
                        ),
                      ),
                      Text(
                        '${data.day}/${data.month}/${data.year}',
                        style: TextStyle(
                          color: cores.onSurface.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              //pontuações
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('${pontuacao}', style: TextStyle(fontSize: 20)),
                  Text(
                    '/5',
                    style: TextStyle(color: cores.onSurface.withOpacity(0.5)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
