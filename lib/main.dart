import 'package:espectrum_front/Config/tema_claro.dart';
import 'package:espectrum_front/Config/tema_escuro.dart';
import 'package:espectrum_front/View/Pages/Auth/tela_inicial.dart';
import 'package:espectrum_front/View/Pages/Home/home_aluno.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:espectrum_front/View/Pages/tela_splash.dart';

import 'package:flutter/material.dart';

ValueNotifier<ThemeMode> temaApp = ValueNotifier(ThemeMode.light);

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
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('pt', 'BR')],
          title: "Espectrum Savvy",

          debugShowCheckedModeBanner: false,
          themeMode: modoAtual,
          theme: TemaClaro.tema,
          darkTheme: TemaEscuro.tema,

          home: const HomeAluno(),
        );
      },
    );
  }
}
