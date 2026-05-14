import 'package:flutter/material.dart';

class CartaoRelatorio extends StatelessWidget {
  final String titulo;
  final String status;
  final DateTime data;
  final String nomeTerapeuta;
  const CartaoRelatorio({
    super.key,
    required this.titulo,
    required this.status,
    required this.data,
    required this.nomeTerapeuta,
  });

  @override
  Widget build(BuildContext context) {
    final concluidoCor = const Color.fromARGB(255, 37, 163, 41);
    final emProgressoCor = const Color.fromARGB(255, 216, 163, 71);
    final Color corStatus;
    final cores = Theme.of(context).colorScheme;
    if (status.toLowerCase().contains('concluído')) {
      corStatus = concluidoCor;
    } else {
      corStatus = emProgressoCor;
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 200,
        width: 340,
        decoration: BoxDecoration(
          color: cores.surface.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: cores.onSurface.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(37, 244, 67, 54),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.file_present,
                      color: const Color.fromARGB(255, 193, 70, 61),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(titulo, style: TextStyle(fontSize: 16)),
                      Row(
                        children: [
                          // etiqueta de status
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 30,
                              width: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: corStatus.withOpacity(0.2),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                status,
                                style: TextStyle(color: corStatus),
                              ),
                            ),
                          ),
                          //data
                          Text(
                            '${data.day}/${data.month}/${data.year}',
                            style: TextStyle(
                              color: cores.onSurface.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Gerado por: ${nomeTerapeuta}',
                        style: TextStyle(
                          color: cores.onSurface.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: 55,
              width: 310,
              decoration: BoxDecoration(
                color: cores.primary.withOpacity(0.2),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [Icon(Icons.download), Text('Baixar PDF')],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
