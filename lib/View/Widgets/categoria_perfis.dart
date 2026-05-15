import 'package:flutter/material.dart';

class CategoriaCadastro extends StatelessWidget {
  final String nome;
  final String descricao;
  final Widget icone;
  final List<Color> gradiente;
  final Widget destino;

  const CategoriaCadastro({
    super.key,
    required this.nome,
    required this.destino,
    required this.icone,
    required this.descricao,
    required this.gradiente,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      elevation: 1,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destino),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: 320,
          height: 120,
          child: Padding(padding: const EdgeInsets.all(16),
            child: Row(
            children: [
            Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradiente,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: icone,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nome,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  descricao,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          ],
        ),
      ),
    ),)
    ,
    );
  }
}