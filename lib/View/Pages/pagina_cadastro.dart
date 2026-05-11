import 'package:espectrum_front/View/Widgets/fundo_tela.dart';
import 'package:flutter/material.dart';

class TelaCadastro extends StatelessWidget {
  const TelaCadastro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FundoTela(
        child: SafeArea(
          child: SingleChildScrollView(

          ),
        ),
      ),
    );
  }
}
