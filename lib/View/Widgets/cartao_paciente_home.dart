import 'package:flutter/material.dart';

class CartaoPacienteHome extends StatelessWidget {
  final String nomePaciente;
  final DateTime data;
  final int nivel;
  final int idade; 
  const CartaoPacienteHome({
    super.key,
    required this.nomePaciente,
    required this.data,
    required this.nivel,
    required this.idade
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: 375,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color.fromRGBO(243, 244, 246, 1),
          width: 5
        )
      ),
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(nomePaciente, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),),
                Text('Última avaliação:', style: TextStyle(fontSize: 12, color: Colors.grey),),
                Text('${data.day}/${data.month}/${data.year}', style: TextStyle(fontSize: 12, color: Colors.grey),)
              ],
            ),
            Container(
              height: 70,
              width: 130,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(254, 243, 199, 1),
                borderRadius: BorderRadius.circular(30)
              ),
              child: Row(children: [
                SizedBox(width: 7),
                Icon(Icons.circle, color: const Color.fromARGB(255, 225, 166, 65), size: 12,),
                SizedBox(width: 10,),
                Expanded(child: Text('Em progresso', style: TextStyle(color: const Color.fromARGB(255, 216, 163, 71), fontSize: 16), )
                )
          
              ]),
            )
          ],),
          SizedBox(height: 20,),
          Row(
            children: [
              Container(
                width: 60,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(224, 242, 241, 1),
                  borderRadius: BorderRadius.circular(10)
                ),
                alignment: Alignment.center,
                child: Text('Nível ${nivel}', style: TextStyle(fontSize: 14, color: Color.fromRGBO(100, 116, 139, 1))),
              ),
              SizedBox(width: 5,),
              Container(
                width: 60,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(243, 244, 246, 1),
                  borderRadius: BorderRadius.circular(10)
                ),
                alignment: Alignment.center,
                child: Text('TEA', style: TextStyle(fontSize: 14, color: Color.fromRGBO(100, 116, 139, 1)),),
              ),
              SizedBox(width: 5,),
              Container(
                width: 60,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(243, 244, 246, 1),
                  borderRadius: BorderRadius.circular(10)
                ),
                alignment: Alignment.center,
                child: Text('${idade} Anos', style: TextStyle(fontSize: 14, color: Color.fromRGBO(100, 116, 139, 1))),
              )
            
            ],
          ),
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 60,
                width: 150,
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(99, 102, 241, 1),
                  borderRadius: BorderRadius.circular(15)
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.play_arrow, color: Colors.white,),
                    SizedBox(width: 10,),
                    Text('Continuar', style: TextStyle(color: Colors.white, fontSize: 16),)
                  ],
                ),
              ),
              Container(
                height: 60,
                width: 150,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: const Color.fromARGB(26, 123, 130, 130),
                    width: 3
                  )
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.description, color: const Color.fromRGBO(99, 102, 241, 1),),
                    SizedBox(width: 10,),
                    Text('Histórico', style: TextStyle(color: const Color.fromRGBO(99, 102, 241, 1), fontSize: 16),)
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}