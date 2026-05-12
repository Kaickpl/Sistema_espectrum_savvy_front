import 'package:flutter/material.dart';

class DrawerPadrao extends StatelessWidget implements PreferredSizeWidget {
  const DrawerPadrao({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shadowColor: Theme.of(context).colorScheme.onSecondary,
      backgroundColor: Theme.of(context).colorScheme.secondary,
      child: ListView(padding: EdgeInsets.zero,),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}