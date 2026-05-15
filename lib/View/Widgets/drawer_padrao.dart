import 'package:espectrum_front/View/Pages/home_adm.dart';
import 'package:espectrum_front/View/Pages/tela_suporte.dart';
import 'package:flutter/material.dart';
import 'package:espectrum_front/main.dart';

class DrawerPadrao extends StatelessWidget {
  const DrawerPadrao({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      shadowColor: Theme.of(context).colorScheme.onPrimary,
      backgroundColor: Theme.of(context).colorScheme.primary,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.onPrimary,
                  size: 36,
                ),
                SizedBox(height: 12),
                Text(
                  "Configurações",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          ListTile(
            leading: Icon(
              Icons.support_agent_rounded,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            title: Text(
              "Suporte e Ajuda",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.onPrimary),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => TelaSuporte(),));
              //Adicionar aquyr a logica de abrir a tela de suporte
            },
          ),


          Divider(height: 32,),

          // SwitchListTile(
          //   secondary: Icon(
          //     isDarkMode
          //     ? Icons.dark_mode : Icons.light_mode,
          //     color: Theme.of(context).colorScheme.primary,
          //       ),
          //       title: Text("Modo Escuro", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          //       ),
          //       value: isDarkMode,
          //       activeColor: Theme.of(context).colorScheme.primary,
          //       onChanged: (bool ligouModoEscuro) {
          //         temaApp.value = ligouModoEscuro ? ThemeMode.dark : ThemeMode.light;
          //       },
          // )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
