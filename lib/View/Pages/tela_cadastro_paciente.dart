import 'package:espectrum_front/Config/formatador_telefone.dart';
import 'package:espectrum_front/Model/ApiExceptionModel.dart';
import 'package:espectrum_front/Model/Enum/GrauAutismo.dart';
import 'package:flutter/material.dart';

import '../../Services/PacienteService.dart';
import '../../Services/TokenStorage.dart';
import '../Widgets/app_bar_padrao.dart';
import '../Widgets/categoria_input.dart';
import '../Widgets/logo_container.dart';
import '../Widgets/roda_pe.dart';
import '../Widgets/widget_input_acesso.dart';
import '../Widgets/widget_termo_uso_privacidade.dart';

class CadastroPaciente extends StatefulWidget {
  const CadastroPaciente({super.key});

  @override
  State<CadastroPaciente> createState() => _CadastroPacienteState();
}

class _CadastroPacienteState extends State<CadastroPaciente> {
  final _formKey = GlobalKey<FormState>();
  bool _carregando = false;

  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final TextEditingController dataNascimentoController =
      TextEditingController();
  DateTime? _dataNascimentoSelecionada;

  final _cepController = TextEditingController();
  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();

  final _nomeResponsavelController = TextEditingController();
  final _cpfResponsavelController = TextEditingController();
  final _telefoneResponsavelController = TextEditingController();
  final _emailResponsavelController = TextEditingController();
  final _grauParentescoController = TextEditingController();

  // ── Gênero selecionado no dropdown ──────────────────────
  String? _generoSelecionado;

  final List<String> _generos = ['Masculino', 'Feminino', 'Outro'];
  // ────────────────────────────────────────────────────────

  // ── Grau de autismo selecionado no dropdown ─────────────
  GrauAutismo? _grauAutismoSelecionado;
  // ────────────────────────────────────────────────────────

  // ── Estado selecionado no dropdown ──────────────────────
  String? _estadoSelecionado;

  final List<String> _estados = [
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO',
  ];
  // ────────────────────────────────────────────────────────

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    dataNascimentoController.dispose();
    _cepController.dispose();
    _ruaController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _nomeResponsavelController.dispose();
    _cpfResponsavelController.dispose();
    _telefoneResponsavelController.dispose();
    _emailResponsavelController.dispose();
    _grauParentescoController.dispose();
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
      final token = await TokenStorage.lerToken();
      final data = _dataNascimentoSelecionada!;
      final dataFormatada =
          "${data.year.toString().padLeft(4, '0')}-"
          "${data.month.toString().padLeft(2, '0')}-"
          "${data.day.toString().padLeft(2, '0')}";

      await PacienteService.cadastrarPacienteEResponsavel(
        token: token ?? '',
        numeroTelefone: FormatadorTelefone.apenasDigitos(
          _telefoneResponsavelController.text,
        ),
        cpfResponsavel: _cpfResponsavelController.text.trim(),
        nomeResponsavel: _nomeResponsavelController.text.trim(),
        emailResponsavel: _emailResponsavelController.text.trim().isEmpty
            ? null
            : _emailResponsavelController.text.trim(),
        grauParentesco: _grauParentescoController.text.trim().isEmpty
            ? null
            : _grauParentescoController.text.trim(),
        infosPaciente: {
          'nome': _nomeController.text.trim(),
          'dataNascimento': dataFormatada,
          'genero': _generoSelecionado,
          'cpf': _cpfController.text.trim(),
          'grauAutismo': _grauAutismoSelecionado!.backendValue,
          'endereco': {
            'cep': _cepController.text.trim(),
            'rua': _ruaController.text.trim(),
            'numero': _numeroController.text.trim(),
            'complemento': _complementoController.text.trim(),
            'bairro': _bairroController.text.trim(),
            'cidade': _cidadeController.text.trim(),
            'estado': _estadoSelecionado,
          },
        },
      );

      if (!mounted) return;
      _mostrarSnack("Paciente cadastrado com sucesso!", Colors.green);
      Navigator.pop(context);
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
      appBar: AppBarPadrao(nome: "Cadastro de Paciente"),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                LogoContainer(
                  nomePage: "Cadastro de Paciente",
                  imagem: "assets/Images/Logo.png",
                ),

                const SizedBox(height: 20),

                // ── Seção: Dados do Paciente ──────────────────────────────
                _buildSectionHeader(context, "Dados do Paciente", Icons.person),
                const SizedBox(height: 12),

                CampoTexto(
                  label: "Nome Completo",
                  hintText: "Digite o nome completo",
                  keyboardType: TextInputType.name,
                  controller: _nomeController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "O campo não pode ser vazio";
                    }
                    return null;
                  },
                  maxLines: 1,
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
                  maxLines: 1,
                ),
                const SizedBox(height: 12),

                // ── Campo Data de Nascimento ──────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.055,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 355),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Data de Nascimento",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        DecoratedBox(
                          decoration: const BoxDecoration(),
                          child: TextFormField(
                            controller: dataNascimentoController,
                            readOnly: true,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                            decoration: InputDecoration(
                              hintText: "00/00/0000",
                              hintStyle: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                              ),
                              filled: true,
                              fillColor: Theme.of(
                                context,
                              ).colorScheme.surfaceContainer,
                              suffixIcon: const Icon(Icons.calendar_month),
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
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Selecione a data";
                              }
                              return null;
                            },
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                                locale: const Locale('pt', 'BR'),
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                        onPrimary: Colors.white,
                                        onSurface: Theme.of(
                                          context,
                                        ).colorScheme.onSurface,
                                        surface: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                      dialogTheme: DialogThemeData(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
                                        ),
                                        elevation: 8,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );

                              if (pickedDate != null) {
                                setState(() {
                                  _dataNascimentoSelecionada = pickedDate;
                                  dataNascimentoController.text =
                                      "${pickedDate.day.toString().padLeft(2, '0')}/"
                                      "${pickedDate.month.toString().padLeft(2, '0')}/"
                                      "${pickedDate.year}";
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ─────────────────────────────────────────────────────────
                const SizedBox(height: 12),

                // ── Campo Gênero ───────────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.055,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 355),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Gênero",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<String>(
                          value: _generoSelecionado,
                          isExpanded: true,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          hint: Text(
                            "Selecione o gênero",
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
                          items: _generos.map((String genero) {
                            return DropdownMenuItem<String>(
                              value: genero,
                              child: Text(genero),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _generoSelecionado = value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Selecione o gênero";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // ─────────────────────────────────────────────────────────
                const SizedBox(height: 12),

                // ── Campo Grau de Autismo ─────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.055,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 355),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Grau de Autismo",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        DropdownButtonFormField<GrauAutismo>(
                          value: _grauAutismoSelecionado,
                          isExpanded: true,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                          hint: Text(
                            "Selecione o grau de autismo",
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
                          items: GrauAutismo.values.map((GrauAutismo grau) {
                            return DropdownMenuItem<GrauAutismo>(
                              value: grau,
                              child: Text(
                                grau.displayName,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _grauAutismoSelecionado = value);
                          },
                          validator: (value) {
                            if (value == null) {
                              return "Selecione o grau de autismo";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // ─────────────────────────────────────────────────────────
                const SizedBox(height: 24),

                // ── Seção: Endereço ───────────────────────────────────────
                _buildSectionHeader(context, "Endereço", Icons.location_on),
                const SizedBox(height: 12),

                CampoTexto(
                  label: "CEP",
                  hintText: "00000-000",
                  keyboardType: TextInputType.number,
                  controller: _cepController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Digite o CEP";
                    }
                    return null;
                  },
                  maxLines: 1,
                ),
                const SizedBox(height: 12),

                CampoTexto(
                  label: "Rua",
                  hintText: "Nome da rua",
                  keyboardType: TextInputType.streetAddress,
                  controller: _ruaController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "O campo não pode ser vazio";
                    }
                    return null;
                  },
                  maxLines: 1,
                ),
                const SizedBox(height: 12),

                // ── Número + Complemento ──────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.055,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 355),
                    child: Row(
                      children: [
                        Flexible(
                          flex: 2,
                          child: CampoTexto(
                            label: "Número",
                            hintText: "123",
                            keyboardType: TextInputType.number,
                            controller: _numeroController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Obrigatório";
                              }
                              return null;
                            },
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          flex: 3,
                          child: CampoTexto(
                            label: "Complemento",
                            hintText: "Apto, bloco... (opcional)",
                            keyboardType: TextInputType.text,
                            controller: _complementoController,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                CampoTexto(
                  label: "Bairro",
                  hintText: "Nome do bairro",
                  keyboardType: TextInputType.text,
                  controller: _bairroController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Digite o bairro";
                    }
                    return null;
                  },
                  maxLines: 1,
                ),
                const SizedBox(height: 12),

                // ── Cidade + Estado ───────────────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.055,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 355),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          flex: 3,
                          child: CampoTexto(
                            label: "Cidade",
                            hintText: "Nome da cidade",
                            keyboardType: TextInputType.text,
                            controller: _cidadeController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Digite a cidade";
                              }
                              return null;
                            },
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: 12),

                        // ── Dropdown Estado ───────────────────────────────
                        Flexible(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Estado",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              DecoratedBox(
                                decoration: const BoxDecoration(),
                                child: DropdownButtonFormField<String>(
                                  value: _estadoSelecionado,
                                  isExpanded: true,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSecondary,
                                  ),
                                  hint: Text(
                                    "UF",
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSecondary,
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
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                      ),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.error,
                                        width: 1.5,
                                      ),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 14,
                                    ),
                                  ),
                                  items: _estados.map((String uf) {
                                    return DropdownMenuItem<String>(
                                      value: uf,
                                      child: Text(uf),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() => _estadoSelecionado = value);
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Selecione";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ─────────────────────────────────────────────────
                      ],
                    ),
                  ),
                ),

                // ─────────────────────────────────────────────────────────
                const SizedBox(height: 24),

                // ── Seção: Dados do Responsável ───────────────────────────
                _buildSectionHeader(
                  context,
                  "Dados do Responsável",
                  Icons.supervisor_account,
                ),
                const SizedBox(height: 12),

                CampoTexto(
                  label: "Nome do Responsável",
                  hintText: "Nome completo do responsável",
                  keyboardType: TextInputType.name,
                  controller: _nomeResponsavelController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "O campo não pode ser vazio";
                    }
                    return null;
                  },
                  maxLines: 1,
                ),
                const SizedBox(height: 12),

                CampoTexto(
                  label: "CPF do Responsável",
                  hintText: "000.000.000-00",
                  keyboardType: TextInputType.number,
                  controller: _cpfResponsavelController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "O campo não pode ser vazio";
                    }
                    return null;
                  },
                  maxLines: 1,
                ),
                const SizedBox(height: 12),

                CampoTexto(
                  label: "Telefone do Responsável",
                  hintText: "(00) 00000-0000",
                  keyboardType: TextInputType.phone,
                  controller: _telefoneResponsavelController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "O campo não pode ser vazio";
                    }
                    return null;
                  },
                  maxLines: 1,
                ),
                const SizedBox(height: 12),

                CampoTexto(
                  label: "Email (opcional)",
                  hintText: "Digite o email",
                  keyboardType: TextInputType.emailAddress,
                  controller: _emailResponsavelController,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    if (!value.contains("@")) return "Email inválido";
                    return null;
                  },
                  maxLines: 1,
                ),
                const SizedBox(height: 12),

                CampoTexto(
                  label: "Grau de Parentesco",
                  hintText: "Ex: Mãe, Pai, Tutor legal",
                  keyboardType: TextInputType.text,
                  controller: _grauParentescoController,
                  maxLines: 1,
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.055,
                  ),
                  child: const ConteinerTermoDeUsoPrivacidade(),
                ),

                const SizedBox(height: 24),

                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton(
                      onPressed: _carregando ? null : _cadastrar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
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
                              "Salvar Cadastro",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onPrimary,
                              ),
                            ),
                    ),
                    OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const RodaPe(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper para o cabeçalho de cada seção — evita repetição de código
  Widget _buildSectionHeader(
    BuildContext context,
    String nome,
    IconData icone,
  ) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 355),
      child: Align(
        alignment: Alignment.centerLeft,
        child: CategoriaAtributos(nome: nome, icone: icone),
      ),
    );
  }
}
