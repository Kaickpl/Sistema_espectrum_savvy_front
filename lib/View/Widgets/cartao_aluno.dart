import 'package:flutter/material.dart';

class CartaoAluno extends StatelessWidget {
  final String nome;
  final int numPacientes;
  const CartaoAluno({
    super.key,
    required this.nome,
    required this.numPacientes,
  });

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          color: cores.surface.withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // perfil aluno
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: cores.primary.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(Icons.person, color: cores.primary),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(nome, style: TextStyle(fontSize: 18)),
                    Row(
                      children: [
                        Icon(Icons.group),
                        Text('${numPacientes} Pacientes'),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.delete,
                    color: const Color.fromARGB(130, 193, 70, 61),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 340,
                  height: 55,
                  decoration: BoxDecoration(
                    color: cores.tertiary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Vincular novo paciente',
                      style: TextStyle(color: cores.onTertiary),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 55,
                        width: 335,
                        decoration: BoxDecoration(
                          color: cores.surface.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {},
                          child: Text(
                            'Trocar paciente',
                            style: TextStyle(color: cores.onSurface),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
