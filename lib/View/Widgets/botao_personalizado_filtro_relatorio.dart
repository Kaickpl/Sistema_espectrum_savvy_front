import 'package:flutter/material.dart';

class BotaoPersonalizadoFiltroRelatorio extends StatelessWidget {
  final String titulo;
  final Icon icone;
  final VoidCallback onTap;
  final bool selecionado;
  const BotaoPersonalizadoFiltroRelatorio({
    super.key,
    required this.titulo,
    required this.icone,
    required this.onTap,
    this.selecionado = false,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 190,
          height: 50,
          decoration: BoxDecoration(
            color: selecionado ? cores.primary : cores.surface.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
            border: selecionado
                ? Border.all(color: cores.primaryContainer)
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icone.icon,
                  color: selecionado
                      ? cores.onPrimary
                      : cores.onSurface.withOpacity(0.7),
                ),
                Text(
                  titulo,
                  style: TextStyle(
                    fontWeight: selecionado
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: selecionado
                        ? cores.onPrimary
                        : cores.onSurface.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
