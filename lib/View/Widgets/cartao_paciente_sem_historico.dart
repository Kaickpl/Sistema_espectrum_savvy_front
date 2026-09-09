import 'package:espectrum_front/View/Widgets/botao_grande.dart';
import 'package:flutter/material.dart';

class CartaoPacienteHomeSemHistorico extends StatelessWidget {
  final String nomePaciente;
  final int? idade;
  final String grauAutismo;

  final VoidCallback onContinuar;

  const CartaoPacienteHomeSemHistorico({
    super.key,
    required this.nomePaciente,
    required this.idade,
    required this.grauAutismo,
    required this.onContinuar,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 375),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: cores.onPrimary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cores.onSurface, width: 1),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nomePaciente,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (idade != null) _Chip(texto: '$idade anos', cores: cores),
                _Chip(texto: grauAutismo, cores: cores),
              ],
            ),
            const SizedBox(height: 20),
            BotaoGrande(texto: "Iniciar Protocolo", caminho: onContinuar),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String texto;
  final ColorScheme cores;

  const _Chip({required this.texto, required this.cores});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: cores.surfaceContainer,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        texto,
        style: TextStyle(fontSize: 13, color: cores.onSecondary),
      ),
    );
  }
}
