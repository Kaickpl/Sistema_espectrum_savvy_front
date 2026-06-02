import 'package:espectrum_front/View/Pages/tela_cadastro_admin.dart';
import 'package:espectrum_front/View/Pages/tela_cadastro_estagiario.dart';
import 'package:espectrum_front/View/Pages/tela_cadastro_professor.dart';
import 'package:espectrum_front/View/Pages/tela_cadastro_responsavel.dart';
import 'package:espectrum_front/View/Widgets/app_bar_padrao.dart';
import 'package:espectrum_front/View/Widgets/categoria_perfis.dart';
import 'package:espectrum_front/View/Widgets/roda_pe.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../Widgets/drawer_padrao.dart';
import '../Widgets/logo_container.dart';

class TelaCadastro extends StatelessWidget {
  const TelaCadastro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      appBar: AppBarPadrao(nome: "Seleção Perfis",),

      endDrawer: DrawerPadrao(),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              left: 30,
              right: 30,
              top: 30,
              bottom: MediaQuery
                  .of(context)
                  .viewInsets
                  .bottom,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                LogoContainer(nomePage: "Seleção de cadastro",
                imagem: "assets/Images/Logo.png",),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery
                    .of(context)
                    .size
                    .width * 0.055),
                child: CategoriaCadastro(
                  nome: "Admin",
                  descricao:
                  "Gerencie usuários, permissões e configurações do sistema",
                  gradiente: [
                    Theme
                        .of(context)
                        .colorScheme
                        .tertiary,
                    Theme
                        .of(context)
                        .colorScheme
                        .tertiary,
                  ],
                  destino: CadastroAdmin(),
                  icone: FaIcon(FontAwesomeIcons.userShield,color: Theme.of(context).colorScheme.onPrimary,),
                ),
              ),

              SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery
                    .of(context)
                    .size
                    .width * 0.055),
                child: CategoriaCadastro(
                  nome: "Estágiario",
                  descricao: "Acompanhe atividades e registre desenvolvimento do paciente",
                  gradiente: [
                    Theme
                        .of(context)
                        .colorScheme
                        .secondary,
                    Theme
                        .of(context)
                        .colorScheme
                        .secondary,
                  ],
                  destino: CadastroEstagiario(),
                  icone: FaIcon(FontAwesomeIcons.brain,color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),

                SizedBox(height: 8),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.055),
                  child: CategoriaCadastro(
                  nome: "Professor",
                  descricao: "Acompanhe o seu aluno, podendo realizar o teste socially savvy durante as aulas",
                  gradiente: [
                    Theme
                        .of(context)
                        .colorScheme
                        .onError,
                    Theme
                        .of(context)
                        .colorScheme
                        .onError,
                  ],
                  destino: CadastroProfessor(),
                  icone: Icon(Icons.school,color: Theme.of(context).colorScheme.onPrimary),
                ),
                ),

                SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.055),
                    child: CategoriaCadastro(
                  nome: "Responsável",
                  descricao: "Acompanhe o progresso e atividades do seu filho",
                  gradiente: [
                    Theme
                        .of(context)
                        .colorScheme
                        .onTertiary,
                    Theme
                        .of(context)
                        .colorScheme
                        .onTertiary,
                  ],
                  destino: CadastroResponsavel(),
                  icone: Icon(Icons.people,color: Theme.of(context).colorScheme.onPrimary),
                ),
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
