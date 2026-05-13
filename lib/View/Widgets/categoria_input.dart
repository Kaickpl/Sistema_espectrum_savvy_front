import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoriaAtributos extends StatelessWidget {
  final String nome;
  final IconData icone;
  const CategoriaAtributos({super.key, required this.nome, required this.icone});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 180),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icone, color: Theme.of(context).colorScheme.onSurface, size: 18),
            SizedBox(width: 6),
            Text(nome,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
