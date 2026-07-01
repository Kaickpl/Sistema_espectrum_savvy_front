import 'package:espectrum_front/Model/ApiExceptionModel.dart';

import 'package:espectrum_front/View/Pages/home_adm.dart';
import 'package:espectrum_front/View/Widgets/categoria_input.dart';
import 'package:espectrum_front/View/Widgets/logo_container.dart';
import 'package:espectrum_front/View/Widgets/roda_pe.dart';
import 'package:flutter/material.dart';
import '../../Services/AdminService.dart';
import '../../Services/AuthService.dart';
import '../Widgets/app_bar_padrao.dart';
import '../Widgets/widget_termo_uso_privacidade.dart';
import '../Widgets/widget_input_acesso.dart';
import '../Widgets/ValidadorSenha.dart';

class CadastroAdmin extends StatefulWidget {
  const CadastroAdmin({super.key});

  @override
  State<CadastroAdmin> createState() => _CadastroAdminState();
}

class _CadastroAdminState extends State<CadastroAdmin> {
  final _formKey = GlobalKey<FormState>();
  bool obscureTextSenha = true;
  bool obscureTextConfirma = true;
  bool _carregando = false;
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _crpController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmaController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();
    _crpController.dispose();
    _senhaController.dispose();
    _confirmaController.dispose();
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

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);
    try {
      await AdminService.cadastrarAdmin(
        nome: _nomeController.text.trim(),
        email: _emailController.text.trim(),
        numeroTelefone: _telefoneController.text.trim(),
        senha: _senhaController.text,
        cpf: _cpfController.text.trim(),
        registroProfissional: _crpController.text.trim(),
      );

      await AuthService.login(
        _emailController.text.trim(),
        _senhaController.text,
      );

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const HomeAdm()),
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
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBarPadrao(nome: "Cadastro Supervisor de Estágio"),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LogoContainer(
                  nomePage: 'Cadastro Supervisor de Estágio',
                  imagem: "assets/Images/Logo.png",
                ),
                SizedBox(height: 12),
                CategoriaAtributos(
                  nome: "Dados Supervisor de Estágio",
                  icone: Icons.person,
                ),
                SizedBox(height: 12),
                CampoTexto(
                  label: "Nome Completo",
                  hintText: "Digite seu nome completo",
                  keyboardType: TextInputType.name,
                  controller: _nomeController,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Digite seu nome";
                    return null;
                  },
                  maxLines: 1,
                ),
                SizedBox(height: 8),
                CampoTexto(
                  label: "Email",
                  hintText: "Digite seu email",
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "Digite seu email";
                    if (!value.contains("@")) return "Email inválido";
                    return null;
                  },
                  maxLines: 1,
                ),
                SizedBox(height: 8),
                CampoTexto(
                  label: "Número de Telefone",
                  hintText: "(11) 99999-9999",
                  keyboardType: TextInputType.phone,
                  controller: _telefoneController,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return "O campo número não pode ser vazio";
                    return null;
                  },
                  maxLines: 1,
                ),
                SizedBox(height: 8),
                CampoTexto(
                  label: "CPF",
                  hintText: "000.000.000-00",
                  keyboardType: TextInputType.number,
                  controller: _cpfController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Digite seu CPF";
                    return null;
                  },
                  maxLines: 1,
                ),
                SizedBox(height: 12),

                CategoriaAtributos(
                  nome: "Dados Profissionais ",
                  icone: Icons.work,
                ),
                SizedBox(height: 12),

                CampoTexto(
                  label: "CRP (Conselho Regional de Psicologia)",
                  hintText: "00/00000",
                  keyboardType: TextInputType.number,
                  controller: _crpController,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Digite seu CRP";
                    return null;
                  },
                  maxLines: 1,
                ),
                SizedBox(height: 12),

                CategoriaAtributos(
                  nome: "Dados de Seguraça ",
                  icone: Icons.security,
                ),
                SizedBox(height: 12),

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
                  maxLines: 1,
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
                    if (value == null || value.isEmpty)
                      return "Confirme sua senha";
                    if (value != _senhaController.text)
                      return "As senhas não coincidem";
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
                  maxLines: 1,
                ),
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.055,
                  ),
                  child: ConteinerTermoDeUsoPrivacidade(),
                ),

                SizedBox(height: 12),

                SizedBox(
                  child: ElevatedButton(
                    onPressed: _carregando ? null : _cadastrar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 40,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _carregando
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          )
                        : Text(
                            "Cadastrar",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 16),

                RodaPe(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
