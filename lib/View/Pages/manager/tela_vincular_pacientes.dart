// tela_vincular_pacientes.dart
import 'package:flutter/material.dart';
import 'package:espectrum_front/Model/ApiExceptionModel.dart';
import 'package:espectrum_front/Model/PacienteResumoModel.dart';
import 'package:espectrum_front/Model/PacienteVinculadoModel.dart';
import 'package:espectrum_front/Model/TerapeutaResumoModel.dart';
import 'package:espectrum_front/Services/TerapeutaService.dart';
import 'package:espectrum_front/Services/TokenStorage.dart';
import 'package:espectrum_front/Services/VinculoService.dart';

class TelaVincularPacientes extends StatefulWidget {
  final String? idTerapeutaPreSelecionado;

  const TelaVincularPacientes({super.key, this.idTerapeutaPreSelecionado});

  @override
  State<TelaVincularPacientes> createState() => _TelaVincularPacientesState();
}

class _TelaVincularPacientesState extends State<TelaVincularPacientes> {
  bool _carregandoTerapeutas = true;
  List<TerapeutaResumoModel> _terapeutas = [];
  String _buscaTerapeuta = '';

  TerapeutaResumoModel? _terapeutaSelecionado;

  bool _carregandoVinculados = false;
  List<PacienteVinculadoModel> _pacientesVinculados = [];
  String? _pacienteVinculadoSelecionadoId;
  final Set<String> _desvinculando = {};

  bool _carregandoDisponiveis = false;

  List<TerapeutaResumoModel> get _terapeutasFiltrados {
    return _terapeutas
        .where(
          (t) => t.nome.toLowerCase().contains(_buscaTerapeuta.toLowerCase()),
        )
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _carregarTerapeutas();
  }

  Future<void> _carregarTerapeutas() async {
    setState(() => _carregandoTerapeutas = true);
    try {
      final token = await TokenStorage.lerToken();
      final terapeutas = await TerapeutaService.buscarResumoPorAdmin(
        token ?? '',
      );
      if (!mounted) return;
      setState(() => _terapeutas = terapeutas);

      if (widget.idTerapeutaPreSelecionado != null) {
        TerapeutaResumoModel? preSelecionado;
        for (final t in terapeutas) {
          if (t.id == widget.idTerapeutaPreSelecionado) {
            preSelecionado = t;
            break;
          }
        }
        if (preSelecionado != null) {
          await _selecionarTerapeuta(preSelecionado);
        }
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      _mostrarSnack(e.message, Theme.of(context).colorScheme.error);
    } catch (_) {
      if (!mounted) return;
      _mostrarSnack(
        'Não foi possível carregar os terapeutas. Tente novamente.',
        Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) setState(() => _carregandoTerapeutas = false);
    }
  }

  Future<void> _selecionarTerapeuta(TerapeutaResumoModel terapeuta) async {
    setState(() {
      _terapeutaSelecionado = terapeuta;
      _pacientesVinculados = [];
      _pacienteVinculadoSelecionadoId = null;
    });
    await _carregarPacientesVinculados();
  }

  void _trocarTerapeuta() {
    setState(() {
      _terapeutaSelecionado = null;
      _pacientesVinculados = [];
      _pacienteVinculadoSelecionadoId = null;
      _buscaTerapeuta = '';
    });
  }

  Future<void> _carregarPacientesVinculados() async {
    final terapeuta = _terapeutaSelecionado;
    if (terapeuta == null) return;

    setState(() => _carregandoVinculados = true);
    try {
      final token = await TokenStorage.lerToken();
      final pacientes = await VinculoService.listarPacientesVinculados(
        token ?? '',
        terapeuta.id,
      );
      if (!mounted) return;
      setState(() => _pacientesVinculados = pacientes);
    } on ApiException catch (e) {
      if (!mounted) return;
      _mostrarSnack(e.message, Theme.of(context).colorScheme.error);
    } catch (_) {
      if (!mounted) return;
      _mostrarSnack(
        'Não foi possível carregar os pacientes vinculados.',
        Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) setState(() => _carregandoVinculados = false);
    }
  }

  void _alternarSelecaoPaciente(String idVinculo) {
    setState(() {
      _pacienteVinculadoSelecionadoId =
          _pacienteVinculadoSelecionadoId == idVinculo ? null : idVinculo;
    });
  }

  void _confirmarDesvincular(PacienteVinculadoModel paciente) {
    final cores = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Desvincular paciente?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: cores.onSecondary,
            ),
          ),
          content: Text(
            '${paciente.nome} será desvinculado(a) deste terapeuta. Deseja continuar?',
            style: TextStyle(color: cores.onSurface.withOpacity(0.7)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(
                'Cancelar',
                style: TextStyle(color: cores.onSurface.withOpacity(0.6)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                _executarDesvincular(paciente);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: cores.error,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Sim, desvincular'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _executarDesvincular(PacienteVinculadoModel paciente) async {
    setState(() => _desvinculando.add(paciente.idVinculo));
    try {
      final token = await TokenStorage.lerToken();
      await VinculoService.desvincularPaciente(token ?? '', paciente.idVinculo);
      if (!mounted) return;
      setState(() {
        _pacientesVinculados.removeWhere(
          (p) => p.idVinculo == paciente.idVinculo,
        );
        if (_pacienteVinculadoSelecionadoId == paciente.idVinculo) {
          _pacienteVinculadoSelecionadoId = null;
        }
      });
      _mostrarSnack(
        '${paciente.nome} foi desvinculado(a).',
        Theme.of(context).colorScheme.primary,
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      _mostrarSnack(e.message, Theme.of(context).colorScheme.error);
    } catch (_) {
      if (!mounted) return;
      _mostrarSnack(
        'Não foi possível desvincular o paciente.',
        Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) setState(() => _desvinculando.remove(paciente.idVinculo));
    }
  }

  Future<void> _abrirSeletorDisponiveis() async {
    final terapeuta = _terapeutaSelecionado;
    if (terapeuta == null) return;

    setState(() => _carregandoDisponiveis = true);
    List<PacienteResumoModel> disponiveis = [];
    bool ok = true;
    try {
      final token = await TokenStorage.lerToken();
      disponiveis = await VinculoService.listarPacientesDisponiveis(
        token ?? '',
        terapeuta.id,
      );
    } on ApiException catch (e) {
      ok = false;
      if (mounted)
        _mostrarSnack(e.message, Theme.of(context).colorScheme.error);
    } catch (_) {
      ok = false;
      if (mounted) {
        _mostrarSnack(
          'Não foi possível carregar os pacientes disponíveis.',
          Theme.of(context).colorScheme.error,
        );
      }
    } finally {
      if (mounted) setState(() => _carregandoDisponiveis = false);
    }

    if (!ok || !mounted) return;

    await showDialog(
      context: context,
      builder: (ctx) => _SeletorPacientesDisponiveis(
        pacientesIniciais: disponiveis,
        onVincular: _vincularPaciente,
      ),
    );
  }

  Future<bool> _vincularPaciente(PacienteResumoModel paciente) async {
    final terapeuta = _terapeutaSelecionado;
    if (terapeuta == null) return false;

    try {
      final token = await TokenStorage.lerToken();
      await VinculoService.vincularPaciente(
        token: token ?? '',
        idPaciente: paciente.id,
        idTerapeuta: terapeuta.id,
      );
      if (mounted) {
        _mostrarSnack(
          '${paciente.nome} vinculado(a) com sucesso!',
          Theme.of(context).colorScheme.primary,
        );
      }
      await _carregarPacientesVinculados();
      return true;
    } on ApiException catch (e) {
      if (mounted)
        _mostrarSnack(e.message, Theme.of(context).colorScheme.error);
      return false;
    } catch (_) {
      if (mounted) {
        _mostrarSnack(
          'Não foi possível vincular o paciente.',
          Theme.of(context).colorScheme.error,
        );
      }
      return false;
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

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    final corFundo = tema.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        backgroundColor: corFundo,
        elevation: 0,
        foregroundColor: cores.onSurface,
        title: const Text('Vincular Pacientes'),
      ),
      body: _carregandoTerapeutas
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: _terapeutaSelecionado == null
                  ? _buildSelecaoTerapeuta(cores)
                  : _buildGestaoVinculos(cores),
            ),
    );
  }

  Widget _buildSelecaoTerapeuta(ColorScheme cores) {
    final tema = Theme.of(context);
    final isDark = tema.brightness == Brightness.dark;
    final terapeutasFiltrados = _terapeutasFiltrados;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Text(
          'Selecione o terapeuta',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: cores.onSurface.withOpacity(0.85),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: isDark
                ? cores.surface.withOpacity(0.45)
                : cores.surfaceContainer.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: cores.onSurface.withOpacity(0.06)),
          ),
          child: TextField(
            onChanged: (value) => setState(() => _buscaTerapeuta = value),
            style: TextStyle(color: cores.onSurface),
            decoration: InputDecoration(
              hintText: 'Buscar terapeuta por nome...',
              hintStyle: TextStyle(color: cores.onSurface.withOpacity(0.4)),
              prefixIcon: Icon(
                Icons.search,
                color: cores.onSurface.withOpacity(0.4),
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: terapeutasFiltrados.isEmpty
              ? Center(
                  child: Text(
                    _terapeutas.isEmpty
                        ? 'Nenhum terapeuta cadastrado ainda.'
                        : 'Nenhum terapeuta encontrado.',
                    style: TextStyle(color: cores.onSurface.withOpacity(0.4)),
                  ),
                )
              : ListView.builder(
                  itemCount: terapeutasFiltrados.length,
                  itemBuilder: (context, index) =>
                      _buildCardTerapeutaSelecionavel(
                        terapeutasFiltrados[index],
                      ),
                ),
        ),
      ],
    );
  }

  Widget _buildCardTerapeutaSelecionavel(TerapeutaResumoModel terapeuta) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    final isDark = tema.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark
            ? cores.surface.withOpacity(0.45)
            : cores.surfaceContainer.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cores.onSurface.withOpacity(0.06)),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onTap: () => _selecionarTerapeuta(terapeuta),
        leading: Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            color: cores.primary.withOpacity(0.15),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Icon(Icons.person, color: cores.primary, size: 22),
        ),
        title: Text(
          terapeuta.nome,
          style: TextStyle(fontWeight: FontWeight.w600, color: cores.onSurface),
        ),
        subtitle: Text(
          '${terapeuta.quantidadePacientes} paciente(s) vinculado(s)',
          style: TextStyle(
            fontSize: 12,
            color: cores.onSurface.withOpacity(0.5),
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: cores.onSurface.withOpacity(0.3),
        ),
      ),
    );
  }

  Widget _buildGestaoVinculos(ColorScheme cores) {
    final pacientesVinculados = _pacientesVinculados;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        _buildTerapeutaSelecionadoCard(),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Pacientes vinculados',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: cores.onSurface.withOpacity(0.85),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: cores.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${pacientesVinculados.length}',
                style: TextStyle(
                  color: cores.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: _carregandoVinculados
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _carregarPacientesVinculados,
                  child: pacientesVinculados.isEmpty
                      ? ListView(
                          children: [
                            const SizedBox(height: 80),
                            Center(
                              child: Text(
                                'Nenhum paciente vinculado ainda.',
                                style: TextStyle(
                                  color: cores.onSurface.withOpacity(0.4),
                                ),
                              ),
                            ),
                          ],
                        )
                      : ListView.builder(
                          itemCount: pacientesVinculados.length,
                          itemBuilder: (context, index) =>
                              _buildCardPacienteVinculado(
                                pacientesVinculados[index],
                              ),
                        ),
                ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: cores.primary,
              side: BorderSide(color: cores.primary.withOpacity(0.4)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: _carregandoDisponiveis ? null : _abrirSeletorDisponiveis,
            icon: _carregandoDisponiveis
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: cores.primary,
                    ),
                  )
                : const Icon(Icons.add),
            label: const Text(
              'Vincular novo paciente',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildTerapeutaSelecionadoCard() {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    final isDark = tema.brightness == Brightness.dark;
    final terapeuta = _terapeutaSelecionado!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? cores.surface.withOpacity(0.45)
            : cores.surfaceContainer.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cores.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: cores.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(Icons.person, color: cores.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Terapeuta selecionado',
                  style: TextStyle(
                    fontSize: 11,
                    color: cores.onSurface.withOpacity(0.5),
                  ),
                ),
                Text(
                  terapeuta.nome,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: cores.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _trocarTerapeuta,
            child: const Text(
              'Trocar',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardPacienteVinculado(PacienteVinculadoModel paciente) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    final isDark = tema.brightness == Brightness.dark;
    final selecionado = _pacienteVinculadoSelecionadoId == paciente.idVinculo;
    final desvinculando = _desvinculando.contains(paciente.idVinculo);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: selecionado
            ? cores.error.withOpacity(0.08)
            : (isDark
                  ? cores.surface.withOpacity(0.45)
                  : cores.surfaceContainer.withOpacity(0.15)),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selecionado
              ? cores.error.withOpacity(0.4)
              : cores.onSurface.withOpacity(0.06),
        ),
      ),
      child: Column(
        children: [
          ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            onTap: desvinculando
                ? null
                : () => _alternarSelecaoPaciente(paciente.idVinculo),
            leading: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: cores.tertiary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.person_outline,
                color: cores.tertiary,
                size: 20,
              ),
            ),
            title: Text(
              paciente.nome,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: cores.onSurface,
              ),
            ),
            subtitle: Text(
              '${paciente.genero} • ${paciente.grauAutismo.displayName}',
              style: TextStyle(
                fontSize: 12,
                color: cores.onSurface.withOpacity(0.5),
              ),
            ),
            trailing: Icon(
              selecionado ? Icons.check_circle : Icons.circle_outlined,
              color: selecionado
                  ? cores.error
                  : cores.onSurface.withOpacity(0.25),
            ),
          ),
          if (selecionado)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: SizedBox(
                width: double.infinity,
                height: 40,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: cores.error,
                    side: BorderSide(color: cores.error.withOpacity(0.4)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: desvinculando
                      ? null
                      : () => _confirmarDesvincular(paciente),
                  icon: desvinculando
                      ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: cores.error,
                          ),
                        )
                      : const Icon(Icons.link_off, size: 18),
                  label: const Text(
                    'Desvincular',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SeletorPacientesDisponiveis extends StatefulWidget {
  final List<PacienteResumoModel> pacientesIniciais;
  final Future<bool> Function(PacienteResumoModel paciente) onVincular;

  const _SeletorPacientesDisponiveis({
    required this.pacientesIniciais,
    required this.onVincular,
  });

  @override
  State<_SeletorPacientesDisponiveis> createState() =>
      _SeletorPacientesDisponiveisState();
}

class _SeletorPacientesDisponiveisState
    extends State<_SeletorPacientesDisponiveis> {
  late List<PacienteResumoModel> _pacientes;
  String _busca = '';
  final Set<String> _vinculando = {};

  @override
  void initState() {
    super.initState();
    _pacientes = List.of(widget.pacientesIniciais);
  }

  Future<void> _vincular(PacienteResumoModel paciente) async {
    setState(() => _vinculando.add(paciente.id));
    final sucesso = await widget.onVincular(paciente);
    if (!mounted) return;
    setState(() {
      _vinculando.remove(paciente.id);
      if (sucesso) {
        _pacientes.removeWhere((p) => p.id == paciente.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    final isDark = tema.brightness == Brightness.dark;

    final filtrados = _pacientes
        .where((p) => p.nome.toLowerCase().contains(_busca.toLowerCase()))
        .toList();

    return AlertDialog(
      backgroundColor: tema.scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        'Vincular novo paciente',
        style: TextStyle(fontWeight: FontWeight.bold, color: cores.onSecondary),
      ),
      contentPadding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      content: SizedBox(
        width: double.maxFinite,
        height: 420,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? cores.surface.withOpacity(0.45)
                    : cores.surfaceContainer.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cores.onSurface.withOpacity(0.06)),
              ),
              child: TextField(
                onChanged: (value) => setState(() => _busca = value),
                style: TextStyle(color: cores.onSurface),
                decoration: InputDecoration(
                  hintText: 'Buscar paciente...',
                  hintStyle: TextStyle(color: cores.onSurface.withOpacity(0.4)),
                  prefixIcon: Icon(
                    Icons.search,
                    color: cores.onSurface.withOpacity(0.4),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: filtrados.isEmpty
                  ? Center(
                      child: Text(
                        _pacientes.isEmpty
                            ? 'Nenhum paciente disponível.'
                            : 'Nenhum paciente encontrado.',
                        style: TextStyle(
                          color: cores.onSurface.withOpacity(0.4),
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: filtrados.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final paciente = filtrados[index];
                        final vinculando = _vinculando.contains(paciente.id);
                        return Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? cores.surface.withOpacity(0.45)
                                : cores.surfaceContainer.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: cores.onSurface.withOpacity(0.06),
                            ),
                          ),
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            leading: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: cores.tertiary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.person_outline,
                                color: cores.tertiary,
                                size: 20,
                              ),
                            ),
                            title: Text(
                              paciente.nome,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: cores.onSurface,
                              ),
                            ),
                            subtitle: Text(
                              '${paciente.genero} • ${paciente.grauAutismo.displayName}',
                              style: TextStyle(
                                fontSize: 12,
                                color: cores.onSurface.withOpacity(0.5),
                              ),
                            ),
                            trailing: vinculando
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: cores.primary,
                                    ),
                                  )
                                : Icon(
                                    Icons.add_circle_outline,
                                    color: cores.primary,
                                  ),
                            onTap: vinculando
                                ? null
                                : () => _vincular(paciente),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Fechar',
            style: TextStyle(color: cores.onSurface.withOpacity(0.6)),
          ),
        ),
      ],
    );
  }
}
