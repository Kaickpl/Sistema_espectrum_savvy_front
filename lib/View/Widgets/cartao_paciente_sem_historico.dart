import 'package:espectrum_front/View/Widgets/botao_grande.dart';
import 'package:flutter/material.dart';

class CartaoPacienteHomeSemHistorico extends StatelessWidget {
  final String nomePaciente;
  final DateTime data;
  final int idade;
  final String status;
  final Color corStatus;

  final VoidCallback onContinuar;

  const CartaoPacienteHomeSemHistorico({
    super.key,
    required this.nomePaciente,
    required this.data,
    required this.idade,
    required this.status,
    required this.corStatus,
    required this.onContinuar, // 🟢 AGORA É OBRIGATÓRIO
  });

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 375),
      child: Container(
        height: 260,
        width: double.infinity,
        decoration: BoxDecoration(
          color: cores.onPrimary,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cores.onSurface, width: 1),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nomePaciente,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Última avaliação:',
                      style: TextStyle(fontSize: 12, color: cores.onSurface),
                    ),
                    Text(
                      '${data.day}/${data.month}/${data.year}',
                      style: TextStyle(fontSize: 12, color: cores.onSurface),
                    ),
                  ],
                ),
                Container(
                  height: 70,
                  width: 130,
                  decoration: BoxDecoration(
                    color: corStatus.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 7),
                      Icon(Icons.circle, color: corStatus, size: 12),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          status,
                          style: TextStyle(color: corStatus, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(width: 5),
                Container(
                  width: 60,
                  height: 40,
                  decoration: BoxDecoration(
                    color: cores.onPrimary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$idade Anos',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color.fromRGBO(100, 116, 139, 1),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            BotaoGrande(texto: "Iniciar Protocolo", caminho: onContinuar),
          ],
        ),
      ),
    );
  }
}
