import 'package:flutter/material.dart';

class BotaoPersonalizadoFiltro extends StatelessWidget {
  final Color corFundo;
  final Color corLetra;
  final String texto;
  final VoidCallback onPressed;
  const BotaoPersonalizadoFiltro({
    super.key,
    required this.corFundo,
    required this.corLetra,
    required this.texto,
    required this.onPressed
    });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: corFundo
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          )),
          onPressed: onPressed, 
          child: Text(texto, style: TextStyle(color: corLetra),)),
      );
  }
}