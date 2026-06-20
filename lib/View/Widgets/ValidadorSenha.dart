import 'package:flutter/material.dart';

/// Checklist animado de requisitos de senha + barra de força.
///
/// Basta passar o [controller] já usado no campo de senha — o widget
/// escuta as mudanças sozinho (não precisa de setState externo) e anima
/// os checks e a barra conforme o usuário digita.
///
/// Exemplo:
/// ```dart
/// CampoTexto(label: "Senha", controller: _senhaController, ...),
/// ValidadorSenha(controller: _senhaController),
/// ```
class ValidadorSenha extends StatefulWidget {
  final TextEditingController controller;

  const ValidadorSenha({super.key, required this.controller});

  @override
  State<ValidadorSenha> createState() => _ValidadorSenhaState();
}

class _ValidadorSenhaState extends State<ValidadorSenha> {
  bool _temTamanho = false;
  bool _temMaiuscula = false;
  bool _temMinuscula = false;
  bool _temNumero = false;
  bool _temEspecial = false;

  static final _regexMaiuscula = RegExp(r'[A-Z]');
  static final _regexMinuscula = RegExp(r'[a-z]');
  static final _regexNumero = RegExp(r'[0-9]');
  static final _regexEspecial = RegExp(r'[@#$%&*!?]');

  @override
  void initState() {
    super.initState();
    _avaliar();
    widget.controller.addListener(_avaliar);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_avaliar);
    super.dispose();
  }

  void _avaliar() {
    final senha = widget.controller.text;
    setState(() {
      _temTamanho = senha.length >= 8;
      _temMaiuscula = _regexMaiuscula.hasMatch(senha);
      _temMinuscula = _regexMinuscula.hasMatch(senha);
      _temNumero = _regexNumero.hasMatch(senha);
      _temEspecial = _regexEspecial.hasMatch(senha);
    });
  }

  int get _pontos => [
    _temTamanho,
    _temMaiuscula,
    _temMinuscula,
    _temNumero,
    _temEspecial,
  ].where((e) => e).length;

  double get _forca => _pontos / 5;

  String get _rotuloForca {
    if (widget.controller.text.isEmpty) return '';
    switch (_pontos) {
      case 0:
      case 1:
        return 'Muito fraca';
      case 2:
        return 'Fraca';
      case 3:
        return 'Média';
      case 4:
        return 'Forte';
      default:
        return 'Muito forte';
    }
  }

  Color get _corForca {
    switch (_pontos) {
      case 0:
      case 1:
        return const Color(0xFFEF4444); // vermelho
      case 2:
        return const Color(0xFFF97316); // laranja
      case 3:
        return const Color(0xFFEAB308); // amarelo
      case 4:
        return const Color(0xFF84CC16); // verde-limão
      default:
        return const Color(0xFF22C55E); // verde
    }
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;
    final corTexto = cores.onSecondary;

    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 8, bottom: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cores.surfaceContainer.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: cores.surfaceContainer.withValues(alpha: 0.45),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sua senha deve conter:',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: corTexto,
              ),
            ),
            const SizedBox(height: 10),
            _ItemRequisito(
              texto: 'Pelo menos 8 caracteres',
              valido: _temTamanho,
              corTexto: corTexto,
            ),
            _ItemRequisito(
              texto: 'Uma letra maiúscula (A-Z)',
              valido: _temMaiuscula,
              corTexto: corTexto,
            ),
            _ItemRequisito(
              texto: 'Uma letra minúscula (a-z)',
              valido: _temMinuscula,
              corTexto: corTexto,
            ),
            _ItemRequisito(
              texto: 'Um número (0-9)',
              valido: _temNumero,
              corTexto: corTexto,
            ),
            _ItemRequisito(
              texto: 'Um caractere especial (@#\$%&*!?)',
              valido: _temEspecial,
              corTexto: corTexto,
            ),
            const SizedBox(height: 12),
            Text(
              'Força da senha:',
              style: TextStyle(
                fontSize: 12,
                color: corTexto.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Stack(
                children: [
                  Container(
                    height: 8,
                    color: cores.surfaceContainer.withValues(alpha: 0.35),
                  ),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: _forca),
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOut,
                    builder: (context, valor, _) => FractionallySizedBox(
                      widthFactor: valor,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        height: 8,
                        color: _corForca,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _rotuloForca.isEmpty
                  ? const SizedBox(width: double.infinity, height: 0)
                  : Padding(
                key: ValueKey(_rotuloForca),
                padding: const EdgeInsets.only(top: 6),
                child: Center(
                  child: Text(
                    _rotuloForca,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _corForca,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemRequisito extends StatelessWidget {
  final String texto;
  final bool valido;
  final Color corTexto;

  const _ItemRequisito({
    required this.texto,
    required this.valido,
    required this.corTexto,
  });

  static const _corValida = Color(0xFF22C55E);

  @override
  Widget build(BuildContext context) {
    final corInativa = corTexto.withValues(alpha: 0.45);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Icon(
              valido ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
              key: ValueKey(valido),
              size: 18,
              color: valido ? _corValida : corInativa,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: 13,
                color: valido ? _corValida : corInativa,
                fontWeight: valido ? FontWeight.w600 : FontWeight.normal,
              ),
              child: Text(texto),
            ),
          ),
        ],
      ),
    );
  }
}


String? validarSenhaForte(String? value) {
  if (value == null || value.isEmpty) return "Digite sua senha";
  if (value.length < 8) return "A senha precisa ter no mínimo 8 caracteres";
  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return "Adicione ao menos uma letra maiúscula";
  }
  if (!RegExp(r'[a-z]').hasMatch(value)) {
    return "Adicione ao menos uma letra minúscula";
  }
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return "Adicione ao menos um número";
  }
  if (!RegExp(r'[@#$%&*!?.]').hasMatch(value)) {
    return "Adicione um caractere especial (@#\$%&*!?)";
  }
  return null;
}