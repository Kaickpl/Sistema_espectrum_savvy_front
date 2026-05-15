import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  final String texto;
  final IconData icone;
  const IconText({super.key, required this.texto, required this.icone});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icone,color: Theme.of(context).colorScheme.primary,),
        SizedBox(width: 8),
        Text(texto,style: TextStyle(color: Theme.of(context).colorScheme.primary),),
      ],
    );
  }
}
