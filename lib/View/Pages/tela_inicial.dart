import 'package:espectrum_front/Config/formatador_telefone.dart';
import 'package:espectrum_front/Model/ApiExceptionModel.dart';
import 'package:espectrum_front/View/Pages/tela_perfis_cadatro.dart';
import 'package:espectrum_front/View/Pages/tela_verificar_email.dart';
import 'package:espectrum_front/View/Widgets/fundo_bot%C3%A3o.dart';
import 'package:flutter/material.dart';
import '../../Services/AuthService.dart';
import '../Widgets/fundo_tela.dart';
import '../Widgets/logo_container.dart';
import '../Widgets/paginaHomePorPerfil.dart';
import '../Widgets/roda_pe.dart';
import '../Widgets/widget_input_acesso.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool obscureText = true;
  bool _carregando = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
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

  Future<void> _fazerLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);
    try {
      final textoLogin = _emailController.text.trim();
      final loginNormalizado = textoLogin.contains("@")
          ? textoLogin
          : FormatadorTelefone.apenasDigitos(textoLogin);

      final login = await AuthService.login(
        loginNormalizado,
        _senhaController.text,
      );

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => paginaHomePorPerfil(login.perfil)),
        (route) => false,
      );
    } on ApiException catch (e) {
      _mostrarSnack(e.message, Theme.of(context).colorScheme.error);
    } catch (_) {
      _mostrarSnack(
        "Não foi possível conectar ao servidor. Tente novamente.",
        Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FundoTela(
        child: SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LogoContainer(
                      nomePage: "Sistema de Gestão Terapêutica",
                      imagem: "assets/Images/Logo.png",
                    ),

                    SizedBox(height: 15),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 400),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onPrimary,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(24),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                    ),
                                  ),

                                  SizedBox(height: 20),

                                  CampoTexto(
                                    label: "Email ou telefone",
                                    hintText: "Digite seu email ou telefone",
                                    keyboardType: TextInputType.text,
                                    controller: _emailController,
                                    validator: (value) {
                                      if (value == null ||
                                          value.trim().isEmpty) {
                                        return "Digite seu email ou telefone";
                                      }
                                      final texto = value.trim();
                                      final pareceEmail = texto.contains("@");
                                      final apenasDigitos = texto.replaceAll(
                                        RegExp(r'[^0-9]'),
                                        '',
                                      );
                                      final pareceTelefone =
                                          apenasDigitos.length >= 10;
                                      if (!pareceEmail && !pareceTelefone) {
                                        return "Digite um email ou telefone válido";
                                      }
                                      return null;
                                    },
                                    maxLines: 1,
                                  ),
                                  SizedBox(height: 8),
                                  CampoTexto(
                                    label: "Senha",
                                    hintText: "Digite sua senha",
                                    keyboardType: TextInputType.text,
                                    obscureText: obscureText,
                                    controller: _senhaController,
                                    validator: (valueSenha) {
                                      if (valueSenha == null ||
                                          valueSenha.isEmpty)
                                        return "Digite sua senha";
                                      return null;
                                    },
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          obscureText = !obscureText;
                                        });
                                      },
                                      icon: Icon(
                                        obscureText
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                    ),
                                    maxLines: 1,
                                  ),

                                  SizedBox(height: 15),

                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TelaVerificarEmail(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "Esqueci minha senha",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 20),
                                      FundoBotao(
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 25,
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: _carregando
                                              ? null
                                              : _fazerLogin,
                                          child: _carregando
                                              ? SizedBox(
                                                  width: 18,
                                                  height: 18,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Theme.of(
                                                          context,
                                                        ).colorScheme.onPrimary,
                                                      ),
                                                )
                                              : Text(
                                                  "Entrar",
                                                  style: TextStyle(
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.onPrimary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10),

                                  SizedBox(width: double.infinity, height: 40),
                                  Center(child: Text("Não tem conta ?")),
                                  Center(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const TelaCadastro(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        "Criar conta",
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    RodaPe(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
