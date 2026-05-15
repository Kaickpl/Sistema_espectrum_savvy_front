import 'package:espectrum_front/View/Widgets/botao_grande.dart';
import 'package:espectrum_front/View/Widgets/cabecalho_padrao.dart';
import 'package:espectrum_front/View/Widgets/cartao_paciente_sem_historico.dart';
import 'package:espectrum_front/View/Widgets/drawer_padrao.dart';
import 'package:espectrum_front/View/Widgets/info_home_professor_e_responsavel.dart';
import 'package:flutter/material.dart';

class HomeProfessor extends StatelessWidget {
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
                InfoHomeProfessorEResponsavel(nomePerfil: "Professor"),

                CartaoPacienteHomeSemHistorico(nomePaciente: "Maria Eduarda", data: DateTime(2026, 12, 25, 24, 30),
                  idade: 2,
                  status: "Em Progresso",
                  corStatus: Colors.yellow,),

                SizedBox(height: 12),

                CartaoPacienteHomeSemHistorico(nomePaciente: "Bernardo Vasconselos", data: DateTime(2026, 12, 27, 20, 30),
                  idade: 2,
                  status: "Em Progresso",
                  corStatus: Colors.yellow,),

                SizedBox(height: 12),

                CartaoPacienteHomeSemHistorico(nomePaciente: "Breno Junior", data: DateTime(2026, 12, 15, 20, 30),
                  idade: 2,
                  status: "Em Progresso",
                  corStatus: Colors.yellow,)
              ],
            ),
          ),
        ),
      ),

    bottomNavigationBar: Padding(padding: EdgeInsets.all(16), child: BotaoGrande(texto: "Iniciar Novo Protocolo",)),
    );
  }
}
