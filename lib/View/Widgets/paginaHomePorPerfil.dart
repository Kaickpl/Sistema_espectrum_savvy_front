import 'package:espectrum_front/View/Pages/home_adm.dart';
import 'package:espectrum_front/View/Pages/home_aluno.dart';
import 'package:espectrum_front/View/Pages/home_professor.dart';
import 'package:espectrum_front/View/Pages/home_responsavel.dart';
import 'package:flutter/material.dart';

/// Retorna a tela inicial correta de acordo com o perfil (ex: "ROLE_ADMIN")
/// retornado pelo backend no login.
Widget paginaHomePorPerfil(String perfil) {
  switch (perfil) {
    case 'ROLE_ADMIN':
      return const HomeAdm();
    case 'ROLE_TERAPEUTA':
      return const HomeAluno();
    case 'ROLE_PROFESSOR':
      return HomeProfessor();
    case 'ROLE_RESPONSAVEL':
      return HomeResponsavel();
    default:
      return const HomeAluno();
  }
}
