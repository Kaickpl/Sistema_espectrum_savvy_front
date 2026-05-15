import 'package:espectrum_front/View/Widgets/botao_grande.dart';
import 'package:espectrum_front/View/Widgets/cabecalho_padrao.dart';
import 'package:espectrum_front/View/Widgets/cartao_paciente_home.dart';
import 'package:flutter/material.dart';

class HomeAluno extends StatelessWidget {
  const HomeAluno({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;

    return Scaffold(
      backgroundColor: tema.scaffoldBackgroundColor,
      appBar: CabecalhoPadrao(titulo: 'Socially Savvy'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 64,
              width: 64,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: cores.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Image.asset(
                "assets/Images/Logo.png",
                fit: BoxFit.fitWidth,
              ),
            ),

            // boas vindas
            SizedBox(
              height: 193,
              width: 343,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    'Bem vindo ao Espectrum Savvy!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: cores.onSurface,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Nosso App tem como intuito ajudar no preenchimento e realização do protocolo Socially Savvy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w300,
                      color: cores.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),

            // card de duvidas
            Container(
              height: 145,
              width: 343,
              decoration: BoxDecoration(
                color: cores.onPrimary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.info, color: cores.tertiary),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Dúvidas quanto ao protocolo?',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w100,
                              color: cores.tertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 301,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [cores.tertiary, cores.secondary],
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => print('Botão pressionado!'),
                      child: const Text(
                        "Informações",
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            Text(
              'Que bom ter você de volta, fulano!',
              style: TextStyle(fontSize: 25, color: cores.onSurface),
            ),
            const SizedBox(height: 20),

            // card de progresso
            Container(
              height: 96,
              width: 343,
              decoration: BoxDecoration(
                color: cores.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      'Você tem X testes em andamento',
                      style: TextStyle(color: cores.onPrimary),
                    ),
                    const SizedBox(height: 20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: 12,
                        child: LinearProgressIndicator(
                          backgroundColor: cores.onPrimary.withOpacity(0.3),
                          value: 0.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            cores.secondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // lista de testes
            Container(
              height: 70,
              width: 343,
              decoration: BoxDecoration(
                color: cores.surface,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Icon(Icons.info, color: cores.primary),
                  const SizedBox(width: 10),
                  Text(
                    'Testes em andamento:',
                    style: TextStyle(color: cores.onSurface),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            CartaoPacienteHome(
              nomePaciente: 'gabi',
              data: DateTime(2026, 12, 25, 20, 30),
              nivel: 3,
              idade: 2,
              status: 'em progresso',
              corStatus: const Color.fromARGB(255, 216, 163, 71),
            ),
            const SizedBox(height: 20),
            CartaoPacienteHome(
              nomePaciente: 'aaaa',
              data: DateTime(2026, 12, 25, 20, 30),
              nivel: 1,
              idade: 5,
              status: 'em progresso',
              corStatus: const Color.fromARGB(255, 216, 163, 71),
            ),
            const SizedBox(height: 20),
            const BotaoGrande(texto: 'Histórico dos pacientes'),
            const SizedBox(height: 20),
            const BotaoGrande(texto: 'Iniciar protocolo'),
          ],
        ),
      ),
    );
  }
}
