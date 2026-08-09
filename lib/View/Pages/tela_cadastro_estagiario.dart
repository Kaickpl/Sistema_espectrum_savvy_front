import 'package:espectrum_front/Config/formatador_telefone.dart';
import 'package:espectrum_front/Model/ApiExceptionModel.dart';
import 'package:espectrum_front/View/Pages/tela_inicial.dart';
import 'package:espectrum_front/View/Widgets/categoria_input.dart';
import 'package:espectrum_front/View/Widgets/logo_container.dart';
import 'package:espectrum_front/View/Widgets/responsive_form_container.dart';
import 'package:espectrum_front/View/Widgets/roda_pe.dart';
import 'package:flutter/material.dart';
import '../../Services/TerapeutaService.dart';
import '../../Services/TokenStorage.dart';
import '../Widgets/app_bar_padrao.dart';
import '../Widgets/widget_termo_uso_privacidade.dart';
import '../Widgets/widget_input_acesso.dart';
import '../Widgets/ValidadorSenha.dart';

class CadastroEstagiario extends StatefulWidget {
  /// Se true, cadastro feito por admin autenticado (sem código de convite).
  final bool modoAdmin;

  const CadastroEstagiario({super.key, this.modoAdmin = false});

  @override
  State<CadastroEstagiario> createState() => _CadastroEstagiarioState();
}

class _CadastroEstagiarioState extends State<CadastroEstagiario> {
  final _formKey = GlobalKey<FormState>();
  bool obscureTextSenha = true;
  bool obscureTextConfirma = true;
  bool _carregando = false;
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _matriculaController = TextEditingController();
  final _codigoConviteController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmaController = TextEditingController();

  // ── Período selecionado no dropdown ─────────────────────
  String? _periodoSelecionado;

  final List<String> _periodos = [
    '1º Período',
    '2º Período',
    '3º Período',
    '4º Período',
    '5º Período',
    '6º Período',
    '7º Período',
    '8º Período',
    '9º Período',
    '10º Período',
    'Despriorizado',
  ];
  // ────────────────────────────────────────────────────────

  int _periodoParaInt(String periodo) {
    final match = RegExp(r'^(\d+)').firstMatch(periodo);
    return match != null ? int.parse(match.group(1)!) : 0;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();
    _matriculaController.dispose();
    _codigoConviteController.dispose();
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
      final periodo = _periodoParaInt(_periodoSelecionado!);

      if (widget.modoAdmin) {
        final token = await TokenStorage.lerToken();
        await TerapeutaService.cadastroPeloAdmin(
          token: token ?? '',
          nome: _nomeController.text.trim(),
          email: _emailController.text.trim(),
          numeroTelefone: FormatadorTelefone.apenasDigitos(
            _telefoneController.text,
          ),
          senha: _senhaController.text,
          cpf: _cpfController.text.trim(),
          matricula: _matriculaController.text.trim(),
          periodo: periodo,
        );

        if (!mounted) return;
        _mostrarSnack("Estagiário cadastrado com sucesso!", Colors.green);
        Navigator.pop(context);
      } else {
        await TerapeutaService.autoCadastro(
          nome: _nomeController.text.trim(),
          email: _emailController.text.trim(),
          numeroTelefone: FormatadorTelefone.apenasDigitos(
            _telefoneController.text,
          ),
          senha: _senhaController.text,
          cpf: _cpfController.text.trim(),
          matricula: _matriculaController.text.trim(),
          periodo: periodo,
          codigoConvite: _codigoConviteController.text.trim(),
        );

        if (!mounted) return;
        _mostrarSnack(
          "Cadastro realizado! Aguarde a aprovação do administrador para fazer login.",
          Colors.green,
        );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const PaginaInicial()),
          (route) => false,
        );
      }
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
      appBar: AppBarPadrao(nome: "Cadastro"),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: ResponsiveFormContainer(
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
                    controller: _nomeController,
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
                    controller: _emailController,
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
                    controller: _telefoneController,
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
                    controller: _cpfController,
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
                    controller: _matriculaController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "O campo não pode ser vazio";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  if (!widget.modoAdmin) ...[
                    CampoTexto(
                      label: "Código de Convite",
                      hintText: "Digite o código fornecido pelo administrador",
                      keyboardType: TextInputType.text,
                      controller: _codigoConviteController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "O código de convite é obrigatório";
                        }
                        return null;
                      },
                      maxLines: 1,
                    ),
                    const SizedBox(height: 12),
                  ],

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
                            fillColor: Theme.of(
                              context,
                            ).colorScheme.surfaceContainer,
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
                                color: Theme.of(
                                  context,
                                ).scaffoldBackgroundColor,
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
                    maxLines: 1,
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
                    maxLines: 1,
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
                    onPressed: _carregando ? null : _cadastrar,
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
                  const SizedBox(height: 12),

                  const RodaPe(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
