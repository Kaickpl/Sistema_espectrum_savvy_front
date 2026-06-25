// cartao_aluno.dart
import 'package:flutter/material.dart';
import 'package:espectrum_front/View/Pages/tela_vincular_pacientes.dart';

class CartaoAluno extends StatelessWidget {
  final String nome;
  final int numPacientes;
  final VoidCallback? onDelete;

  const CartaoAluno({
    super.key,
    required this.nome,
    required this.numPacientes,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    final isDark = tema.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? cores.surface.withOpacity(0.45)
            : cores.surfaceContainer.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cores.onSurface.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: cores.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(Icons.person, color: cores.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nome,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: cores.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.group,
                          size: 16,
                          color: cores.onSurface.withOpacity(0.5),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$numPacientes pacientes',
                          style: TextStyle(
                            fontSize: 13,
                            color: cores.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: Icon(
                  Icons.delete_outline,
                  color: cores.error.withOpacity(0.7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: cores.tertiary,
                foregroundColor: cores.onTertiary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TelaVincularPacientes(nomeAlunoPreSelecionado: nome),
                  ),
                );
              },
              icon: const Icon(Icons.link, size: 18),
              label: const Text(
                'Vincular',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
