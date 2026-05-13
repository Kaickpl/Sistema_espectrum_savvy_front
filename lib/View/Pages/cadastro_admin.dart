import 'package:espectrum_front/View/Widgets/categoria_atributos.dart';
import 'package:espectrum_front/View/Widgets/logo_container.dart';
import 'package:espectrum_front/View/Widgets/roda_pe.dart';
import 'package:flutter/material.dart';
import '../Widgets/app_bar_padrao.dart';
import '../Widgets/widget_termo_uso_privacidade.dart';
import '../Widgets/widget_input_acesso.dart';

class CadastroAdmin extends StatefulWidget {
  const CadastroAdmin({super.key});

  @override
  State<CadastroAdmin> createState() => _CadastroAdminState();
}

class _CadastroAdminState extends State<CadastroAdmin> {
  final _formKey = GlobalKey<FormState>();
  bool obscureTextSenha = true;
  bool obscureTextConfirma = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBarPadrao(nome: "Cadastro Administrador"),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LogoContainer(nomePage: 'Cadastro Administrador'),
                    SizedBox(height: 12),
                    CategoriaAtributos(nome: "Dados Administrador",icone: Icons.person,),
                    SizedBox(height: 12,),
                    CampoTexto(
                      label: "Nome Completo",
                      hintText: "Digite seu nome completo",
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Digite seu nome";
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
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
                      label: "Número de Telefone",
                      hintText: "(11) 99999-9999",
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "O campo número não pode ser vazio";
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    CampoTexto(
                      label: "CPF",
                      hintText: "000.000.000-00",
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Digite seu CPF";
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    CampoTexto(
                      label: "CRP (Conselho Regional de Psicologia)",
                      hintText: "00/00000",
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Digite seu CRP";
                        return null;
                      },
                    ),
                    SizedBox(height: 8),
                    CampoTexto(
                      label: "Matrícula",
                      hintText: "Digite sua matrícula",
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Digite sua matrícula";
                        return null;
                      },
                    ),
                    SizedBox(height: 8),

                    CampoTexto(
                      label: "Senha",
                      hintText: "Digite sua senha",
                      keyboardType: TextInputType.text,
                      obscureText: obscureTextSenha,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Digite sua senha";
                        return null;
                      },
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
                    SizedBox(height: 8),

                    CampoTexto(
                      label: "Confirmar Senha",
                      hintText: "Repita sua senha",
                      keyboardType: TextInputType.text,
                      obscureText: obscureTextConfirma,
                      validator: (value) {
                        if (value == null || value.isEmpty) return "Confirme sua senha";
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
                    SizedBox(height: 16),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80),
                      child: ConteinerTermoDeUsoPrivacidade(),
                    ),
                    SizedBox(height: 8),
                    RodaPe(),
                  ],
                ),
              ),
            ),
          ),
      );
  }
}