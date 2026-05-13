import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CabecalhoPadrao extends StatelessWidget implements PreferredSizeWidget {
  final String titulo;

  const CabecalhoPadrao({super.key, required this.titulo});


  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      foregroundColor: Theme.of(context).colorScheme.onSecondary,
      elevation: 0,
      actionsIconTheme: IconThemeData(color: Theme.of(context).colorScheme.onBackground),
      shape: Border(
        bottom: BorderSide(color: Color.fromARGB(255, 193, 195, 199), width: 1)),
      title: Text(
        titulo,
        style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onBackground),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Image.asset("assets/Images/Logo.png", fit: BoxFit.contain),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}