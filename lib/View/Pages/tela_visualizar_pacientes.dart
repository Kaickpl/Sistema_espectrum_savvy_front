import 'package:espectrum_front/Model/ApiExceptionModel.dart';
import 'package:espectrum_front/Model/PacienteDetalheModel.dart';
import 'package:espectrum_front/Services/PacienteService.dart';
import 'package:espectrum_front/Services/TokenStorage.dart';
import 'package:espectrum_front/View/Pages/manager/tela_editar_paciente.dart';
import 'package:espectrum_front/View/Widgets/cabecalho_padrao.dart';
import 'package:espectrum_front/View/Widgets/drawer_padrao.dart';
import 'package:flutter/material.dart';

/// Lista os pacientes vinculados ao usuário logado (terapeuta ou
/// supervisor de estágio, cada um vendo apenas os seus) e permite
/// abrir para editar ou excluir a conta do paciente.
class TelaVisualizarPacientes extends StatefulWidget {
  const TelaVisualizarPacientes({super.key});

  @override
  State<TelaVisualizarPacientes> createState() =>
      _TelaVisualizarPacientesState();
}

class _TelaVisualizarPacientesState extends State<TelaVisualizarPacientes> {
  bool _carregando = true;
  String? _erro;
  List<PacienteDetalheModel> _pacientes = [];

  @override
  void initState() {
    super.initState();
    _carregarPacientes();
  }

  Future<void> _carregarPacientes() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final token = await TokenStorage.lerToken();
      final pacientes = await PacienteService.listarPacientes(token ?? '');
      if (!mounted) return;
      setState(() => _pacientes = pacientes);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _erro = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _erro = "Não foi possível carregar os pacientes.");
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  Future<void> _abrirEdicao(PacienteDetalheModel paciente) async {
    final atualizou = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => TelaEditarPaciente(pacienteId: paciente.id),
      ),
    );
    if (atualizou == true) _carregarPacientes();
  }

  void _confirmarExclusao(PacienteDetalheModel paciente) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Excluir paciente"),
        content: Text(
          "Tem certeza que deseja excluir a conta de ${paciente.nome}? "
          "Essa ação desativa o cadastro do paciente.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _excluirPaciente(paciente);
            },
            child: Text(
              "Excluir",
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _excluirPaciente(PacienteDetalheModel paciente) async {
    try {
      final token = await TokenStorage.lerToken();
      await PacienteService.excluirPaciente(token ?? '', paciente.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Paciente ${paciente.nome} excluído.")),
      );
      _carregarPacientes();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Não foi possível excluir o paciente."),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const CabecalhoPadrao(titulo: 'Visualizar Pacientes'),
      endDrawer: const DrawerPadrao(),
      body: RefreshIndicator(
        onRefresh: _carregarPacientes,
        child: _carregando
            ? const Center(child: CircularProgressIndicator())
            : _erro != null
            ? ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Center(
                      child: Text(_erro!, style: TextStyle(color: cores.error)),
                    ),
                  ),
                ],
              )
            : _pacientes.isEmpty
            ? ListView(
                children: const [
                  Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Center(
                      child: Text("Nenhum paciente vinculado encontrado."),
                    ),
                  ),
                ],
              )
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _pacientes.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final paciente = _pacientes[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: cores.onPrimary,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: cores.onSurface, width: 1),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      title: Text(
                        paciente.nome,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Text(
                        "${paciente.grau.displayName}"
                        "${paciente.idade != null ? ' • ${paciente.idade} anos' : ''}",
                      ),
                      onTap: () => _abrirEdicao(paciente),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            tooltip: "Editar",
                            onPressed: () => _abrirEdicao(paciente),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: cores.error,
                            ),
                            tooltip: "Excluir",
                            onPressed: () => _confirmarExclusao(paciente),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
