import 'package:flutter/material.dart';

class CartaoPacienteRelatorio extends StatelessWidget {
  final String nomePaciente;
  final int idade;
  final int nivel;
  final String nomeTerapeuta;
  final VoidCallback? onExportarPdf;
  final bool exportando;

  const CartaoPacienteRelatorio({
    super.key,
    required this.nomePaciente,
    required this.idade,
    required this.nivel,
    required this.nomeTerapeuta,
    this.onExportarPdf,
    this.exportando = false,
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: cores.onPrimaryContainer,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Linha do Paciente
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: cores.primaryContainer,
                    child: Icon(
                      Icons.person_outline,
                      size: 32,
                      color: cores.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nomePaciente,
                          style: tema.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cores.onSecondary,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '$idade ano',
                              style: TextStyle(color: cores.onSecondary),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                              child: Icon(
                                Icons.circle,
                                size: 4,
                                color: cores.onSecondary,
                              ),
                            ),
                            Text(
                              'TEA Nível $nivel',
                              style: TextStyle(color: cores.onSecondary),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Linha do Terapeuta e Botão
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: cores.tertiary.withOpacity(0.1),
                          child: Icon(
                            Icons.medical_services_outlined,
                            size: 18,
                            color: cores.tertiary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Terapeuta Responsável',
                                style: TextStyle(
                                  color: cores.onSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                nomeTerapeuta,
                                style: TextStyle(
                                  color: cores.onSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Botão PDF
                  Material(
                    color: cores.tertiary,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: exportando ? null : onExportarPdf,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: exportando
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: cores.surface,
                                ),
                              )
                            : Column(
                                children: [
                                  Text(
                                    'Exportar',
                                    style: TextStyle(
                                      color: cores.onSecondary,
                                      fontSize: 10,
                                    ),
                                  ),
                                  Text(
                                    'PDF',
                                    style: TextStyle(
                                      color: cores.onSecondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
