import 'package:flutter/material.dart';

class AppBarPadrao extends StatefulWidget implements PreferredSizeWidget {
  final String nome;
  final List<Widget>? actions;

  const AppBarPadrao({super.key, required this.nome, this.actions});


  @override
  State<AppBarPadrao> createState() => _AppBarPadraoState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

}

class _AppBarPadraoState extends State<AppBarPadrao> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      title: Text(widget.nome,style:TextStyle(fontWeight: FontWeight(16),color: Theme.of(context).colorScheme.onSurface),
      ),
      actions: [
      ],



    );
  }
}
