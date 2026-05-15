import 'package:flutter/material.dart';
import 'botao_grande.dart';
import 'drawer_padrao.dart';
import 'logo_container.dart';
import 'cabecalho_padrao.dart';

class InfoHomeProfessorEResponsavel extends StatelessWidget{
  final String nomePerfil;

  const InfoHomeProfessorEResponsavel({
    Key? key,
    required this.nomePerfil
  });

  @override
  Widget build(BuildContext context) {
      return SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                LogoContainer(
                  nomePage:
                      "Você está logado com um perfil de ${nomePerfil}.\n Acompanhe o desenvolvimento da(s) criança(s)\n e realize o protocolo em contextos sociais!", imagem: "assets/Images/Logo.png",
                ),
                SizedBox(height: 16),
                Text(
                  "Que bom que você está de volta!",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 16),

                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: Offset(0, 2)
                    )]
                  ),
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 10),
                      Text(
                        'Testes em andamento:',
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        ),
      );
  }
}