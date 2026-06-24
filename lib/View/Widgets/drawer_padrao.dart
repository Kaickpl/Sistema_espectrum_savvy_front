import 'package:espectrum_front/View/Pages/tela_inicial.dart';
import 'package:espectrum_front/View/Pages/tela_perfil.dart';
import 'package:espectrum_front/View/Pages/tela_suporte.dart';
import 'package:flutter/material.dart';
import 'package:espectrum_front/main.dart';

import '../../Services/AuthService.dart';

class DrawerPadrao extends StatelessWidget {
  /// Defina como [false] nas telas de login, cadastro e recuperação de senha.
  final bool mostrarLogout;

  const DrawerPadrao({
    super.key,
    this.mostrarLogout = true,
  });

  void _logout(BuildContext context) async {
    Navigator.pop(context); // fecha o drawer

    await AuthService.logout();

    if (!context.mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const PaginaInicial()),
          (route) => false, // remove todo o histórico de navegação
    );
  }

  void _confirmarLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Sair"),
        content: const Text("Tem certeza que deseja sair?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx); // fecha o diálogo
              _logout(context);   // navega para login
            },
            child: Text(
              "Sair",
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

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Drawer(
      shadowColor: colors.onPrimary,
      backgroundColor: colors.primary,
      child: SafeArea(
        child: Column(
          children: [
            // ── Header ───────────────────────────────────────────────
            _DrawerHeader(),

            // ── Itens principais ─────────────────────────────────────
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _DrawerItem(
                    icone: Icons.person,
                    titulo: "Perfil",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TelaPerfil(),
                        ),
                      );
                    },
                  ),

                  const _Divisor(),

                  _DrawerItem(
                    icone: Icons.support_agent_rounded,
                    titulo: "Suporte e Ajuda",
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const TelaSuporte(),
                        ),
                      );
                    },
                  ),
                  const _Divisor(),

                  // ── Modo escuro ───────────────────────────────────
                  SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    secondary: Icon(
                      isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: colors.onPrimary,
                    ),
                    title: Text(
                      "Modo Escuro",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: colors.onPrimary,
                      ),
                    ),
                    value: isDarkMode,
                    activeColor: colors.onPrimary,
                    onChanged: (value) {
                      temaApp.value =
                      value ? ThemeMode.dark : ThemeMode.light;
                    },
                  ),
                ],
              ),
            ),

            // ── Logout (só aparece quando mostrarLogout == true) ──────
            if (mostrarLogout) ...[
              const _Divisor(),
              _DrawerItem(
                icone: Icons.logout_rounded,
                titulo: "Sair",
                corIcone: colors.error,
                corTexto: colors.error,
                onTap: () => _confirmarLogout(context),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Widgets internos ────────────────────────────────────────────────────────

class _DrawerHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      decoration: BoxDecoration(
        color: colors.primary,
        border: Border(
          bottom: BorderSide(
            color: colors.onPrimary.withOpacity(0.15),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.settings, color: colors.onPrimary, size: 36),
          const SizedBox(height: 12),
          Text(
            "Configurações",
            style: TextStyle(
              color: colors.onPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icone;
  final String titulo;
  final VoidCallback onTap;
  final Color? corIcone;
  final Color? corTexto;

  const _DrawerItem({
    required this.icone,
    required this.titulo,
    required this.onTap,
    this.corIcone,
    this.corTexto,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      leading: Icon(icone, color: corIcone ?? colors.onPrimary),
      title: Text(
        titulo,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: corTexto ?? colors.onPrimary,
        ),
      ),
      onTap: onTap,
    );
  }
}

class _Divisor extends StatelessWidget {
  const _Divisor();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 20,
      endIndent: 20,
      color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
    );
  }
}