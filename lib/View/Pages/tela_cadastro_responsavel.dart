import 'package:espectrum_front/View/Pages/home_responsavel.dart';
import 'package:espectrum_front/View/Widgets/categoria_input.dart';
import 'package:espectrum_front/View/Widgets/logo_container.dart';
import 'package:espectrum_front/View/Widgets/roda_pe.dart';
import 'package:flutter/material.dart';
import '../Widgets/app_bar_padrao.dart';
import '../Widgets/widget_termo_uso_privacidade.dart';
import '../Widgets/widget_input_acesso.dart';

class CadastroResponsavel extends StatefulWidget {
  const CadastroResponsavel({super.key});

  @override
  State<CadastroResponsavel> createState() => _CadastroResponsavelState();
}

class _CadastroResponsavelState extends State<CadastroResponsavel> {
  final _formKey = GlobalKey<FormState>();
  bool obscureTextSenha = true;
  bool obscureTextConfirma = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBarPadrao(nome: "Cadastro"),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LogoContainer(nomePage: 'Cadastro Reponsável', imagem: "assets/Images/Logo.png",),
                SizedBox(height: 12),
                CategoriaAtributos(nome: "Dados Responsável      ",icone: Icons.person,),
                

                SizedBox(

                  child: ElevatedButton(

                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                             HomeResponsavel(),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(vertical: 16,horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Cadastrar",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                RodaPe(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}