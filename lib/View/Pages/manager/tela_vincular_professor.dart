import 'package:espectrum_front/Model/ApiExceptionModel.dart';
import 'package:espectrum_front/Model/PacienteResumoModel.dart';
import 'package:espectrum_front/Model/ProfessorResumoModel.dart';
import 'package:espectrum_front/Model/VinculoEscolarModel.dart';
import 'package:espectrum_front/View/Widgets/categoria_input.dart';
import 'package:espectrum_front/View/Widgets/drawer_padrao.dart';
import 'package:espectrum_front/View/Widgets/logo_container.dart';
import 'package:espectrum_front/View/Widgets/roda_pe.dart';
import 'package:flutter/material.dart';
import '../../../Services/ProfessorService.dart';
import '../../../Services/TokenStorage.dart';
import '../../../Services/VinculoService.dart';
import '../../Widgets/app_bar_padrao.dart';
import '../../Widgets/widget_input_acesso.dart';

class TelaVincularProfessor extends StatefulWidget {
  const TelaVincularProfessor({super.key});

  @override
  State<TelaVincularProfessor> createState() => _TelaVincularProfessorState();
}

class _TelaVincularProfessorState extends State<TelaVincularProfessor> {
  final _formKey = GlobalKey<FormState>();
  final _anoLetivoController = TextEditingController();

  bool _carregando = true;
  bool _enviando = false;
  bool _carregandoVinculos = false;

  List<PacienteResumoModel> _pacientes = [];
  List<ProfessorResumoModel> _professores = [];
  List<VinculoEscolarModel> _vinculosDoPaciente = [];

  PacienteResumoModel? _pacienteSelecionado;
  ProfessorResumoModel? _professorSelecionado;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  @override
  void dispose() {
    _anoLetivoController.dispose();
    super.dispose();
  }

  Future<void> _carregarDados() async {
    setState(() => _carregando = true);
    try {
      final token = await TokenStorage.lerToken();
      final pacientes = await VinculoService.listarMeusPacientesVinculados(
        token ?? '',
      );
      final professores = await ProfessorService.listarProfessores(token ?? '');
      if (!mounted) return;
      setState(() {
        _pacientes = pacientes;
        _professores = professores;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      _mostrarSnack(e.message, Theme.of(context).colorScheme.error);
    } catch (_) {
      if (!mounted) return;
      _mostrarSnack(
        "Não foi possível carregar os dados. Tente novamente.",
        Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
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

  Future<void> _vincular() async {
    if (!_formKey.currentState!.validate()) return;
    if (_pacienteSelecionado == null || _professorSelecionado == null) return;

    setState(() => _enviando = true);
    try {
      final token = await TokenStorage.lerToken();
      await VinculoService.vincularPaciente(
        token: token ?? '',
        idPaciente: _pacienteSelecionado!.id,
        idTerapeuta: _professorSelecionado!.id,
        anoLetivo: _anoLetivoController.text.trim(),
      );

      if (!mounted) return;
      _mostrarSnack("Professor vinculado com sucesso!", Colors.green);
      Navigator.pop(context);
    } on ApiException catch (e) {
      _mostrarSnack(e.message, Theme.of(context).colorScheme.error);
    } catch (_) {
      _mostrarSnack(
        "Não foi possível vincular o professor. Tente novamente.",
        Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  Future<void> _carregarVinculosDoPaciente(String idPaciente) async {
    setState(() => _carregandoVinculos = true);
    try {
      final token = await TokenStorage.lerToken();
      final vinculos = await VinculoService.listarVinculosEscolares(
        token ?? '',
        idPaciente,
      );
      if (!mounted) return;
      setState(() => _vinculosDoPaciente = vinculos);
    } on ApiException catch (e) {
      if (!mounted) return;
      _mostrarSnack(e.message, Theme.of(context).colorScheme.error);
    } catch (_) {
      if (!mounted) return;
      _mostrarSnack(
        "Não foi possível carregar os vínculos deste paciente.",
        Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) setState(() => _carregandoVinculos = false);
    }
  }

  Future<void> _desvincular(VinculoEscolarModel vinculo) async {
    try {
      final token = await TokenStorage.lerToken();
      await VinculoService.desvincularProfessor(token ?? '', vinculo.id);
      if (!mounted) return;
      _mostrarSnack("Professor desvinculado com sucesso!", Colors.green);
      if (_pacienteSelecionado != null) {
        _carregarVinculosDoPaciente(_pacienteSelecionado!.id);
      }
    } on ApiException catch (e) {
      _mostrarSnack(e.message, Theme.of(context).colorScheme.error);
    } catch (_) {
      _mostrarSnack(
        "Não foi possível desvincular o professor. Tente novamente.",
        Theme.of(context).colorScheme.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBarPadrao(nome: "Vincular Professor"),
      endDrawer: DrawerPadrao(),
      body: SafeArea(
        bottom: false,
        child: _carregando
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      LogoContainer(
                        nomePage: 'Vincular Professor',
                        imagem: "assets/Images/Logo.png",
                      ),
                      SizedBox(height: 12),
                      CategoriaAtributos(
                        nome: "Vínculo Aluno-Professor",
                        icone: Icons.link,
                      ),
                      SizedBox(height: 16),

                      if (_pacientes.isEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            "Você ainda não tem pacientes vinculados para associar a um professor.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ),
                      ] else if (_professores.isEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            "Nenhum professor cadastrado no sistema ainda.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        ),
                      ] else ...[
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 355),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Paciente",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<PacienteResumoModel>(
                                value: _pacienteSelecionado,
                                isExpanded: true,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
                                  fontSize: 16,
                                ),
                                hint: Text(
                                  "Selecione um paciente",
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
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                ),
                                items: _pacientes.map((paciente) {
                                  return DropdownMenuItem<PacienteResumoModel>(
                                    value: paciente,
                                    child: Text(paciente.nome),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _pacienteSelecionado = value;
                                    _vinculosDoPaciente = [];
                                  });
                                  if (value != null) {
                                    _carregarVinculosDoPaciente(value.id);
                                  }
                                },
                                validator: (value) {
                                  if (value == null)
                                    return "Selecione um paciente";
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),

                        if (_pacienteSelecionado != null) ...[
                          SizedBox(height: 16),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 355),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Professores já vinculados",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSecondary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                if (_carregandoVinculos)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Center(
                                      child: SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      ),
                                    ),
                                  )
                                else if (_vinculosDoPaciente.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: Text(
                                      "Nenhum professor vinculado a este paciente ainda.",
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSecondary,
                                      ),
                                    ),
                                  )
                                else
                                  ..._vinculosDoPaciente.map((vinculo) {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.surfaceContainer,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  vinculo.professorNome,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Theme.of(
                                                      context,
                                                    ).colorScheme.onSecondary,
                                                  ),
                                                ),
                                                Text(
                                                  vinculo.escola,
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSecondary
                                                        .withOpacity(0.7),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.link_off,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.error,
                                            ),
                                            tooltip: "Desvincular",
                                            onPressed: () =>
                                                _desvincular(vinculo),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                              ],
                            ),
                          ),
                        ],

                        SizedBox(height: 16),

                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 355),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Professor",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
                                ),
                              ),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<ProfessorResumoModel>(
                                value: _professorSelecionado,
                                isExpanded: true,
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
                                  fontSize: 16,
                                ),
                                hint: Text(
                                  "Selecione um professor",
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
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                ),
                                items: _professores.map((professor) {
                                  return DropdownMenuItem<ProfessorResumoModel>(
                                    value: professor,
                                    child: Text(
                                      "${professor.nome} • ${professor.escola}",
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() => _professorSelecionado = value);
                                },
                                validator: (value) {
                                  if (value == null)
                                    return "Selecione um professor";
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),

                        CampoTexto(
                          label: "Ano Letivo",
                          hintText: "Ex: 2024",
                          keyboardType: TextInputType.number,
                          controller: _anoLetivoController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "O ano letivo é obrigatório";
                            }
                            if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                              return "Deve conter exatamente 4 números (ex: 2024)";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),

                        ElevatedButton(
                          onPressed: _enviando ? null : _vincular,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            padding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 40,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _enviando
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
                              : Text(
                                  "Vincular",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onPrimary,
                                  ),
                                ),
                        ),
                      ],

                      SizedBox(height: 12),
                      RodaPe(),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
