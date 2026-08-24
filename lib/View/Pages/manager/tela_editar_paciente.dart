import 'package:espectrum_front/Model/ApiExceptionModel.dart';
import 'package:espectrum_front/Model/EnderecoModel.dart';
import 'package:espectrum_front/Model/Enum/GrauAutismo.dart';
import 'package:espectrum_front/Model/PacienteDetalheModel.dart';
import 'package:espectrum_front/Services/PacienteService.dart';
import 'package:espectrum_front/Services/TokenStorage.dart';
import 'package:espectrum_front/View/Widgets/app_bar_padrao.dart';
import 'package:espectrum_front/View/Widgets/responsive_form_container.dart';
import 'package:espectrum_front/View/Widgets/roda_pe.dart';
import 'package:espectrum_front/View/Widgets/widget_input_acesso.dart';
import 'package:flutter/material.dart';

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
  bool _dadosAlterados = false;

  PacienteDetalheModel? _pacienteAtual;

  bool _editandoDados = false;
  bool _editandoEndereco = false;

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

  String _formatarData(DateTime data) {
    return "${data.day.toString().padLeft(2, '0')}/"
        "${data.month.toString().padLeft(2, '0')}/"
        "${data.year}";
  }

  String _iniciais(String nome) {
    final partes = nome
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (partes.isEmpty) return "?";
    if (partes.length == 1) return partes.first.substring(0, 1).toUpperCase();
    return (partes.first.substring(0, 1) + partes.last.substring(0, 1))
        .toUpperCase();
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
      _pacienteAtual = paciente;
      _preencherFormularioDados(paciente);
      _preencherFormularioEndereco(paciente.endereco);
    } on ApiException catch (e) {
      setState(() => _erro = e.message);
    } catch (_) {
      setState(() => _erro = "Não foi possível carregar os dados do paciente.");
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _preencherFormularioDados(PacienteDetalheModel paciente) {
    _nomeController.text = paciente.nome;
    _cpfController.text = paciente.cpf ?? '';
    _generoSelecionado = _generos.contains(paciente.genero)
        ? paciente.genero
        : null;
    _grauAutismoSelecionado = paciente.grau;

    final nascimento = paciente.dataNascimento;
    if (nascimento != null) {
      _dataNascimentoSelecionada = nascimento;
      _dataNascimentoController.text = _formatarData(nascimento);
    }
  }

  void _preencherFormularioEndereco(EnderecoModel? endereco) {
    if (endereco == null) return;
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

  void _cancelarEdicaoDados() {
    if (_pacienteAtual != null) _preencherFormularioDados(_pacienteAtual!);
    setState(() => _editandoDados = false);
  }

  void _cancelarEdicaoEndereco() {
    _preencherFormularioEndereco(_pacienteAtual?.endereco);
    setState(() => _editandoEndereco = false);
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

      final atualizado = await PacienteService.editarPaciente(
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
      setState(() {
        _pacienteAtual = atualizado;
        _dadosAlterados = true;
        _editandoDados = false;
        _editandoEndereco = false;
      });
      _mostrarSnack("Dados atualizados com sucesso!", Colors.green);
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
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) return;
        Navigator.pop(context, _dadosAlterados);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        appBar: AppBarPadrao(nome: "Perfil do Paciente"),
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildCabecalhoPerfil(context, _pacienteAtual!),
                        ResponsiveFormContainer(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                _buildSecaoCard(
                                  context: context,
                                  titulo: "Dados Pessoais",
                                  icone: Icons.person_outline,
                                  editando: _editandoDados,
                                  aoIniciarEdicao: () =>
                                      setState(() => _editandoDados = true),
                                  resumo: _resumoDadosPessoais(
                                    context,
                                    _pacienteAtual!,
                                  ),
                                  formulario: _formularioDadosPessoais(context),
                                  aoCancelar: _cancelarEdicaoDados,
                                ),
                                const SizedBox(height: 16),
                                _buildSecaoCard(
                                  context: context,
                                  titulo: "Endereço",
                                  icone: Icons.location_on_outlined,
                                  editando: _editandoEndereco,
                                  aoIniciarEdicao: () =>
                                      setState(() => _editandoEndereco = true),
                                  resumo: _resumoEndereco(
                                    context,
                                    _pacienteAtual!.endereco,
                                  ),
                                  formulario: _formularioEndereco(context),
                                  aoCancelar: _cancelarEdicaoEndereco,
                                ),
                                const SizedBox(height: 24),
                                const RodaPe(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  // ── Cabeçalho estilo "perfil" ──────────────────────────────────────
  Widget _buildCabecalhoPerfil(
    BuildContext context,
    PacienteDetalheModel paciente,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.onPrimary.withOpacity(0.18),
            child: Text(
              _iniciais(paciente.nome),
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            paciente.nome,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              if (paciente.idade != null)
                _chipPerfil(
                  context,
                  Icons.cake_outlined,
                  "${paciente.idade} anos",
                ),
              _chipPerfil(
                context,
                Icons.psychology_alt_outlined,
                paciente.grau.displayName,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chipPerfil(BuildContext context, IconData icone, String texto) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 14, color: Theme.of(context).colorScheme.onPrimary),
          const SizedBox(width: 6),
          Text(
            texto,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Card de seção (resumo ou formulário de edição) ─────────────────
  Widget _buildSecaoCard({
    required BuildContext context,
    required String titulo,
    required IconData icone,
    required bool editando,
    required VoidCallback aoIniciarEdicao,
    required VoidCallback aoCancelar,
    required Widget resumo,
    required Widget formulario,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onPrimary,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icone,
                size: 20,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                ),
              ),
              if (!editando)
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: "Editar",
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: aoIniciarEdicao,
                ),
            ],
          ),
          const SizedBox(height: 8),
          editando ? formulario : resumo,
          if (editando) ...[
            const SizedBox(height: 16),
            _botoesSecao(context, aoCancelar: aoCancelar, aoSalvar: _salvar),
          ],
        ],
      ),
    );
  }

  Widget _linhaResumo(BuildContext context, String label, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(
                  context,
                ).colorScheme.onSecondary.withOpacity(0.55),
              ),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _botoesSecao(
    BuildContext context, {
    required VoidCallback aoCancelar,
    required VoidCallback aoSalvar,
  }) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _salvando ? null : aoCancelar,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Cancelar",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: _salvando ? null : aoSalvar,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: _salvando
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  )
                : const Text(
                    "Salvar",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ],
    );
  }

  // ── Seção: Dados Pessoais ───────────────────────────────────────────
  Widget _resumoDadosPessoais(BuildContext context, PacienteDetalheModel p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _linhaResumo(
          context,
          "CPF",
          (p.cpf != null && p.cpf!.isNotEmpty) ? p.cpf! : "Não informado",
        ),
        _linhaResumo(
          context,
          "Nascimento",
          p.dataNascimento != null
              ? _formatarData(p.dataNascimento!)
              : "Não informada",
        ),
        _linhaResumo(context, "Gênero", p.genero),
        _linhaResumo(context, "Grau de autismo", p.grau.displayName),
      ],
    );
  }

  Widget _formularioDadosPessoais(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
        ),
        const SizedBox(height: 12),
        CampoTexto(
          label: "CPF",
          hintText: "000.000.000-00",
          keyboardType: TextInputType.number,
          controller: _cpfController,
        ),
        const SizedBox(height: 12),
        _campoDataNascimento(context),
        const SizedBox(height: 12),
        _campoDropdown<String>(
          context: context,
          label: "Gênero",
          hint: "Selecione o gênero",
          valor: _generoSelecionado,
          itens: _generos,
          exibir: (g) => g,
          onChanged: (value) => setState(() => _generoSelecionado = value),
          validator: (value) =>
              (value == null || value.isEmpty) ? "Selecione o gênero" : null,
        ),
        const SizedBox(height: 12),
        _campoDropdown<GrauAutismo>(
          context: context,
          label: "Grau de Autismo",
          hint: "Selecione o grau de autismo",
          valor: _grauAutismoSelecionado,
          itens: GrauAutismo.values,
          exibir: (g) => g.displayName,
          onChanged: (value) => setState(() => _grauAutismoSelecionado = value),
          validator: (value) =>
              value == null ? "Selecione o grau de autismo" : null,
        ),
      ],
    );
  }

  Widget _campoDataNascimento(BuildContext context) {
    return Column(
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
        TextFormField(
          controller: _dataNascimentoController,
          readOnly: true,
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          decoration: InputDecoration(
            hintText: "00/00/0000",
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainer,
            suffixIcon: const Icon(Icons.calendar_month),
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
              initialDate: _dataNascimentoSelecionada ?? DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              locale: const Locale('pt', 'BR'),
            );
            if (pickedDate != null) {
              setState(() {
                _dataNascimentoSelecionada = pickedDate;
                _dataNascimentoController.text = _formatarData(pickedDate);
              });
            }
          },
        ),
      ],
    );
  }

  Widget _campoDropdown<T>({
    required BuildContext context,
    required String label,
    required String hint,
    required T? valor,
    required List<T> itens,
    required String Function(T) exibir,
    required void Function(T?) onChanged,
    required String? Function(T?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          value: valor,
          isExpanded: true,
          hint: Text(
            hint,
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainer,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
          ),
          items: itens
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(exibir(item), overflow: TextOverflow.ellipsis),
                ),
              )
              .toList(),
          onChanged: onChanged,
          validator: validator,
        ),
      ],
    );
  }

  // ── Seção: Endereço ─────────────────────────────────────────────────
  Widget _resumoEndereco(BuildContext context, EnderecoModel? endereco) {
    if (endereco == null || (endereco.rua.isEmpty && endereco.cidade.isEmpty)) {
      return Text(
        "Nenhum endereço cadastrado.",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.6),
        ),
      );
    }
    final linhaLogradouro =
        endereco.complemento != null && endereco.complemento!.isNotEmpty
        ? "${endereco.rua}, ${endereco.numero} - ${endereco.complemento}"
        : "${endereco.rua}, ${endereco.numero}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _linhaResumo(context, "CEP", endereco.cep),
        _linhaResumo(context, "Logradouro", linhaLogradouro),
        _linhaResumo(context, "Bairro", endereco.bairro),
        _linhaResumo(
          context,
          "Cidade/UF",
          "${endereco.cidade}/${endereco.estado}",
        ),
      ],
    );
  }

  Widget _formularioEndereco(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              ),
            ),
          ],
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
        ),
        const SizedBox(height: 12),
        Row(
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
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              flex: 2,
              child: _campoDropdown<String>(
                context: context,
                label: "Estado",
                hint: "UF",
                valor: _estadoSelecionado,
                itens: _estados,
                exibir: (uf) => uf,
                onChanged: (value) =>
                    setState(() => _estadoSelecionado = value),
                validator: (value) =>
                    (value == null || value.isEmpty) ? "Selecione" : null,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
