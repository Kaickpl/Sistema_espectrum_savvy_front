import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class TelaPdf extends StatelessWidget {
  final String caminho;
  final String titulo;

  const TelaPdf({
    super.key,
    required this.caminho,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(titulo),
      ),
      body: SfPdfViewer.asset(caminho),
    );
  }
}