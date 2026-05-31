import 'package:espectrum_front/Config/tema_claro.dart';
import 'package:espectrum_front/Config/tema_escuro.dart';

import 'package:espectrum_front/View/Pages/tela_inicial.dart';

import 'package:flutter/material.dart';

ValueNotifier<ThemeMode> temaApp =
ValueNotifier(ThemeMode.light);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(
      valueListenable: temaApp,

      builder: (context, ThemeMode modoAtual, child) {

        return MaterialApp(
          title: "Espectrum Savvy",

          debugShowCheckedModeBanner: false,
          themeMode: modoAtual,
          theme: TemaClaro.tema,
          darkTheme: TemaEscuro.tema,

          home: PaginaInicial(),
        );
      },
    );
  }
}