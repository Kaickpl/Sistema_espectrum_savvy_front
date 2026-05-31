import 'package:flutter/material.dart';

class CategoriaAtributos extends StatelessWidget {
  final String nome;
  final IconData icone;

  const CategoriaAtributos({
    super.key,
    required this.nome,
    required this.icone,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.04,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icone,
              color: Theme.of(context).colorScheme.onPrimary,
              size: 18,
            ),

            const SizedBox(width: 6),

            Flexible(
              child: Text(
                nome,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}