import 'package:espectrum_front/View/Pages/home_aluno.dart';
import 'package:espectrum_front/View/Widgets/categoria_input.dart';
import 'package:espectrum_front/View/Widgets/logo_container.dart';
import 'package:espectrum_front/View/Widgets/roda_pe.dart';
import 'package:flutter/material.dart';
import '../Widgets/app_bar_padrao.dart';
import '../Widgets/widget_termo_uso_privacidade.dart';
import '../Widgets/widget_input_acesso.dart';
import '../Widgets/ValidadorSenha.dart';

class CadastroEstagiario extends StatefulWidget {
  const CadastroEstagiario({super.key});

  @override
  State<CadastroEstagiario> createState() => _CadastroEstagiarioState();
}

class _CadastroEstagiarioState extends State<CadastroEstagiario> {
  final _formKey = GlobalKey<FormState>();
  bool obscureTextSenha = true;
  bool obscureTextConfirma = true;
  final _senhaController = TextEditingController();
  final _confirmaController = TextEditingController();

  // ── Período selecionado no dropdown ─────────────────────
  String? _periodoSelecionado;

  final List<String> _periodos = [
    '1º Período', '2º Período', '3º Período', '4º Período', '5º Período',
    '6º Período', '7º Período', '8º Período', '9º Período', '10º Período',
    'Despriorizado',
  ];
  // ────────────────────────────────────────────────────────

  @override
  void dispose() {
    _senhaController.dispose();
    _confirmaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBarPadrao(nome: "Cadastro"),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LogoContainer(
                  nomePage: 'Cadastro Estágiario',
                  imagem: "assets/Images/Logo.png",
                ),
                const SizedBox(height: 12),
                CategoriaAtributos(
                  nome: "Dados Estágiario      ",
                  icone: Icons.person,
                ),
                const SizedBox(height: 12),
                CampoTexto(
                  label: "Nome Completo",
                  hintText: "Digite seu nome completo",
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "O campo não pode ser em branco";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                CampoTexto(
                  label: "Email",
                  hintText: "Digite seu email",
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "O campo não pode ser vazio";
                    }
                    if (!value.contains("@")) return "Email inválido";
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                CampoTexto(
                  label: "Número de Telefone",
                  hintText: "(11) 99999-9999",
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "O campo não pode ser vazio";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                CampoTexto(
                  label: "CPF",
                  hintText: "000.000.000-00",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "O campo não pode ser vazio";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                CategoriaAtributos(
                  nome: "Dados Acadêmicos ",
                  icone: Icons.work,
                ),
                const SizedBox(height: 12),

                CampoTexto(
                  label: "Matrícula",
                  hintText: "Digite sua matrícula",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "O campo não pode ser vazio";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                // ── Dropdown Período ──────────────────────────────────────
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 355),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Período",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: _periodoSelecionado,
                        isExpanded: true,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSecondary,
                          fontSize: 16,
                        ),
                        hint: Text(
                          "Selecione o período",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor:
                          Theme.of(context).colorScheme.surfaceContainer,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              width: 1.5,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.error,
                              width: 1.5,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                        items: _periodos.map((String periodo) {
                          return DropdownMenuItem<String>(
                            value: periodo,
                            child: Text(periodo),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => _periodoSelecionado = value);
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Selecione o período";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                // ─────────────────────────────────────────────────────────

                const SizedBox(height: 12),

                CategoriaAtributos(
                  nome: "Dados de Segurança ",
                  icone: Icons.security,
                ),
                const SizedBox(height: 12),

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
                const SizedBox(height: 4),

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
                const SizedBox(height: 12),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.055,
                  ),
                  child: const ConteinerTermoDeUsoPrivacidade(),
                ),

                const SizedBox(height: 12),

                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomeAluno(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 40,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Cadastrar",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                const RodaPe(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}