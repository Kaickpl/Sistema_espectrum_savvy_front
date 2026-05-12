import 'package:espectrum_front/View/Widgets/botao_grande.dart';
import 'package:espectrum_front/View/Widgets/cartao_paciente_home.dart';
import 'package:flutter/material.dart';

class HomeAluno extends StatelessWidget {
  const HomeAluno({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => print("Menu aberto"),
            icon: Icon(Icons.menu)  
          ),
          title: Text('SociallySavvy'),
          actions: [
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.search)
            ),
            IconButton(
              onPressed: (){}, 
              icon: Icon(Icons.notifications)
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: CircleAvatar(backgroundColor: const Color.fromARGB(255, 208, 131, 131), radius: 15,),
            )
          ],
        ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(99, 102, 241, 1),
                borderRadius: BorderRadius.circular(20)
              ),
            ),
            //boas vindas e informações básicas
            Container(
              height: 193,
              width: 343,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 5,),
                  Text('Bem vindo ao Espectrum Savvy!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  SizedBox(height: 15,),
                  Text('Nosso App tem como intuito ajudar no preenchimento e realização do protocolo Socially Savvy',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300, color: Colors.black54)),
                ],
              )
                 
    
            ),
            //informações
            Container(
              height: 145,
              width: 343,
              decoration: BoxDecoration(
                color: const Color.fromARGB(168, 228, 237, 250),
                borderRadius: BorderRadius.circular(20)
              ),
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(children: [
                    Icon(Icons.info, color: const Color.fromRGBO(59, 130, 246, 1),),
                    SizedBox(width: 12,),
                    Text('Dúvidas quanto ao protocolo?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w100, color: const Color.fromARGB(160, 30, 59, 138)),),
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
                      colors: [
                        Theme.of(context).colorScheme.tertiary,
                        Theme.of(context).colorScheme.secondary,
                      ],
                    ),
                  ),
                  child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  onPressed: () {
                  print('Botão pressionada!');
                }, child: Text("Informações", style: TextStyle(fontSize: 14, color: Colors.white),)),
                )
                
                
              ],),
            ),
            SizedBox(height: 20,),
            Text('Que bom ter você de volta, fulano!', style: TextStyle(fontSize: 25),),
            SizedBox(height: 20,),
            Container(
              height: 96,
              width: 343,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(84, 87, 198, 1),
                borderRadius: BorderRadius.circular(20)
              ),
              child:
                  Padding(padding: EdgeInsets.all(16), 
                  child: Column(children: [
                      Text('Você tem X testes em andamento', style: TextStyle(color: Colors.white),),
                      SizedBox(height: 20,),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          height: 12,
                          child: LinearProgressIndicator(
                          backgroundColor: const Color.fromARGB(255, 100, 125, 223),
                          value: 0.5,
                          color: const Color.fromRGBO(181, 205, 237, 1),
                        ),
                        ),
                      )
              
                    ],
                  ),
                  )
            ),
            SizedBox(height: 20,),
            Container(
              height: 70,
              width: 343,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(239, 246, 255, 1),
                borderRadius: BorderRadius.circular(10)
              ),
              padding: EdgeInsets.all(15),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue,),
                  SizedBox(width: 10,),
                  Text('Testes em andamento:')],
              ),
            ),
            SizedBox(height: 20,),
            CartaoPacienteHome(nomePaciente: 'gabi', data:DateTime(2026, 12, 25, 20, 30), nivel: 3, idade: 2),
            SizedBox(height: 20,),
            CartaoPacienteHome(nomePaciente: 'aaaa', data: DateTime(2026, 12, 25, 20, 30), nivel:1, idade: 5),
            SizedBox(height: 20,),
            BotaoGrande(texto: 'Histórico dos pacientes'),
            SizedBox(height: 20,),
            BotaoGrande(texto: 'Iniciar protocolo')
            
          ],
        ),
      ),
    );
  }
}