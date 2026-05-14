import 'package:espectrum_front/View/Pages/tela_perfis.dart';
import 'package:espectrum_front/View/Pages/tela_trocar_senha.dart';
import 'package:espectrum_front/View/Widgets/widget_termo_uso_privacidade.dart';
import 'package:espectrum_front/View/Widgets/fundo_bot%C3%A3o.dart';
import 'package:flutter/material.dart';
import '../Widgets/fundo_tela.dart';
import '../Widgets/logo_container.dart';
import '../Widgets/roda_pe.dart';
import '../Widgets/widget_input_acesso.dart';

class PaginaInicial extends StatefulWidget {
  const PaginaInicial({super.key});

  @override
  State<PaginaInicial> createState() => _PaginaInicialState();
}

class _PaginaInicialState extends State<PaginaInicial> {
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;

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
                    LogoContainer(nomePage: "Sistema de Gestão Terapêutica"),

                    SizedBox(height: 15),

                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      decoration: BoxDecoration(
                        color: Colors.white,
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
                                label: "Email",
                                hintText: "Digite seu email",
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) return "Digite seu email";
                                  if (!value.contains("@")) return "Email inválido";
                                  return null;
                                },
                              ),
                              SizedBox(height: 8),
                              CampoTexto(
                                label: "Senha",
                                hintText: "Digite sua senha",
                                keyboardType: TextInputType.text,
                                obscureText: obscureText,
                                validator: (valueSenha) {
                                  if (valueSenha == null || valueSenha.isEmpty) return "Digite seu email";
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
                                              const TrocarSenha(),
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
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          //Navigator.push(context, MaterialPageRoute(builder: (context)=> const Home());
                                        }
                                      },
                                      child: Text(
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

                              Center(child: Text("ou")),

                              SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.g_mobiledata,
                                    size: 30,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                                  label: Text(
                                    "Entrar com o Google",
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
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
                                      color: Theme.of(context).colorScheme.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
