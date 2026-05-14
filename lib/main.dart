import 'package:espectrum_front/Config/tema_claro.dart';
import 'package:espectrum_front/View/Pages/home_aluno.dart';
import 'package:espectrum_front/View/Pages/tela_cadastro_paciente.dart';
import 'package:espectrum_front/View/Pages/tela_inicial.dart';
import 'package:espectrum_front/View/Pages/tela_perfis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main () {
  runApp(const MyApp());
}

  class MyApp extends StatelessWidget{
    const MyApp({super.key});
    @override
  Widget build(BuildContext context) {
      return MaterialApp(
        title: "Espectrum Savvy" ,
        theme: TemaClaro.tema,
        home: PaginaInicial(),
      );
    }
}