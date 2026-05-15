import 'package:espectrum_front/View/Pages/pagina_protocolo.dart';
import 'package:espectrum_front/View/Pages/relatorio_evolucao.dart';
import 'package:flutter/material.dart';

class CartaoPacienteHome extends StatelessWidget {
  final String nomePaciente;
  final DateTime data;
  final int nivel;
  final int idade;
  final String status;
  final Color corStatus;

  // Adicionando as funções de callback
  final VoidCallback onContinuar;
  final VoidCallback onHistorico;

  const CartaoPacienteHome({
    super.key,
    required this.nomePaciente,
    required this.data,
    required this.nivel,
    required this.idade,
    required this.status,
    required this.corStatus,
    required this.onContinuar,
    required this.onHistorico,
  });

  @override
  Widget build(BuildContext context) {
    // Definindo as cores padrão para facilitar a manutenção
    const corPrimaria = Color.fromRGBO(99, 102, 241, 1);

    return Container(
      width: 375,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color.fromARGB(130, 197, 197, 197),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nomePaciente,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Text(
                    'Última avaliação:',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    '${data.day}/${data.month}/${data.year}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: corStatus.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(Icons.circle, color: corStatus, size: 10),
                    const SizedBox(width: 8),
                    Text(
                      status,
                      style: TextStyle(
                        color: corStatus,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Chips de Informação
          Row(
            children: [
              _buildChip(
                'Nível $nivel',
                const Color.fromRGBO(224, 242, 241, 1),
              ),
              const SizedBox(width: 8),
              _buildChip('TEA', const Color.fromRGBO(243, 244, 246, 1)),
              const SizedBox(width: 8),
              _buildChip('$idade Anos', const Color.fromRGBO(243, 244, 246, 1)),
            ],
          ),
          const SizedBox(height: 24),
          // BOTÕES DE AÇÃO
          Row(
            children: [
              // Botão Continuar
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaginaProtocolo(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.play_arrow, color: Colors.white),
                  label: const Text('Continuar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: corPrimaria,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 52), // Altura do botão
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Botão Histórico
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RelatorioEvolucao(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.description, color: corPrimaria),
                  label: const Text('Histórico'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: corPrimaria,
                    minimumSize: const Size(0, 52),
                    side: const BorderSide(
                      color: Color.fromRGBO(226, 232, 240, 1),
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para os chips (Nível, TEA, Idade)
  Widget _buildChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Color.fromRGBO(100, 116, 139, 1),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
