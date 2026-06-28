import 'package:espectrum_front/View/Pages/tela_trocar_senha.dart';
import 'package:espectrum_front/View/Widgets/app_bar_padrao.dart';
import 'package:flutter/material.dart';

import '../../Services/UsuarioServiceTrocarSenha.dart';
import '../Widgets/drawer_padrao.dart';
import '../Widgets/fundo_botão.dart';
import '../Widgets/roda_pe.dart';
import '../Widgets/widget_input_acesso.dart';

class TelaValidarToken extends StatefulWidget {
  final String email; // recebido da tela de verificação de email

  const TelaValidarToken({super.key, required this.email});

  @override
  State<TelaValidarToken> createState() => _TelaValidarTokenState();
}

class _TelaValidarTokenState extends State<TelaValidarToken> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  bool _carregando = false;
  bool _reenviando = false;

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _validarToken() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    try {
      await UsuarioServiceTrocarSenha.validarToken(
        email: widget.email,
        token: _tokenController.text.trim(),
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TelaTrocarSenha(
            email: widget.email,
            token: _tokenController.text.trim(),
          ),
        ),
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

  Future<void> _reenviarCodigo() async {
    setState(() => _reenviando = true);

    try {
      await UsuarioServiceTrocarSenha.solicitarReset(widget.email);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Código reenviado para ${widget.email}')),
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
      if (mounted) setState(() => _reenviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBarPadrao(nome: 'Verificar Código'),
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
                    Icons.mark_email_read,
                    size: 60,
                    color: Theme.of(context).colorScheme.primary,
                  ),

                  SizedBox(height: 12),

                  Text(
                    "Enviamos um código de 6 dígitos para ${widget.email}. Digite-o abaixo para continuar.",
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

                        child: CampoTexto(
                          label: "Código",
                          hintText: "Digite o código recebido",
                          keyboardType: TextInputType.text,
                          controller: _tokenController,
                          maxLines: 1,

                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Digite o código recebido";
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

                      onPressed: _carregando ? null : _validarToken,

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

                  TextButton(
                    onPressed: _reenviando ? null : _reenviarCodigo,
                    child: _reenviando
                        ? SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text("Reenviar código"),
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
