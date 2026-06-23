import 'package:flutter/material.dart';
import '../Widgets/app_bar_padrao.dart';
import '../Widgets/categoria_input.dart';
import '../Widgets/drawer_padrao.dart';
import '../Widgets/roda_pe.dart';
import '../Widgets/widget_input_acesso.dart';

// ─────────────────────────────────────────────────────────────
// Enum de tipo de perfil – espelha o Perfil.java do backend
// ─────────────────────────────────────────────────────────────
enum TipoPerfil { admin, terapeuta, professor, responsavel }

extension TipoPerfilExt on TipoPerfil {
  String get rotulo {
    switch (this) {
      case TipoPerfil.admin:
        return 'Administrador';
      case TipoPerfil.terapeuta:
        return 'Terapeuta';
      case TipoPerfil.professor:
        return 'Professor';
      case TipoPerfil.responsavel:
        return 'Responsável';
    }
  }

  IconData get icone {
    switch (this) {
      case TipoPerfil.admin:
        return Icons.admin_panel_settings_rounded;
      case TipoPerfil.terapeuta:
        return Icons.psychology_rounded;
      case TipoPerfil.professor:
        return Icons.school_rounded;
      case TipoPerfil.responsavel:
        return Icons.family_restroom_rounded;
    }
  }

  Color cor(ColorScheme cs) {
    switch (this) {
      case TipoPerfil.admin:
        return cs.tertiary;
      case TipoPerfil.terapeuta:
        return cs.secondary;
      case TipoPerfil.professor:
        return cs.primary;
      case TipoPerfil.responsavel:
        return const Color(0xFF4CAF50);
    }
  }
}

// ─────────────────────────────────────────────────────────────
// Modelo leve só para a camada de UI (sem backend ainda)
// Quando integrar: substituir por UsuarioResponseDTO
// ─────────────────────────────────────────────────────────────
class _DadosMockPerfil {
  final String nome;
  final String email;
  final String telefone;
  final String cpf;
  final Map<String, String> camposExtras;

  const _DadosMockPerfil({
    required this.nome,
    required this.email,
    required this.telefone,
    required this.cpf,
    required this.camposExtras,
  });
}

const _mockPorTipo = {
  TipoPerfil.admin: _DadosMockPerfil(
    nome: 'Ana Silva Santos',
    email: 'ana.silva@espectrum.com',
    telefone: '(81) 99999-1234',
    cpf: '***.***.***-90',
    camposExtras: {
      'Matrícula': '2024001',
      'Nível de acesso': 'Administrador Geral',
    },
  ),
  TipoPerfil.terapeuta: _DadosMockPerfil(
    nome: 'Dr. Pedro Alves',
    email: 'pedro.alves@espectrum.com',
    telefone: '(81) 98888-4321',
    cpf: '***.***.***-21',
    camposExtras: {
      'CRP': '06/98765',
      'Especialidade': 'Psicologia Infantil',
      'Pacientes vinculados': '12 pacientes',
    },
  ),
  TipoPerfil.professor: _DadosMockPerfil(
    nome: 'Maria Oliveira',
    email: 'maria.oliveira@espectrum.com',
    telefone: '(81) 97777-5678',
    cpf: '***.***.***-43',
    camposExtras: {
      'Disciplina': 'Educação Especial',
      'Escola': 'E.M. João Paulo II',
      'Turma': '3º Ano A',
    },
  ),
  TipoPerfil.responsavel: _DadosMockPerfil(
    nome: 'Carlos Mendes',
    email: 'carlos.mendes@gmail.com',
    telefone: '(81) 96666-9012',
    cpf: '***.***.***-65',
    camposExtras: {
      'Relação': 'Pai',
      'Paciente vinculado': 'Lucas Mendes',
    },
  ),
};

// ─────────────────────────────────────────────────────────────
// TELA PRINCIPAL
// ─────────────────────────────────────────────────────────────

class TelaPerfil extends StatefulWidget {
  /// Recebe o tipo vindo do login.
  /// Quando integrar com o backend, passe o perfil real aqui.
  final TipoPerfil tipoPerfil;

  const TelaPerfil({
    super.key,
    this.tipoPerfil = TipoPerfil.admin, // padrão só para demo
  });

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  late TipoPerfil _perfilAtual;
  bool _contaAtiva = true;

  // Controllers editáveis
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _perfilAtual = widget.tipoPerfil;
    _carregarDados();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  void _carregarDados() {
    final d = _mockPorTipo[_perfilAtual]!;
    _nomeController.text = d.nome;
    _emailController.text = d.email;
    _telefoneController.text = d.telefone;
  }

  String get _iniciais {
    final partes = _nomeController.text.trim().split(' ');
    if (partes.length >= 2) {
      return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
    }
    return partes.isNotEmpty && partes.first.isNotEmpty
        ? partes.first[0].toUpperCase()
        : '?';
  }

  // ── Diálogo de edição ──
  void _abrirEdicao() {
    final tmpNome = TextEditingController(text: _nomeController.text);
    final tmpEmail = TextEditingController(text: _emailController.text);
    final tmpTel = TextEditingController(text: _telefoneController.text);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final cores = Theme.of(ctx).colorScheme;
        return AlertDialog(
          backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: cores.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.edit_rounded, color: cores.primary, size: 20),
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
                  ),
                  const SizedBox(height: 12),
                  CampoTexto(
                    label: 'E-mail',
                    hintText: 'Digite seu e-mail',
                    controller: tmpEmail,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe o e-mail' : null,
                  ),
                  const SizedBox(height: 12),
                  CampoTexto(
                    label: 'Telefone',
                    hintText: '(00) 00000-0000',
                    controller: tmpTel,
                    keyboardType: TextInputType.phone,
                    validator: (v) =>
                    (v == null || v.isEmpty) ? 'Informe o telefone' : null,
                  ),
                ],
              ),
            ),
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
                if (formKey.currentState!.validate()) {
                  setState(() {
                    _nomeController.text = tmpNome.text;
                    _emailController.text = tmpEmail.text;
                    _telefoneController.text = tmpTel.text;
                  });
                  Navigator.pop(ctx);
                  _mostrarSnack('Perfil atualizado com sucesso!', cores.primary);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: cores.primary,
                foregroundColor: cores.onPrimary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Salvar alterações'),
            ),
          ],
        );
      },
    );
  }

  // ── Diálogo de confirmação de status ──
  void _confirmarAlteracaoStatus() {
    final cores = Theme.of(context).colorScheme;
    final desativar = _contaAtiva;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(ctx).scaffoldBackgroundColor,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          desativar ? 'Desativar conta?' : 'Reativar conta?',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: cores.onSecondary),
        ),
        content: Text(
          desativar
              ? 'Sua conta será desativada e o acesso ao sistema será suspenso. Deseja continuar?'
              : 'Sua conta será reativada e você voltará a ter acesso completo. Deseja continuar?',
          style: TextStyle(color: cores.onSurface.withOpacity(0.7)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancelar',
                style: TextStyle(color: cores.onSurface.withOpacity(0.6))),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _contaAtiva = !_contaAtiva);
              Navigator.pop(ctx);
              _mostrarSnack(
                _contaAtiva
                    ? 'Conta reativada com sucesso!'
                    : 'Conta desativada com sucesso!',
                _contaAtiva ? const Color(0xFF4CAF50) : cores.error,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
              desativar ? cores.error : const Color(0xFF4CAF50),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(desativar ? 'Sim, desativar' : 'Sim, reativar'),
          ),
        ],
      ),
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
    final dados = _mockPorTipo[_perfilAtual]!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarPadrao(nome: 'Meu Perfil'),
      endDrawer: const DrawerPadrao(),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ── Banner com avatar ──
              _buildBanner(cores),

              const SizedBox(height: 16),

              // ── Seletor de demo ──
              _buildSeletorDemo(cores),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dados pessoais
                    CategoriaAtributos(
                        nome: 'Dados Pessoais', icone: Icons.person_rounded),
                    const SizedBox(height: 12),
                    _InfoCard(
                      cores: cores,
                      campos: [
                        _Campo(Icons.badge_rounded, 'Nome',
                            _nomeController.text),
                        _Campo(Icons.email_rounded, 'E-mail',
                            _emailController.text),
                        _Campo(Icons.phone_rounded, 'Telefone',
                            _telefoneController.text),
                        _Campo(Icons.fingerprint_rounded, 'CPF', dados.cpf),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Dados específicos do perfil
                    CategoriaAtributos(
                      nome: 'Dados ${_perfilAtual.rotulo}',
                      icone: _perfilAtual.icone,
                    ),
                    const SizedBox(height: 12),
                    _InfoCard(
                      cores: cores,
                      campos: _camposEspecificos(dados.camposExtras),
                    ),

                    const SizedBox(height: 20),

                    // Status da conta
                    CategoriaAtributos(
                        nome: 'Status da Conta',
                        icone: Icons.shield_rounded),
                    const SizedBox(height: 12),
                    _CardStatus(cores: cores, ativo: _contaAtiva),

                    const SizedBox(height: 20),

                    // Botões de ação
                    _buildBotoesAcao(cores),

                    const SizedBox(height: 24),
                  ],
                ),
              ),

              const RodaPe(),
            ],
          ),
        ),
      ),
    );
  }

  // ── Banner superior ──
  Widget _buildBanner(ColorScheme cores) {
    final statusColor =
    _contaAtiva ? const Color(0xFF4CAF50) : const Color(0xFFFF6B6B);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            cores.primary,
            cores.secondary.withOpacity(0.85),
          ],
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
            _nomeController.text,
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
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(20),
                  border:
                  Border.all(color: Colors.white.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_perfilAtual.icone,
                        color: Colors.white, size: 15),
                    const SizedBox(width: 6),
                    Text(
                      _perfilAtual.rotulo,
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
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                      _contaAtiva ? 'Ativa' : 'Inativa',
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

  // ── Seletor de demo (remover ao integrar com backend) ──
  Widget _buildSeletorDemo(ColorScheme cores) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cores.surfaceContainer.withOpacity(0.25),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cores.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.tune_rounded, size: 14, color: cores.primary),
              const SizedBox(width: 6),
              Text(
                'Modo demonstração — selecione o perfil:',
                style: TextStyle(
                  fontSize: 12,
                  color: cores.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: TipoPerfil.values.map((tipo) {
              final sel = tipo == _perfilAtual;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    _perfilAtual = tipo;
                    _carregarDados();
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    decoration: BoxDecoration(
                      color: sel ? cores.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: sel
                          ? null
                          : Border.all(
                          color: cores.primary.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          tipo.icone,
                          size: 18,
                          color: sel
                              ? cores.onPrimary
                              : cores.primary.withOpacity(0.6),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tipo.rotulo.split(' ').first,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight:
                            sel ? FontWeight.bold : FontWeight.normal,
                            color: sel
                                ? cores.onPrimary
                                : cores.primary.withOpacity(0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  List<_Campo> _camposEspecificos(Map<String, String> extras) {
    const _iconesExtras = {
      'Matrícula': Icons.badge_outlined,
      'Nível de acesso': Icons.admin_panel_settings_outlined,
      'CRP': Icons.assignment_ind_rounded,
      'Especialidade': Icons.psychology_outlined,
      'Pacientes vinculados': Icons.groups_rounded,
      'Disciplina': Icons.book_rounded,
      'Escola': Icons.account_balance_rounded,
      'Turma': Icons.class_rounded,
      'Relação': Icons.family_restroom_rounded,
      'Paciente vinculado': Icons.child_care_rounded,
    };

    return extras.entries.map((e) {
      return _Campo(
        _iconesExtras[e.key] ?? Icons.label_rounded,
        e.key,
        e.value,
      );
    }).toList();
  }

  // ── Botões de ação ──
  Widget _buildBotoesAcao(ColorScheme cores) {
    final statusColor =
    _contaAtiva ? cores.error : const Color(0xFF4CAF50);

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
                  borderRadius: BorderRadius.circular(14)),
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
              _contaAtiva
                  ? Icons.person_off_rounded
                  : Icons.person_rounded,
            ),
            label: Text(
                _contaAtiva ? 'Desativar Conta' : 'Reativar Conta'),
            style: OutlinedButton.styleFrom(
              foregroundColor: statusColor,
              side: BorderSide(color: statusColor, width: 1.5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
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
                    child:
                    Icon(campo.icone, color: cores.primary, size: 18),
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
                Divider(
                  height: 20,
                  color: cores.primary.withOpacity(0.08),
                ),
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
              ativo
                  ? Icons.verified_user_rounded
                  : Icons.person_off_rounded,
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