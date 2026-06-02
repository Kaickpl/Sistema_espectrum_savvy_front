import 'package:flutter/material.dart';

class CartaoObservacao extends StatelessWidget {
  final String status;
  final DateTime data;
  final String titulo;
  final String texto;
  const CartaoObservacao({
    super.key,
    required this.status,
    required this.data,
    required this.titulo,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    final linguagemCor = const Color.fromRGBO(96, 165, 250, 1);
    final motorCor = const Color.fromRGBO(52, 211, 153, 1);
    final cognitivoCor = const Color.fromRGBO(252, 211, 77, 1);
    final socialCor = const Color.fromRGBO(249, 168, 212, 1);
    final Color corStatus;
    if (status.toLowerCase().contains('linguagem')) {
      corStatus = linguagemCor;
    } else if (status.toLowerCase().contains('motor fino')) {
      corStatus = motorCor;
    } else if (status.toLowerCase().contains('cognitivo')) {
      corStatus = cognitivoCor;
    } else {
      corStatus = socialCor;
    }
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 180,
        width: 340,
        decoration: BoxDecoration(
          color: cores.surface,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // etiqueta de status
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 30,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: corStatus.withOpacity(0.2),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        status,
                        style: TextStyle(color: corStatus, fontSize: 10),
                      ),
                    ),
                  ),
                  Text(
                    '${data.day}/${data.month}/${data.year}',
                    style: TextStyle(
                      color: cores.onSurface.withOpacity(0.3),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Text(titulo),
              Text(
                texto,
                style: TextStyle(color: cores.onSurface.withOpacity(0.3)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
