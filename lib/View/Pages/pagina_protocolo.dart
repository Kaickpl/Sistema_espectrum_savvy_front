import 'package:espectrum_front/View/Widgets/cabecalho_padrao.dart';
import 'package:espectrum_front/View/Widgets/drawer_padrao.dart';
import 'package:flutter/material.dart';

class PaginaProtocolo extends StatefulWidget {
  const PaginaProtocolo({super.key});

  @override
  State<PaginaProtocolo> createState() => _PaginaProtocoloState();
}

class _PaginaProtocoloState extends State<PaginaProtocolo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CabecalhoPadrao(titulo: "Protocolo Soccially Savvy"),
      endDrawer: DrawerPadrao(  ),
      body: Center(
        child: SafeArea(bottom: false, child: SingleChildScrollView()),
      ),
    );
  }
}
