import 'package:espectrum_front/Config/formatador_telefone.dart';
import 'package:espectrum_front/Model/ApiExceptionModel.dart';
import 'package:espectrum_front/Model/Enum/Perfil.dart';
import 'package:espectrum_front/Model/UsuarioModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Services/TokenStorage.dart';
import '../../Services/UsuarioService.dart';
import '../Widgets/app_bar_padrao.dart';
import '../Widgets/categoria_input.dart';
import '../Widgets/drawer_padrao.dart';
import '../Widgets/roda_pe.dart';
import '../Widgets/widget_input_acesso.dart';

extension _PerfilUiExt on Perfil {
  IconData get icone {
    switch (this) {
      case Perfil.ROLE_SUPERVISOR_ESTAGIO:
        return Icons.admin_panel_settings_rounded;
      case Perfil.roleTerapeuta:
        return Icons.psychology_rounded;
      case Perfil.roleProfessor:
        return Icons.school_rounded;
      case Perfil.roleResponsavel:
        return Icons.family_restroom_rounded;
    }
  }

  Color cor(ColorScheme cs) {
    switch (this) {
      case Perfil.ROLE_SUPERVISOR_ESTAGIO:
        return cs.tertiary;
      case Perfil.roleTerapeuta:
        return cs.secondary;
      case Perfil.roleProfessor:
        return cs.primary;
      case Perfil.roleResponsavel:
        return const Color(0xFF4CAF50);
    }
  }
}

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({super.key});

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  bool _carregando = true;
  UsuarioModel? _usuario;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    setState(() => _carregando = true);
    try {
      final token = await TokenStorage.lerToken();
      final usuario = await UsuarioService.buscarPerfil(token ?? '');
      if (!mounted) return;
      setState(() => _usuario = usuario);
    } on ApiException catch (e) {
      if (!mounted) return;
      _mostrarSnack(e.message, Theme.of(context).colorScheme.error);
    } catch (_) {
      if (!mounted) return;
      _mostrarSnack(
        "Não foi possível carregar o perfil. Tente novamente.",
        Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  String get _iniciais {
    final nome = _usuario?.nome.trim() ?? '';
    final partes = nome.split(' ').where((p) => p.isNotEmpty).toList();
    if (partes.length >= 2) {
      return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
    }
    return partes.isNotEmpty ? partes.first[0].toUpperCase() : '?';
  }

  // ── Diálogo de edição ──
  void _abrirEdicao() {
    final usuario = _usuario;
    if (usuario == null) return;

    final tmpNome = TextEditingController(text: usuario.nome);
    final tmpEmail = TextEditingController(text: usuario.email);
    final tmpTel = TextEditingController(text: usuario.numeroTelefone);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final cores = Theme.of(ctx).colorScheme;

        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            bool salvando = false;

            Future<void> salvar() async {
              if (!formKey.currentState!.validate()) return;
              setDialogState(() => salvando = true);
              try {
                final token = await TokenStorage.lerToken();
                final atualizado = await UsuarioService.editarPerfil(
                  token: token ?? '',
                  nome: tmpNome.text.trim(),
                  email: tmpEmail.text.trim(),
                  numeroTelefone: FormatadorTelefone.apenasDigitos(tmpTel.text),
                );
                if (!mounted) return;
                setState(() => _usuario = atualizado);
                Navigator.pop(ctx);
                _mostrarSnack('Perfil atualizado com sucesso!', cores.primary);
              } on ApiException catch (e) {
                setDialogState(() => salvando = false);
                _mostrarSnack(e.message, cores.error);
              } catch (_) {
                setDialogState(() => salvando = false);
                _mostrarSnack(
                  'Não foi possível salvar. Tente novamente.',
                  cores.error,
                );
              }
            }

            return AlertDialog(
              backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: cores.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      color: cores.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Editar Perfil',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: cores.onSecondary,
                    ),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CampoTexto(
                        label: 'Nome Completo',
                        hintText: 'Digite seu nome',
                        controller: tmpNome,
                        validator: (v) =>
                            (v == null || v.isEmpty) ? 'Informe o nome' : null,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 12),
                      CampoTexto(
                        label: 'E-mail',
                        hintText: 'Digite seu e-mail',
                        controller: tmpEmail,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Informe o e-mail';
                          if (!v.contains('@')) return 'Email inválido';
                          return null;
                        },
                        maxLines: 1,
                      ),
                      const SizedBox(height: 12),
                      CampoTexto(
                        label: 'Telefone',
                        hintText: '(00) 00000-0000',
                        controller: tmpTel,
                        keyboardType: TextInputType.phone,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Informe o telefone'
                            : null,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: salvando ? null : () => Navigator.pop(ctx),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: cores.onSurface.withOpacity(0.6)),
                  ),
                ),
                ElevatedButton(
                  onPressed: salvando ? null : salvar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cores.primary,
                    foregroundColor: cores.onPrimary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: salvando
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: cores.onPrimary,
                          ),
                        )
                      : const Text('Salvar alterações'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ── Diálogo de confirmação de status ──
  void _confirmarAlteracaoStatus() {
    final usuario = _usuario;
    if (usuario == null) return;

    final cores = Theme.of(context).colorScheme;
    final desativar = usuario.isActive;

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
                final atualizado = desativar
                    ? await UsuarioService.desativarConta(token ?? '')
                    : await UsuarioService.reativarConta(token ?? '');
                if (!mounted) return;
                setState(() => _usuario = atualizado);
                Navigator.pop(ctx);
                _mostrarSnack(
                  atualizado.isActive
                      ? 'Conta reativada com sucesso!'
                      : 'Conta desativada com sucesso!',
                  atualizado.isActive ? const Color(0xFF4CAF50) : cores.error,
                );
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
                desativar ? 'Desativar conta?' : 'Reativar conta?',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: cores.onSecondary,
                ),
              ),
              content: Text(
                desativar
                    ? 'Sua conta será desativada e o acesso ao sistema será suspenso. Deseja continuar?'
                    : 'Sua conta será reativada e você voltará a ter acesso completo. Deseja continuar?',
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
                    backgroundColor: desativar
                        ? cores.error
                        : const Color(0xFF4CAF50),
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
                      : Text(desativar ? 'Sim, desativar' : 'Sim, reativar'),
                ),
              ],
            );
          },
        );
      },
    );
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

  // ─────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    if (_carregando) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBarPadrao(nome: 'Meu Perfil'),
        endDrawer: const DrawerPadrao(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final usuario = _usuario;
    if (usuario == null) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBarPadrao(nome: 'Meu Perfil'),
        endDrawer: const DrawerPadrao(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, size: 48, color: cores.error),
              const SizedBox(height: 12),
              Text(
                'Não foi possível carregar o perfil.',
                style: TextStyle(color: cores.onSurface),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _carregarPerfil,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarPadrao(nome: 'Meu Perfil'),
      endDrawer: const DrawerPadrao(),
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          onRefresh: _carregarPerfil,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // ── Banner com avatar ──
                _buildBanner(cores, usuario),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dados pessoais
                      CategoriaAtributos(
                        nome: 'Dados Pessoais',
                        icone: Icons.person_rounded,
                      ),
                      const SizedBox(height: 12),
                      _InfoCard(
                        cores: cores,
                        campos: [
                          _Campo(Icons.badge_rounded, 'Nome', usuario.nome),
                          _Campo(Icons.email_rounded, 'E-mail', usuario.email),
                          _Campo(
                            Icons.phone_rounded,
                            'Telefone',
                            usuario.numeroTelefone,
                          ),
                          _Campo(Icons.fingerprint_rounded, 'CPF', usuario.cpf),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // Status da conta
                      CategoriaAtributos(
                        nome: 'Status da Conta',
                        icone: Icons.shield_rounded,
                      ),
                      const SizedBox(height: 12),
                      _CardStatus(cores: cores, ativo: usuario.isActive),

                      if (usuario.tipo == Perfil.ROLE_SUPERVISOR_ESTAGIO &&
                          (usuario.codigoConvite ?? '').isNotEmpty) ...[
                        const SizedBox(height: 20),
                        CategoriaAtributos(
                          nome: 'Código de Convite',
                          icone: Icons.qr_code_rounded,
                        ),
                        const SizedBox(height: 12),
                        _CardCodigoConvite(
                          cores: cores,
                          codigo: usuario.codigoConvite!,
                          onCopiado: () => _mostrarSnack(
                            'Código copiado!',
                            const Color(0xFF4CAF50),
                          ),
                        ),
                      ],

                      const SizedBox(height: 20),

                      // Botões de ação
                      _buildBotoesAcao(cores, usuario),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),

                const RodaPe(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Banner superior ──
  Widget _buildBanner(ColorScheme cores, UsuarioModel usuario) {
    final statusColor = usuario.isActive
        ? const Color(0xFF4CAF50)
        : const Color(0xFFFF6B6B);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [cores.primary, cores.secondary.withOpacity(0.85)],
        ),
      ),
      child: Column(
        children: [
          // Avatar com iniciais
          Container(
            width: 92,
            height: 92,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _iniciais,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            usuario.nome,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 8),

          // Badge de perfil + indicador de status
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(usuario.tipo.icone, color: Colors.white, size: 15),
                    const SizedBox(width: 6),
                    Text(
                      usuario.tipo.displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(0.6)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      usuario.isActive ? 'Ativa' : 'Inativa',
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Botões de ação ──
  Widget _buildBotoesAcao(ColorScheme cores, UsuarioModel usuario) {
    final statusColor = usuario.isActive
        ? cores.error
        : const Color(0xFF4CAF50);

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: _abrirEdicao,
            icon: const Icon(Icons.edit_rounded),
            label: const Text('Editar Informações'),
            style: ElevatedButton.styleFrom(
              backgroundColor: cores.primary,
              foregroundColor: cores.onPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: _confirmarAlteracaoStatus,
            icon: Icon(
              usuario.isActive
                  ? Icons.person_off_rounded
                  : Icons.person_rounded,
            ),
            label: Text(
              usuario.isActive ? 'Desativar Conta' : 'Reativar Conta',
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: statusColor,
              side: BorderSide(color: statusColor, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────
// WIDGETS INTERNOS REUTILIZÁVEIS
// ─────────────────────────────────────────────────────────────

class _Campo {
  final IconData icone;
  final String rotulo;
  final String valor;
  const _Campo(this.icone, this.rotulo, this.valor);
}

/// Cartão genérico de informações com linhas de dado
class _InfoCard extends StatelessWidget {
  final ColorScheme cores;
  final List<_Campo> campos;

  const _InfoCard({required this.cores, required this.campos});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? cores.surface.withOpacity(0.6) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cores.primary.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: campos.asMap().entries.map((entry) {
          final idx = entry.key;
          final campo = entry.value;
          return Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: cores.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(campo.icone, color: cores.primary, size: 18),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          campo.rotulo,
                          style: TextStyle(
                            fontSize: 11,
                            color: cores.onSurface.withOpacity(0.5),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          campo.valor,
                          style: TextStyle(
                            fontSize: 14,
                            color: cores.onSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (idx < campos.length - 1)
                Divider(height: 20, color: cores.primary.withOpacity(0.08)),
            ],
          );
        }).toList(),
      ),
    );
  }
}

/// Cartão de status da conta
class _CardStatus extends StatelessWidget {
  final ColorScheme cores;
  final bool ativo;

  const _CardStatus({required this.cores, required this.ativo});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cor = ativo ? const Color(0xFF4CAF50) : const Color(0xFFFF6B6B);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? cores.surface.withOpacity(0.6) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cor.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: cor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              ativo ? Icons.verified_user_rounded : Icons.person_off_rounded,
              color: cor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ativo ? 'Conta Ativa' : 'Conta Inativa',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: cor,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  ativo
                      ? 'Acesso ao sistema habilitado'
                      : 'Acesso ao sistema suspenso',
                  style: TextStyle(
                    fontSize: 12,
                    color: cores.onSurface.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
          // Indicador visual
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: cor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: cor.withOpacity(0.4),
                  blurRadius: 6,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Cartão com o código de convite do admin, usado por outros perfis
/// para se vincularem a ele no cadastro.
class _CardCodigoConvite extends StatelessWidget {
  final ColorScheme cores;
  final String codigo;
  final VoidCallback onCopiado;

  const _CardCodigoConvite({
    required this.cores,
    required this.codigo,
    required this.onCopiado,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? cores.surface.withOpacity(0.6) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cores.tertiary.withOpacity(0.35)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: cores.tertiary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.qr_code_rounded, color: cores.tertiary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Use este código para vincular outros perfis',
                  style: TextStyle(
                    fontSize: 12,
                    color: cores.onSurface.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  codigo,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: cores.onSecondary,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.copy_rounded, color: cores.tertiary),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: codigo));
              onCopiado();
            },
          ),
        ],
      ),
    );
  }
}
