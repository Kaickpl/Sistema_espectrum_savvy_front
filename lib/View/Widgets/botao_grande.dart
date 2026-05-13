import 'package:flutter/material.dart';

class BotaoGrande extends StatelessWidget {
  final String texto;
  const BotaoGrande({
    super.key,
    required this.texto
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      width: 375,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.tertiary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
        ),
        onPressed: () {
        print('Botão pressionada!');
      }, child: Text(texto, style: TextStyle(fontSize: 19, color: Colors.white),)),
    );
  }
}