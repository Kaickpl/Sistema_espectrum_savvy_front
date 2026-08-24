import 'package:espectrum_front/View/Pages/Auth/tela_trocar_senha.dart';
import 'package:espectrum_front/View/Widgets/app_bar_padrao.dart';
import 'package:flutter/material.dart';

import '../../../Services/UsuarioServiceTrocarSenha.dart';
import '../../Widgets/drawer_padrao.dart';
import '../../Widgets/fundo_botão.dart';
import '../../Widgets/roda_pe.dart';
import '../../Widgets/widget_input_acesso.dart';

class TelaVerificarEmail extends StatefulWidget {
  const TelaVerificarEmail({super.key});

  @override
  State<TelaVerificarEmail> createState() => _TelaVerificarEmailState();
}

class _TelaVerificarEmailState extends State<TelaVerificarEmail> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _carregando = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _verificarEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    try {
      final email = _emailController.text.trim();
      await UsuarioServiceTrocarSenha.solicitarReset(email);

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TelaTrocarSenha(email: email)),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBarPadrao(nome: 'Verificar Email'),

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
                    color: Theme.of(context).colorScheme.primary,
                  ),

                  SizedBox(height: 12),

                  Text(
                    "Digite seu e-mail cadastrado para enviarmos um código de recuperação de senha",
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 20),

                  Form(
                    key: _formKey,

                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Container(
                        width: double.infinity,

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
                            controller: _emailController,

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Digite seu email";
                              }
                              if (!value.contains("@")) {
                                return "Email inválido";
                              }
                              return null;
                            },
                            maxLines: 1,
                          ),
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

                      onPressed: _carregando ? null : _verificarEmail,

                      child: _carregando
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            )
                          : Text(
                              "Continuar",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onPrimary,
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
