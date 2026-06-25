// tela_gerenciar_terapeutas.dart
// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:espectrum_front/Model/ApiExceptionModel.dart';
import 'package:espectrum_front/Model/TerapeutaModel.dart';
import 'package:espectrum_front/Services/TerapeutaService.dart';
import 'package:espectrum_front/Services/TokenStorage.dart';

class TelaGerenciarTerapeutas extends StatefulWidget {
  const TelaGerenciarTerapeutas({super.key});

  @override
  State<TelaGerenciarTerapeutas> createState() =>
      _TelaGerenciarTerapeutasState();
}

class _TelaGerenciarTerapeutasState extends State<TelaGerenciarTerapeutas> {
  bool _carregando = true;
  List<TerapeutaModel> _terapeutas = [];
  final Set<String> _processando = {};

  @override
  void initState() {
    super.initState();
    _carregarTerapeutas();
  }

  Future<void> _carregarTerapeutas() async {
    setState(() => _carregando = true);
    try {
      final token = await TokenStorage.lerToken();
      final terapeutas = await TerapeutaService.buscarTodosPorAdmin(
        token ?? '',
      );
      if (!mounted) return;
      setState(() => _terapeutas = terapeutas);
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

  Future<void> _aprovar(TerapeutaModel terapeuta) async {
    setState(() => _processando.add(terapeuta.id));
    try {
      final token = await TokenStorage.lerToken();
      final atualizado = await TerapeutaService.aprovarCadastro(
        token ?? '',
        terapeuta.id,
      );
      if (!mounted) return;
      setState(() {
        final index = _terapeutas.indexWhere((t) => t.id == terapeuta.id);
        if (index != -1) _terapeutas[index] = atualizado;
      });
      _mostrarSnack(
        'Cadastro de ${terapeuta.nome} aprovado!',
        const Color(0xFF25A329),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      _mostrarSnack(e.message, Theme.of(context).colorScheme.error);
    } catch (_) {
      if (!mounted) return;
      _mostrarSnack(
        'Não foi possível aprovar o cadastro.',
        Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) setState(() => _processando.remove(terapeuta.id));
    }
  }

  Future<void> _reativar(TerapeutaModel terapeuta) async {
    setState(() => _processando.add(terapeuta.id));
    try {
      final token = await TokenStorage.lerToken();
      final atualizado = await TerapeutaService.reativarTerapeuta(
        token ?? '',
        terapeuta.id,
      );
      if (!mounted) return;
      setState(() {
        final index = _terapeutas.indexWhere((t) => t.id == terapeuta.id);
        if (index != -1) _terapeutas[index] = atualizado;
      });
      _mostrarSnack(
        '${terapeuta.nome} foi reativado.',
        Theme.of(context).colorScheme.primary,
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      _mostrarSnack(e.message, Theme.of(context).colorScheme.error);
    } catch (_) {
      if (!mounted) return;
      _mostrarSnack(
        'Não foi possível reativar a conta.',
        Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) setState(() => _processando.remove(terapeuta.id));
    }
  }

  void _confirmarDesativacao(TerapeutaModel terapeuta) {
    final cores = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            bool processando = false;

            Future<void> confirmar() async {
              setDialogState(() => processando = true);
              try {
                final token = await TokenStorage.lerToken();
                await TerapeutaService.desativarTerapeuta(
                  token ?? '',
                  terapeuta.id,
                );
                if (!mounted) return;
                Navigator.pop(ctx);
                setState(() {
                  final index = _terapeutas.indexWhere(
                    (t) => t.id == terapeuta.id,
                  );
                  if (index != -1) {
                    _terapeutas[index] = TerapeutaModel(
                      id: terapeuta.id,
                      numeroTelefone: terapeuta.numeroTelefone,
                      email: terapeuta.email,
                      nome: terapeuta.nome,
                      matricula: terapeuta.matricula,
                      periodo: terapeuta.periodo,
                      statusCadastro: terapeuta.statusCadastro,
                      ativo: false,
                    );
                  }
                });
                _mostrarSnack('Terapeuta desativado com sucesso!', cores.error);
              } on ApiException catch (e) {
                setDialogState(() => processando = false);
                _mostrarSnack(e.message, cores.error);
              } catch (_) {
                setDialogState(() => processando = false);
                _mostrarSnack(
                  'Não foi possível concluir a operação.',
                  cores.error,
                );
              }
            }

            return AlertDialog(
              backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Text(
                'Desativar terapeuta?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: cores.onSecondary,
                ),
              ),
              content: Text(
                'A conta de ${terapeuta.nome} será desativada e o acesso ao sistema será suspenso. Deseja continuar?',
                style: TextStyle(color: cores.onSurface.withOpacity(0.7)),
              ),
              actions: [
                TextButton(
                  onPressed: processando ? null : () => Navigator.pop(ctx),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: cores.onSurface.withOpacity(0.6)),
                  ),
                ),
                ElevatedButton(
                  onPressed: processando ? null : confirmar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cores.error,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: processando
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Sim, desativar'),
                ),
              ],
            );
          },
        );
      },
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
        title: const Text('Gerenciar Terapeutas'),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _carregarTerapeutas,
              child: _terapeutas.isEmpty
                  ? ListView(
                      children: [
                        const SizedBox(height: 120),
                        Center(
                          child: Text(
                            'Nenhum terapeuta cadastrado ainda.',
                            style: TextStyle(
                              color: cores.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _terapeutas.length,
                      itemBuilder: (context, index) {
                        return _buildCardTerapeuta(context, _terapeutas[index]);
                      },
                    ),
            ),
    );
  }

  Widget _buildCardTerapeuta(BuildContext context, TerapeutaModel terapeuta) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    final isDark = tema.brightness == Brightness.dark;
    final processando = _processando.contains(terapeuta.id);

    final pendente = terapeuta.statusCadastro == 'PENDENTE';
    final rejeitado = terapeuta.statusCadastro == 'REJEITADO';

    final corStatus = pendente
        ? const Color(0xFFD8A347)
        : rejeitado
        ? cores.error
        : const Color(0xFF25A329);

    final textoStatus = pendente
        ? 'Pendente'
        : rejeitado
        ? 'Rejeitado'
        : 'Aprovado';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? cores.surface.withOpacity(0.45)
            : cores.surfaceContainer.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cores.onSurface.withOpacity(0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: cores.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(Icons.person, color: cores.primary, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      terapeuta.nome,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: cores.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      terapeuta.email,
                      style: TextStyle(
                        fontSize: 12,
                        color: cores.onSurface.withOpacity(0.5),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: corStatus.withOpacity(0.15),
                          ),
                          child: Text(
                            textoStatus,
                            style: TextStyle(
                              color: corStatus,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        if (!terapeuta.ativo)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: cores.error.withOpacity(0.15),
                            ),
                            child: Text(
                              'Desativado',
                              style: TextStyle(
                                color: cores.error,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              if (terapeuta.ativo && pendente) ...[
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF25A329),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: processando ? null : () => _aprovar(terapeuta),
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text(
                        'Aprovar',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: SizedBox(
                  height: 42,
                  child: terapeuta.ativo
                      ? OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: cores.error,
                            side: BorderSide(
                              color: cores.error.withOpacity(0.4),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: processando
                              ? null
                              : () => _confirmarDesativacao(terapeuta),
                          icon: const Icon(Icons.block, size: 18),
                          label: const Text(
                            'Desativar',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        )
                      : ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: cores.primary,
                            foregroundColor: cores.onPrimary,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: processando
                              ? null
                              : () => _reativar(terapeuta),
                          icon: const Icon(Icons.refresh, size: 18),
                          label: const Text(
                            'Reativar',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
