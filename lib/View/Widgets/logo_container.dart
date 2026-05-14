import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogoContainer extends StatelessWidget {
  const LogoContainer({super.key, required this.nomePage, required this.imagem});

  final String nomePage;
  final String imagem;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          child: Image.asset(imagem,),
        ),
        SizedBox(height: 8),
        Text(
          "Socially Savvy",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        Text(nomePage),
      ],
    );
  }
}
