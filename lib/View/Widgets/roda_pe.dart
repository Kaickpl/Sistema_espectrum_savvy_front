import 'package:flutter/material.dart';

class RodaPe extends StatelessWidget {
  const RodaPe({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
          child: Text(
            '© Aplicativo Desenvolvido \n pela Turma 2026.1',
            style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onPrimary),
            textAlign: TextAlign.right,
          ),
    ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            height: 20,
            width: 1,
            color: Colors.grey[400],
            alignment: Alignment.center,
          ),
          Flexible(


          child: Text(
            'Universidade de Pernambuco \n Professor Élisson Rocha',
            style: TextStyle(fontSize: 10,color: Theme.of(context).colorScheme.onPrimary),
            textAlign: TextAlign.left,
          ),
          ),
        ],
      ),
    );
  }
}
