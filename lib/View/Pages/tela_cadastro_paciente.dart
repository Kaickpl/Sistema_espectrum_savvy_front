import 'package:flutter/material.dart';

import '../Widgets/app_bar_padrao.dart';
import '../Widgets/categoria_input.dart';
import '../Widgets/logo_container.dart';
import '../Widgets/roda_pe.dart';
import '../Widgets/widget_input_acesso.dart';
import '../Widgets/widget_termo_uso_privacidade.dart';

class CadastroPaciente extends StatefulWidget {
  const CadastroPaciente({super.key});

  @override
  State<CadastroPaciente> createState() => _CadastroPacienteState();
}

class _CadastroPacienteState extends State<CadastroPaciente> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController dataNascimentoController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      appBar: AppBarPadrao(nome: "Cadastro de Paciente"),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                LogoContainer(nomePage: "Cadastro de Paciente",imagem: "assets/Images/Logo.png",),

                const SizedBox(height: 12),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.055,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 355),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CategoriaAtributos(
                        nome: "Dados do Paciente",
                        icone: Icons.person,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                CampoTexto(
                  label: "Nome Completo",
                  hintText: "Digite o nome completo",
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "O campo não pode ser em vazio";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                CampoTexto(
                  label: "CPF",
                  hintText: "000.000.000-00",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "O campo não pode ser em vazio";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.055,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 355),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Data de Nascimento",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),

                        const SizedBox(height: 6),

                        DecoratedBox(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).colorScheme.onSurface,
                                blurRadius: 8,
                              ),
                            ],
                          ),

                          child: TextFormField(
                            controller: dataNascimentoController,
                            readOnly: true,

                            decoration: InputDecoration(
                              hintText: "00/00/0000",

                              filled: true,
                              fillColor: Colors.white,

                              suffixIcon: const Icon(Icons.calendar_month),

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),

                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),

                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1.5,
                                ),
                              ),

                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                              ),

                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.error,
                                  width: 1.5,
                                ),
                              ),
                            ),

                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Selecione a data";
                              }
                              return null;
                            },

                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now(),
                              );

                              if (pickedDate != null) {
                                setState(() {
                                  dataNascimentoController.text =
                                  "${pickedDate.day.toString().padLeft(2, '0')}/"
                                      "${pickedDate.month.toString().padLeft(2, '0')}/"
                                      "${pickedDate.year}";
                                });
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12,),

                CampoTexto(
                  label: "Escola",
                  hintText: "Nome da escola",
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "O campo não pode ser em vazio";
                    }
                    return null;
                  },
                ),

                SizedBox(height: 12),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.055,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 355),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CategoriaAtributos(
                        nome: "Dados Responsável",
                        icone: Icons.supervisor_account,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12),

                CampoTexto(
                  label: "Nome do Responsável",
                  hintText:
                  "Nome completo do responsável",
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "O campo não pode ser em vazio";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                CampoTexto(
                  label: "Número do Responsável",
                  hintText: "(00) 00000-0000",
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "O campo não pode ser em vazio";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * 0.055,
                  ),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 355),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CategoriaAtributos(
                        nome: "Endereço",
                        icone: Icons.location_on,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                CampoTexto(
                  label: "Rua",
                  hintText: "Nome da rua",
                  keyboardType:
                  TextInputType.streetAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "O campo não pode ser em vazio";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal:
                    MediaQuery.of(context).size.width *
                        0.055,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: CampoTexto(
                          label: "Número",
                          hintText: "123",
                          keyboardType:
                          TextInputType.number,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty) {
                              return "Digite o número";
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: CampoTexto(
                          label: "CEP",
                          hintText: "00000-000",
                          keyboardType:
                          TextInputType.number,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty) {
                              return "Digite o CEP";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                CampoTexto(
                  label: "Bairro",
                  hintText: "Nome do bairro",
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Digite o bairro";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 12),

                CampoTexto(
                  label: "Complemento",
                  hintText:
                  "Apto, bloco, etc. (opcional)",
                  keyboardType: TextInputType.text,
                ),


                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.055),
                  child: ConteinerTermoDeUsoPrivacidade(),
                ),
                SizedBox(height: 12,),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!
                            .validate()) {
                          //
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        Theme.of(context)
                            .colorScheme
                            .primary,
                        foregroundColor:
                        Theme.of(context)
                            .colorScheme
                            .onPrimary,
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Salvar Cadastro",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                          FontWeight.bold,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface,
                        ),
                      ),
                    ),

                    SizedBox(width: 12),

                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Cancelar",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
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