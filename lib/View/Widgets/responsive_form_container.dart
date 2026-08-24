import 'package:flutter/material.dart';

/// Centraliza e limita a largura do conteúdo em telas largas (acesso pela
/// web/desktop), evitando que formulários fiquem esticados de ponta a
/// ponta. Em telas estreitas (celular) a largura disponível já é menor
/// que [maxWidth], então o comportamento visual não muda.
class ResponsiveFormContainer extends StatelessWidget {
  const ResponsiveFormContainer({
    super.key,
    required this.child,
    this.maxWidth = 600,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
