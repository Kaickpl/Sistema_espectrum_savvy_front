import 'package:espectrum_front/View/Widgets/drawer_padrao.dart';
import 'package:flutter/material.dart';

class PaginaQuestoesCategoria extends StatefulWidget {
  final String nomeCategoria;
  final int totalDeQuestoes;

  const PaginaQuestoesCategoria({super.key, required this.nomeCategoria, required this.totalDeQuestoes});

  @override
  State<PaginaQuestoesCategoria> createState() => _PaginaQuestoesCategoriaState();
}

class _PaginaQuestoesCategoriaState extends State<PaginaQuestoesCategoria> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nomeCategoria, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onBackground)),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: Theme.of(context).colorScheme.onBackground, size: 28,),
          onPressed: () => Navigator.pop(context),
        ),
        shape: Border(
        bottom: BorderSide(color: Color.fromARGB(255, 193, 195, 199), width: 1)),
      ),
      body: Center(
        child: Text('Conteúdo da página de questões da categoria'),
      ),
      endDrawer: DrawerPadrao(),
    );
  }
}
