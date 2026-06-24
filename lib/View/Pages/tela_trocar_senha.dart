import 'package:espectrum_front/Services/UsuarioService.dart';
import 'package:espectrum_front/View/Pages/tela_inicial.dart';
import 'package:espectrum_front/View/Widgets/app_bar_padrao.dart';
import 'package:flutter/material.dart';

import '../Widgets/drawer_padrao.dart';
import '../Widgets/fundo_botão.dart';
import '../Widgets/roda_pe.dart';
import '../Widgets/widget_input_acesso.dart';
import '../Widgets/validadorsenha.dart';

class TelaTrocarSenha extends StatefulWidget {
  final String email; // recebido da tela anterior

  const TelaTrocarSenha({super.key, required this.email});

  @override
  State<TelaTrocarSenha> createState() => _TelaTrocarSenhaState();
}

class _TelaTrocarSenhaState extends State<TelaTrocarSenha> {
  bool obscureTextSenha = true;
  bool obscureTextConfirma = true;
  bool _carregando = false;

  final _senhaController = TextEditingController();
  final _confirmaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _senhaController.dispose();
    _confirmaController.dispose();
    super.dispose();
  }

  Future<void> _trocarSenha() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    try {
      await UsuarioService.recuperarSenha(
        email: widget.email,
        novaSenha: _senhaController.text,
        confirmaSenha: _confirmaController.text,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Senha alterada com sucesso!')));

      // Vai para a tela inicial e limpa o histórico de navegação
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const PaginaInicial()),
        (route) => false,
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

      appBar: AppBarPadrao(nome: 'Trocar Senha'),
      drawer: DrawerPadrao(),

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
                              controller: _senhaController,
                              validator: validarSenhaForte,

                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscureTextSenha = !obscureTextSenha;
                                  });
                                },
                                icon: Icon(
                                  obscureTextSenha
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                              ),
                            ),

                            ValidadorSenha(controller: _senhaController),

                            SizedBox(height: 4),

                            CampoTexto(
                              label: "Confirmar Senha",
                              hintText: "Repita sua senha",
                              keyboardType: TextInputType.text,
                              obscureText: obscureTextConfirma,
                              controller: _confirmaController,

                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Confirme sua senha";
                                }
                                if (value != _senhaController.text) {
                                  return "As senhas não coincidem";
                                }
                                return null;
                              },

                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscureTextConfirma = !obscureTextConfirma;
                                  });
                                },
                                icon: Icon(
                                  obscureTextConfirma
                                      ? Icons.visibility_off
                                      : Icons.visibility,
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

                      onPressed: _carregando ? null : _trocarSenha,

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
                              "Salvar",
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
