import 'package:espectrum_front/View/Pages/tela_pdf.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ConteinerTermoDeUsoPrivacidade extends StatefulWidget {
  final ValueChanged<bool>? onChanged;

  const ConteinerTermoDeUsoPrivacidade({super.key, this.onChanged});

  @override
  State<ConteinerTermoDeUsoPrivacidade> createState() =>
      _ConteinerTermoDeUsoPrivacidadeState();
}

class _ConteinerTermoDeUsoPrivacidadeState
    extends State<ConteinerTermoDeUsoPrivacidade> {
  bool _aceito = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.onPrimary,
      borderRadius: BorderRadius.circular(10),
      elevation: 2,
      child: Row(
        children: [
          SizedBox(
            width: 30,
            height: 32,
            child: Checkbox(
              value: _aceito,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              onChanged: (value) {
                setState(() => _aceito = value ?? false);
                widget.onChanged?.call(_aceito);
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  color: Theme
                      .of(context)
                      .colorScheme
                      .onSurface,
                  fontSize: 13,
                ),
                children: [
                  const TextSpan(text: 'Eu concordo com os '),
                  TextSpan(
                    text: 'Termos de uso',
                    style: TextStyle(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .secondary,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(context, MaterialPageRoute(builder: (
                            _) => const TelaPdf(titulo: 'Termo de uso', caminho: 'assets/PDF/termo.pdf',),
                        ),
                        );
                      },
                  ),
                  const TextSpan(text: ' e com a '),
                  TextSpan(
                    text: 'Política de Privacidade',
                    style: TextStyle(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .secondary,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(context, MaterialPageRoute(builder: (
                            _) => const TelaPdf(titulo: 'Politica de privacidade', caminho: 'assets/PDF/privacidade.pdf',),
                        ),
                        );

                      },
                  ),
                  const TextSpan(text: ' do Espectrum Savvy'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
