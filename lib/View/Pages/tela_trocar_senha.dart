import 'package:espectrum_front/View/Pages/tela_inicial.dart';
import 'package:espectrum_front/View/Widgets/app_bar_padrao.dart';
import 'package:flutter/material.dart';

import '../Widgets/fundo_botão.dart';
import '../Widgets/icon_text.dart';
import '../Widgets/roda_pe.dart';
import '../Widgets/widget_input_acesso.dart';

class TelaTrocarSenha extends StatefulWidget {
  const TelaTrocarSenha({super.key});

  @override
  State<TelaTrocarSenha> createState() => _TelaTrocarSenhaState();
}

class _TelaTrocarSenhaState extends State<TelaTrocarSenha> {
  bool obscureTextSenha = true;
  bool obscureTextConfirma = true;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBarPadrao(
        nome: 'Trocar Senha',
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
                    Icons.lock_reset,
                    size: 60,
                    color: Theme.of(context).colorScheme.primary,
                  ),

                  SizedBox(height: 12),

                  Text(
                    "Crie uma nova senha segura",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),

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

                        child: Column(
                          children: [
                            CampoTexto(
                              label: "Senha",
                              hintText: "Digite sua senha",
                              keyboardType: TextInputType.text,
                              obscureText: obscureTextSenha,

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Digite sua senha";
                                }

                                return null;
                              },

                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscureTextSenha =
                                    !obscureTextSenha;
                                  });
                                },

                                icon: Icon(
                                  obscureTextSenha
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),

                            SizedBox(height: 12),

                            CampoTexto(
                              label: "Confirmar Senha",
                              hintText: "Repita sua senha",
                              keyboardType: TextInputType.text,
                              obscureText: obscureTextConfirma,

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Confirme sua senha";
                                }

                                return null;
                              },

                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscureTextConfirma =
                                    !obscureTextConfirma;
                                  });
                                },

                                icon: Icon(
                                  obscureTextConfirma
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(
                              left: 15,
                              right: 15,
                              top: 15,
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.90,

                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  children: [
                                    IconText(texto: 'Mínimo de 8 caracteres', icone: Icons.check_circle,),
                                    SizedBox(height: 3,),
                                    IconText(texto: 'Mínimo de uma letra maiúscula', icone: Icons.check_circle,),
                                    SizedBox(height: 3,),
                                    IconText(texto: 'Mínimo de uma letra minúscula', icone: Icons.check_circle,),
                                    SizedBox(height: 3,),
                                    IconText(texto: 'Mínimo de um número', icone: Icons.check_circle,),

                                  ],
                                ),
                            ),
                            ),


                          ],
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const PaginaInicial(),
                            ),
                          );
                        }
                      },

                      child: Text(
                        "Entrar",

                        style: TextStyle(
                          color:
                          Theme.of(context)
                              .colorScheme
                              .onPrimary,
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