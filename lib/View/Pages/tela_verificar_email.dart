import 'package:espectrum_front/View/Pages/tela_trocar_senha.dart';
import 'package:espectrum_front/View/Widgets/app_bar_padrao.dart';
import 'package:flutter/material.dart';

import '../Widgets/fundo_botão.dart';
import '../Widgets/logo_container.dart';
import '../Widgets/roda_pe.dart';
import '../Widgets/widget_input_acesso.dart';

class TelaVerificarEmail extends StatelessWidget {
  TelaVerificarEmail({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBarPadrao(
        nome: 'Verificar Email',
      ),

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

                  Icon(
                    Icons.email,
                    size: 60,
                    color: Theme.of(context).colorScheme.primary
                  ),

                  SizedBox(height: 12,),

                  Text("Digite seu e-mail cadastrado para verificarmos se você possui uma conta em nosso sistema",style: TextStyle(fontSize: 16),textAlign: TextAlign.center,),

                  SizedBox(height: 20),

                  Form(
                    key: _formKey,

                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,

                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Padding(
                        padding: EdgeInsets.all(20),

                        child: CampoTexto(
                          label: "Email",
                          hintText: "Digite seu email",
                          keyboardType: TextInputType.emailAddress,

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Digite seu email";
                            }

                            if (!value.contains("@")) {
                              return "Email inválido";
                            }

                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  FundoBotao(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: 24,
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TrocarSenha())
                          );
                        }
                      },

                      child: Text(
                        "Entrar",

                        style: TextStyle(
                          color:
                          Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
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
      ),
    );
  }
}