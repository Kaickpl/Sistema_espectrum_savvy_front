import 'package:espectrum_front/View/Pages/tela_inicial.dart';
import 'package:espectrum_front/View/Widgets/app_bar_padrao.dart';
import 'package:espectrum_front/View/Widgets/roda_pe.dart';
import 'package:espectrum_front/View/Widgets/widget_input_acesso.dart';
import 'package:flutter/material.dart';

import '../Widgets/fundo_botão.dart';

class TelaSuporte extends StatefulWidget {
  const TelaSuporte({super.key});

  @override
  State<TelaSuporte> createState() => _TelaSuporteState();
}

class _TelaSuporteState extends State<TelaSuporte> {
  final _formKey = GlobalKey<FormState>();

  bool loginConta = false;
  bool funcionamento = false;
  bool resultados = false;
  bool outros = false;

  final TextEditingController descricaoController =
  TextEditingController();

  final TextEditingController emailController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      Theme.of(context).colorScheme.onPrimary,

      appBar: AppBarPadrao(nome: 'Suporte'),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Container(
                    padding: EdgeInsets.all(12),

                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary,

                      borderRadius:
                      BorderRadius.circular(12),
                    ),

                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [
                        Icon(
                          Icons.info,
                          color: Theme.of(context)
                              .colorScheme
                              .primary,
                        ),

                        SizedBox(width: 8),

                        Expanded(
                          child: Text(
                            "Este suporte é exclusivo para dúvidas sobre o aplicativo. Para questões sobre coleta de dados, consulte os profissionais da saúde.",

                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  Text(
                    "Categoria do problema",

                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .primary,
                      ),

                      borderRadius:
                      BorderRadius.circular(15),
                    ),

                    child: Column(
                      children: [

                        CheckboxListTile(
                          value: loginConta,

                          onChanged: (value) {
                            setState(() {
                              loginConta = value!;
                            });
                          },

                          title:
                          Text("Login e Conta"),
                        ),

                        Divider(height: 1),

                        CheckboxListTile(
                          value: funcionamento,

                          onChanged: (value) {
                            setState(() {
                              funcionamento = value!;
                            });
                          },

                          title: Text(
                            "Funcionamento do App",
                          ),
                        ),

                        Divider(height: 1),

                        CheckboxListTile(
                          value: resultados,

                          onChanged: (value) {
                            setState(() {
                              resultados = value!;
                            });
                          },

                          title: Text(
                            "Resultados e Histórico",
                          ),
                        ),

                        Divider(height: 1),

                        CheckboxListTile(
                          value: outros,

                          onChanged: (value) {
                            setState(() {
                              outros = value!;
                            });
                          },
                          title: Text("Outros"),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  CampoTexto(
                    label: "Email",
                    hintText: "Digite seu email",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Digite seu email";
                      if (!value.contains("@")) return "Email inválido";
                      return null;
                    },
                  ),

                  SizedBox(height: 30),

                  FundoBotao(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),

                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                      ),

                      onPressed: () {
                        if (_formKey.currentState!
                            .validate()) {

                          Navigator.pop(
                            context
                          );
                        }
                      },

                      child: Text(
                        "Enviar",

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