import 'package:flutter/material.dart';

class CampoAnotacaoPadrao extends StatelessWidget {
  final TextEditingController controller;
  final String titulo;
  final String dicaTexto;
  final int numeroLinhas;

  const CampoAnotacaoPadrao({
    super.key,
    required this.controller,
    required this.titulo,
    required this.dicaTexto,
    this.numeroLinhas = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // O título da anotação
        Row(
          children: [
            Icon(
              Icons.edit_note_rounded,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              titulo,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // A caixa de texto em si
        TextField(
          controller: controller,
          maxLines: numeroLinhas,
          decoration: InputDecoration(
            hintText: dicaTexto,
            hintStyle: TextStyle(fontSize: 14),
            alignLabelWithHint: true,
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
            
            // Borda padrão
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
              ),
            ),
            
            // Borda focada (lacre)
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
