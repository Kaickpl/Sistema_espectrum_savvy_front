import 'package:espectrum_front/View/Widgets/botao_grande.dart';
import 'package:espectrum_front/View/Widgets/cabecalho_padrao.dart';
import 'package:espectrum_front/View/Widgets/cartao_paciente_home.dart';
import 'package:espectrum_front/View/Widgets/drawer_padrao.dart';
import 'package:espectrum_front/View/Widgets/info_home_professor_e_responsavel.dart';
import 'package:espectrum_front/View/Widgets/logo_container.dart';
import 'package:flutter/material.dart';

class HomeResponsavel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CabecalhoPadrao(titulo: "Bem vindo ao Socially Savvy"),
      endDrawer: DrawerPadrao(),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InfoHomeProfessorEResponsavel(nomePerfil: "Responsável"),

                SizedBox(height: 20),

                CartaoPacienteHome(
                  nomePaciente: "João Silva",
                  data: DateTime(2026, 12, 25, 20, 30),
                  nivel: 3,
                  idade: 2,
                  status: "Em Progresso",
                  corStatus: Colors.yellow,
                  onContinuar: () {
                    print('a');
                  },
                  onHistorico: () {
                    print('a');
                  },
                ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsetsGeometry.all(17),
        child: BotaoGrande(texto: "Iniciar Protocolo"),
      ),
    );
  }
}
