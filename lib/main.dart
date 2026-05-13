import 'package:espectrum_front/Config/tema_claro.dart';
import 'package:espectrum_front/Config/tema_escuro.dart';
import 'package:espectrum_front/View/Pages/pagina_inicial.dart';
import 'package:espectrum_front/View/Pages/pagina_protocolo.dart';
import 'package:flutter/material.dart';

void main () {
  runApp(const MyApp());
}

  class MyApp extends StatelessWidget{
    const MyApp({super.key});
    @override
  Widget build(BuildContext context) {
      return MaterialApp(
        title: "Espectrum Savvy",
        theme: TemaClaro.tema,
        darkTheme: TemaEscuro.tema,
        home: PaginaInicial (),
      );
    }
}