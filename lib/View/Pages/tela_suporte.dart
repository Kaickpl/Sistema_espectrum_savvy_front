import 'package:espectrum_front/Model/ApiExceptionModel.dart';
import 'package:espectrum_front/Services/SuporteService.dart';
import 'package:espectrum_front/Services/TokenStorage.dart';
import 'package:espectrum_front/View/Widgets/app_bar_padrao.dart';
import 'package:espectrum_front/View/Widgets/roda_pe.dart';
import 'package:espectrum_front/View/Widgets/widget_input_acesso.dart';
import 'package:flutter/material.dart';

import '../Widgets/drawer_padrao.dart';
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
  bool _enviando = false;

  final TextEditingController descricaoController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    descricaoController.dispose();
    emailController.dispose();
    super.dispose();
  }

  void _mostrarSnack(String msg, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: const TextStyle(color: Colors.white)),
        backgroundColor: cor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Future<void> _enviarSolicitacao() async {
    if (!_formKey.currentState!.validate()) return;

    final categorias = <String>{
      if (loginConta) 'LOGIN_CONTA',
      if (funcionamento) 'FUNCIONAMENTO_APP',
      if (resultados) 'RESULTADOS_HISTORICO',
      if (outros) 'OUTROS',
    };

    if (categorias.isEmpty) {
      _mostrarSnack(
        'Selecione ao menos uma categoria do problema.',
        Theme.of(context).colorScheme.error,
      );
      return;
    }

    setState(() => _enviando = true);
    try {
      final token = await TokenStorage.lerToken();
      await SuporteService.enviarSolicitacao(
        token ?? '',
        categorias: categorias,
        descricao: descricaoController.text.trim(),
        email: emailController.text.trim(),
      );
      if (!mounted) return;
      _mostrarSnack(
        'Solicitação enviada! Nossa equipe vai responder em breve.',
        const Color(0xFF25A329),
      );
      Navigator.pop(context);
    } on ApiException catch (e) {
      if (!mounted) return;
      _mostrarSnack(e.message, Theme.of(context).colorScheme.error);
    } catch (_) {
      if (!mounted) return;
      _mostrarSnack(
        'Não foi possível enviar sua solicitação. Tente novamente.',
        Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,

      appBar: AppBarPadrao(nome: 'Suporte'),
      drawer: DrawerPadrao(),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Container(
                    padding: EdgeInsets.all(12),

                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,

                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Icon(
                          Icons.info,
                          color: Theme.of(context).colorScheme.primary,
                        ),

                        SizedBox(width: 8),

                        Expanded(
                          child: Text(
                            "Este suporte é exclusivo para dúvidas sobre o aplicativo. Para questões sobre coleta de dados, consulte os profissionais da saúde.",

                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  Text(
                    "Categoria do problema",

                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  SizedBox(height: 10),

                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                      ),

                      borderRadius: BorderRadius.circular(15),
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

                          title: Text("Login e Conta"),
                        ),

                        Divider(height: 1),

                        CheckboxListTile(
                          value: funcionamento,

                          onChanged: (value) {
                            setState(() {
                              funcionamento = value!;
                            });
                          },

                          title: Text("Funcionamento do App"),
                        ),

                        Divider(height: 1),

                        CheckboxListTile(
                          value: resultados,

                          onChanged: (value) {
                            setState(() {
                              resultados = value!;
                            });
                          },

                          title: Text("Resultados e Histórico"),
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
                    label: "Descreva o problema",
                    hintText: "Conte com detalhes o que está acontecendo",
                    controller: descricaoController,
                    maxLines: 2,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Descreva o problema";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 24),

                  CampoTexto(
                    label: "Email",
                    hintText: "Digite seu email",
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty)
                        return "Digite seu email";
                      if (!value.contains("@")) return "Email inválido";
                      return null;
                    },
                    maxLines: 1,
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
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      onPressed: _enviando ? null : _enviarSolicitacao,

                      child: _enviando
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            )
                          : Text(
                              "Enviar",

                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,

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
