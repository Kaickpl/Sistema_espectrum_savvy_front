import 'package:espectrum_front/Model/ApiExceptionModel.dart';
import 'package:espectrum_front/Model/Enum/GrauAutismo.dart';
import 'package:espectrum_front/Model/PacienteDetalheModel.dart';
import 'package:espectrum_front/Services/PacienteService.dart';
import 'package:espectrum_front/Services/TokenStorage.dart';
import 'package:flutter/material.dart';

import '../Widgets/app_bar_padrao.dart';
import '../Widgets/categoria_input.dart';
import '../Widgets/responsive_form_container.dart';
import '../Widgets/roda_pe.dart';
import '../Widgets/widget_input_acesso.dart';

/// Tela de edição de um paciente já cadastrado. Carrega os dados atuais
/// via [PacienteService.buscarPaciente] e salva as alterações via
/// [PacienteService.editarPaciente]. Some paciente e endereço reaproveitam
/// os mesmos campos do cadastro (CadastroPaciente).
class TelaEditarPaciente extends StatefulWidget {
  final String pacienteId;

  const TelaEditarPaciente({super.key, required this.pacienteId});

  @override
  State<TelaEditarPaciente> createState() => _TelaEditarPacienteState();
}

class _TelaEditarPacienteState extends State<TelaEditarPaciente> {
  final _formKey = GlobalKey<FormState>();
  bool _carregando = true;
  bool _salvando = false;
  String? _erro;

  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _dataNascimentoController = TextEditingController();
  DateTime? _dataNascimentoSelecionada;

  final _cepController = TextEditingController();
  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();

  String? _generoSelecionado;
  final List<String> _generos = ['Masculino', 'Feminino', 'Outro'];

  GrauAutismo? _grauAutismoSelecionado;

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

  @override
  void initState() {
    super.initState();
    _carregarPaciente();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _dataNascimentoController.dispose();
    _cepController.dispose();
    _ruaController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
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

  Future<void> _carregarPaciente() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final token = await TokenStorage.lerToken();
      final paciente = await PacienteService.buscarPaciente(
        token ?? '',
        widget.pacienteId,
      );
      _preencherFormulario(paciente);
    } on ApiException catch (e) {
      setState(() => _erro = e.message);
    } catch (_) {
      setState(() => _erro = "Não foi possível carregar os dados do paciente.");
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _preencherFormulario(PacienteDetalheModel paciente) {
    _nomeController.text = paciente.nome;
    _cpfController.text = paciente.cpf ?? '';
    _generoSelecionado = _generos.contains(paciente.genero)
        ? paciente.genero
        : null;
    _grauAutismoSelecionado = paciente.grau;

    final nascimento = paciente.dataNascimento;
    if (nascimento != null) {
      _dataNascimentoSelecionada = nascimento;
      _dataNascimentoController.text =
          "${nascimento.day.toString().padLeft(2, '0')}/"
          "${nascimento.month.toString().padLeft(2, '0')}/"
          "${nascimento.year}";
    }

    final endereco = paciente.endereco;
    if (endereco != null) {
      _cepController.text = endereco.cep;
      _ruaController.text = endereco.rua;
      _numeroController.text = endereco.numero;
      _complementoController.text = endereco.complemento ?? '';
      _bairroController.text = endereco.bairro;
      _cidadeController.text = endereco.cidade;
      _estadoSelecionado = _estados.contains(endereco.estado)
          ? endereco.estado
          : null;
    }
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dataNascimentoSelecionada == null) {
      _mostrarSnack(
        "Selecione a data de nascimento",
        Theme.of(context).colorScheme.error,
      );
      return;
    }

    setState(() => _salvando = true);
    try {
      final token = await TokenStorage.lerToken();
      final data = _dataNascimentoSelecionada!;
      final dataFormatada =
          "${data.year.toString().padLeft(4, '0')}-"
          "${data.month.toString().padLeft(2, '0')}-"
          "${data.day.toString().padLeft(2, '0')}";

      await PacienteService.editarPaciente(
        token: token ?? '',
        idPaciente: widget.pacienteId,
        dados: {
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
      _mostrarSnack("Paciente atualizado com sucesso!", Colors.green);
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      _mostrarSnack(e.message, Theme.of(context).colorScheme.error);
    } catch (_) {
      _mostrarSnack(
        "Não foi possível conectar ao servidor. Tente novamente.",
        Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBarPadrao(nome: "Editar Paciente"),
      body: SafeArea(
        bottom: false,
        child: _carregando
            ? const Center(child: CircularProgressIndicator())
            : _erro != null
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    _erro!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              )
            : SingleChildScrollView(
                child: ResponsiveFormContainer(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildSectionHeader(
                          context,
                          "Dados do Paciente",
                          Icons.person,
                        ),
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
                          maxLines: 1,
                        ),
                        const SizedBox(height: 12),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.055,
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSecondary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _dataNascimentoController,
                                  readOnly: true,
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSecondary,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "00/00/0000",
                                    filled: true,
                                    fillColor: Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainer,
                                    suffixIcon: const Icon(
                                      Icons.calendar_month,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
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
                                      initialDate:
                                          _dataNascimentoSelecionada ??
                                          DateTime.now(),
                                      firstDate: DateTime(1900),
                                      lastDate: DateTime.now(),
                                      locale: const Locale('pt', 'BR'),
                                    );
                                    if (pickedDate != null) {
                                      setState(() {
                                        _dataNascimentoSelecionada = pickedDate;
                                        _dataNascimentoController.text =
                                            "${pickedDate.day.toString().padLeft(2, '0')}/"
                                            "${pickedDate.month.toString().padLeft(2, '0')}/"
                                            "${pickedDate.year}";
                                      });
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.055,
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSecondary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  value: _generoSelecionado,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainer,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 14,
                                    ),
                                  ),
                                  items: _generos
                                      .map(
                                        (g) => DropdownMenuItem(
                                          value: g,
                                          child: Text(g),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) => setState(
                                    () => _generoSelecionado = value,
                                  ),
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
                        const SizedBox(height: 12),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.055,
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
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSecondary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<GrauAutismo>(
                                  value: _grauAutismoSelecionado,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Theme.of(
                                      context,
                                    ).colorScheme.surfaceContainer,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 14,
                                    ),
                                  ),
                                  items: GrauAutismo.values
                                      .map(
                                        (g) => DropdownMenuItem(
                                          value: g,
                                          child: Text(
                                            g.displayName,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (value) => setState(
                                    () => _grauAutismoSelecionado = value,
                                  ),
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
                        const SizedBox(height: 24),

                        _buildSectionHeader(
                          context,
                          "Endereço",
                          Icons.location_on,
                        ),
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

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.055,
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

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.055,
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
                                Flexible(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                      DropdownButtonFormField<String>(
                                        value: _estadoSelecionado,
                                        isExpanded: true,
                                        hint: const Text("UF"),
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Theme.of(
                                            context,
                                          ).colorScheme.surfaceContainer,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 12,
                                                vertical: 14,
                                              ),
                                        ),
                                        items: _estados
                                            .map(
                                              (uf) => DropdownMenuItem(
                                                value: uf,
                                                child: Text(uf),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) => setState(
                                          () => _estadoSelecionado = value,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Selecione";
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            ElevatedButton(
                              onPressed: _salvando ? null : _salvar,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.primary,
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
                              child: _salvando
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onPrimary,
                                      ),
                                    )
                                  : const Text(
                                      "Salvar Alterações",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
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
      ),
    );
  }

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
