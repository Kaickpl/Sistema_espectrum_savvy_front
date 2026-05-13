import 'package:espectrum_front/View/Widgets/categoria_input.dart';
import 'package:espectrum_front/View/Widgets/logo_container.dart';
import 'package:espectrum_front/View/Widgets/roda_pe.dart';
import 'package:flutter/material.dart';
import '../Widgets/app_bar_padrao.dart';
import '../Widgets/widget_termo_uso_privacidade.dart';
import '../Widgets/widget_input_acesso.dart';

class CadastroEstagiario extends StatefulWidget {
  const CadastroEstagiario({super.key});

  @override
  State<CadastroEstagiario> createState() => _CadastroEstagiarioState();
}

class _CadastroEstagiarioState extends State<CadastroEstagiario> {
  final _formKey = GlobalKey<FormState>();
  bool obscureTextSenha = true;
  bool obscureTextConfirma = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarPadrao(nome: "Cadastro"),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                LogoContainer(nomePage: 'Cadastro Estágiario'),
                SizedBox(height: 12),
                CategoriaAtributos(nome: "Dados Estágiario      ",icone: Icons.person,),
                SizedBox(height: 12,),
                CampoTexto(
                  label: "Nome Completo",
                  hintText: "Digite seu nome completo",
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "O campo não pode ser em branco";
                    return null;
                  },
                ),
                SizedBox(height: 12),
                CampoTexto(
                  label: "Email",
                  hintText: "Digite seu email",
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "O campo não pode ser em vazio";
                    if (!value.contains("@")) return "Email inválido";
                    return null;
                  },
                ),
                SizedBox(height: 12),
                CampoTexto(
                  label: "Número de Telefone",
                  hintText: "(11) 99999-9999",
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "O campo não pode ser em vazio";
                    return null;
                  },
                ),
                SizedBox(height: 12),
                CampoTexto(
                  label: "CPF",
                  hintText: "000.000.000-00",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "O campo não pode ser em vazio";
                    return null;
                  },
                ),
                SizedBox(height: 12),

                CategoriaAtributos(nome: "Dados Acadêmicos ",icone: Icons.work,),
                SizedBox(height: 12,),

                CampoTexto(
                  label: "Matrícula",
                  hintText: "Digite sua matrícula",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "O campo não pode ser em vazio";
                    return null;
                  },
                ),
                SizedBox(height: 12),

                CategoriaAtributos(nome: "Dados de Seguraça ",icone: Icons.security,),
                SizedBox(height: 12,),


                CampoTexto(
                  label: "Senha",
                  hintText: "Digite sua senha",
                  keyboardType: TextInputType.text,
                  obscureText: obscureTextSenha,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Digite sua senha";
                    return null;
                  },
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureTextSenha = !obscureTextSenha;
                      });
                    },
                    icon: Icon(
                      obscureTextSenha
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
                SizedBox(height: 12),

                CampoTexto(
                  label: "Confirmar Senha",
                  hintText: "Repita sua senha",
                  keyboardType: TextInputType.text,
                  obscureText: obscureTextConfirma,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Confirme sua senha";
                    return null;
                  },
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureTextConfirma = !obscureTextConfirma;
                      });
                    },
                    icon: Icon(
                      obscureTextConfirma
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                ),
                SizedBox(height: 12,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ConteinerTermoDeUsoPrivacidade(),
                ),

                SizedBox(height: 12,),

                SizedBox(

                  child: ElevatedButton(

                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                      //Navigator.push(context, MaterialPageRoute(builder: (context)=> const Home());
                    }},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(vertical: 16,horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Cadastrar",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.onSurface),
                    ),
                  ),
                ),
                SizedBox(height: 12),

                RodaPe(),

              ],
            ),
          ),
        ),
      ),
    );
  }
}