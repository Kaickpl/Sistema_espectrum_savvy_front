// tela_splash.dart
import 'package:espectrum_front/View/Pages/tela_inicial.dart';
import 'package:flutter/material.dart';

import '../../Services/TokenStorage.dart';
import '../Widgets/paginaHomePorPerfil.dart';
class TelaSplash extends StatefulWidget {
  const TelaSplash({super.key});

  @override
  State<TelaSplash> createState() => _TelaSplashState();
}

class _TelaSplashState extends State<TelaSplash>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _preenchimento;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _preenchimento = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();
    _navegarParaHome();
  }

  Future<void> _navegarParaHome() async {
    final token = await TokenStorage.lerToken();
    final perfil = await TokenStorage.lerPerfil();

    await Future.delayed(const Duration(milliseconds: 2600));
    if (!mounted) return;

    final bool sessaoValida = token != null && token.isNotEmpty && perfil != null;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) => sessaoValida
            ? paginaHomePorPerfil(perfil)
            : const PaginaInicial(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;

    return Scaffold(
      backgroundColor: tema.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 160,
              height: 160,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Stack(
                    children: [
                      Opacity(
                        opacity: 0.15,
                        child: Image.asset(
                          'assets/Images/Logo.png',
                          width: 160,
                          height: 160,
                        ),
                      ),
                      ClipPath(
                        clipper: _PreenchimentoClipper(_preenchimento.value),
                        child: Image.asset(
                          'assets/Images/Logo.png',
                          width: 160,
                          height: 160,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Espectrum',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: cores.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreenchimentoClipper extends CustomClipper<Path> {
  final double progresso;

  _PreenchimentoClipper(this.progresso);

  @override
  Path getClip(Size size) {
    final alturaPreenchida = size.height * (1 - progresso);
    return Path()
      ..addRect(Rect.fromLTRB(0, alturaPreenchida, size.width, size.height));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
