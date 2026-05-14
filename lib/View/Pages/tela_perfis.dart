import 'package:espectrum_front/View/Pages/tela_cadastro_admin.dart';
import 'package:espectrum_front/View/Pages/tela_cadastro_estagiario.dart';
import 'package:espectrum_front/View/Pages/tela_cadastro_professor.dart';
import 'package:espectrum_front/View/Pages/tela_cadastro_responsavel.dart';
import 'package:espectrum_front/View/Widgets/app_bar_padrao.dart';
import 'package:espectrum_front/View/Widgets/categoria_perfis.dart';
import 'package:espectrum_front/View/Widgets/roda_pe.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Widgets/logo_container.dart';

class TelaCadastro extends StatelessWidget {
  const TelaCadastro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarPadrao(nome: "Seleção Perfis",),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 30,
              right: 30,
              top: 30,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LogoContainer(nomePage: "Seleção de cadastro"),
                  SizedBox(height: 20),

                  CategoriaCadastro(
                    nome: "Admin",
                    descricao:
                        "Gerencie usuários, permissões e configurações do sistema",
                    gradiente: [
                      Theme.of(context).colorScheme.tertiary,
                      Theme.of(context).colorScheme.tertiary,
                    ],
                    destino: CadastroAdmin(),
                    icone: FaIcon(FontAwesomeIcons.userShield),
                  ),

                  SizedBox(height: 8),
                  CategoriaCadastro(
                    nome: "Estágiario",
                    descricao: "Acompanhe atividades e registre desenvolvimento do paciente",
                    gradiente: [
                      Theme.of(context).colorScheme.secondary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                    destino: CadastroEstagiario(),
                    icone: FaIcon(FontAwesomeIcons.brain),
                  ),

                  SizedBox(height: 8),

                  CategoriaCadastro(
                    nome: "Professor",
                    descricao: "Acompanhe o seu aluno, podendo realizar o teste socially savvy durante as aulas",
                    gradiente: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary,
                    ],
                    destino: CadastroProfessor(),
                    icone: Icon(Icons.school),
                  ),

                  SizedBox(height: 8),
                  CategoriaCadastro(
                    nome: "Responsável",
                    descricao: "Acompanhe o progresso e atividades do seu filho",
                    gradiente: [
                      Theme.of(context).colorScheme.onTertiary,
                      Theme.of(context).colorScheme.onTertiary,
                    ],
                    destino: CadastroResponsavel(),
                    icone: Icon(Icons.people),
                  ),
                  SizedBox(height: 20),
                  RodaPe(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
