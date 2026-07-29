import 'package:espectrum_front/View/Widgets/cabecalho_padrao.dart';
import 'package:espectrum_front/View/Widgets/categoria_protocolo.dart';
import 'package:espectrum_front/View/Widgets/drawer_padrao.dart';
import 'package:flutter/material.dart';
import 'package:espectrum_front/View/Widgets/info_questoes_e_nome_paciente.dart';
import 'package:espectrum_front/Model/Protocolo/ProtocoloSessaoModel.dart';
import 'package:espectrum_front/Services/ProtocoloService.dart';
import 'package:espectrum_front/Services/ComentarioService.dart';
import 'package:espectrum_front/Services/TokenStorage.dart';

class PaginaProtocolo extends StatefulWidget {
  final String pacienteId;
  final String nomePaciente;
  const PaginaProtocolo({
    super.key,
    required this.pacienteId,
    required this.nomePaciente,
  });

  @override
  State<PaginaProtocolo> createState() => _PaginaProtocoloState();
}

class _PaginaProtocoloState extends State<PaginaProtocolo> {
  ProtocoloSessaoModel? sessaoAtual;
  bool isLoading = true;
  final TextEditingController _comentarioController = TextEditingController();
  String _ultimoComentarioSalvo = "";

  // Professor e responsável podem aplicar o protocolo, mas não finalizá-lo.
  bool _podeFinalizar = true;

  @override
  void initState() {
    super.initState();
    _carregarSessaoDoBackend();
    _verificarPermissaoFinalizar();
  }

  Future<void> _verificarPermissaoFinalizar() async {
    final perfil = await TokenStorage.lerPerfil();
    if (mounted) {
      setState(() {
        _podeFinalizar =
            perfil != 'ROLE_PROFESSOR' && perfil != 'ROLE_RESPONSAVEL';
      });
    }
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  Future<void> _carregarSessaoDoBackend() async {
    try {
      final protocoloSessao = await ProtocoloService.iniciarSessao(
        widget.pacienteId,
      );
      setState(() {
        sessaoAtual = protocoloSessao;
        isLoading = false;
      });
      _carregarComentario();
    } catch (e) {
      print("Erro ao carregar a sessão do protocolo: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _carregarComentario() async {
    if (sessaoAtual == null) return;
    try {
      final comentarios = await ComentarioService.buscarComentariosProtocolo(
        sessaoAtual!.id,
      );
      if (comentarios.isEmpty || !mounted) return;

      comentarios.sort(
        (a, b) => (b.dataCriacao ?? DateTime(0)).compareTo(
          a.dataCriacao ?? DateTime(0),
        ),
      );
      setState(() {
        _comentarioController.text = comentarios.first.comentario;
        _ultimoComentarioSalvo = comentarios.first.comentario;
      });
    } catch (e) {
      print("Erro ao carregar comentário do protocolo: $e");
    }
  }

  Future<void> _salvarComentarioSeNecessario() async {
    if (sessaoAtual == null) return;
    final texto = _comentarioController.text.trim();
    if (texto.isEmpty || texto == _ultimoComentarioSalvo) return;
    try {
      await ComentarioService.comentarProtocolo(sessaoAtual!.id, texto);
      _ultimoComentarioSalvo = texto;
    } catch (e) {
      print("Erro ao salvar comentário do protocolo: $e");
    }
  }

  Future<void> _finalizarSessao() async {
    if (sessaoAtual == null) return;

    // Calcula total de questões e quantas já foram respondidas
    int totalQuestoes = 0;
    int respondidas = 0;

    for (var categoria in sessaoAtual!.categoriasSessao) {
      totalQuestoes += categoria.atividades.length;
      respondidas += categoria.atividades
          .where((ativ) => ativ.pontuacao != null)
          .length;
    }

    // Calcula quantas questões ainda faltam
    int questoesFaltantes = totalQuestoes - respondidas;

    // Define a mensagem dinâmica do alerta
    String mensagemAlerta = questoesFaltantes > 0
        ? "Ainda faltam $questoesFaltantes questões para serem respondidas.\n\nTem certeza que deseja finalizar o protocolo incompleto?"
        : "Todas as questões foram respondidas!\n\nConfirma a finalização do protocolo?";

    // Exibe o popup de confirmação
    bool? confirmou = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Finalizar Protocolo",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(mensagemAlerta, style: TextStyle(color: Colors.white)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, false), // Retorna false se cancelar
              child: const Text(
                "Cancelar",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            ElevatedButton(
              onPressed: () =>
                  Navigator.pop(context, true), // Retorna true se confirmar
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Finalizar",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );

    // Se o usuário cancelou ou clicou fora, interrompemos a execução aqui
    if (confirmou != true) return;

    try {
      // Coloca a tela em modo de carregamento apenas se ele confirmou
      setState(() {
        isLoading = true;
      });

      await _salvarComentarioSeNecessario();

      // Chama a API para encerrar
      await ProtocoloService.encerrarSessao(sessaoAtual!.id);

      if (mounted) {
        // Mostra o alerta de sucesso verde
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Protocolo finalizado com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );

        // 🟢 MAGIA AQUI: Volta limpando todas as telas até chegar na Home (primeira tela)
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao finalizar a sessão: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleSalvar() async {
    if (sessaoAtual == null) return;

    try {
      await _salvarComentarioSeNecessario();
      await ProtocoloService.salvarProgresso(sessaoAtual!.id);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Progresso salvo com sucesso!"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao salvar: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (sessaoAtual == null) {
      return Scaffold(
        body: Center(child: Text("Erro ao encontrar os dados do protocolo.")),
      );
    }

    int totalQuestoes = 0;
    int respondidas = 0;

    for (var categoria in sessaoAtual!.categoriasSessao) {
      totalQuestoes += categoria.atividades.length;
      respondidas += categoria.atividades
          .where((ativ) => ativ.pontuacao != null)
          .length;
    }

    String nomeDoPacienteAtual =
        "${sessaoAtual!.pacienteNome ?? "Paciente Desconhecido"}";

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CabecalhoPadrao(
        titulo:
            "Protocolo: ${sessaoAtual!.pacienteNome ?? "Paciente Desconhecido"}",
      ),
      endDrawer: DrawerPadrao(),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InfoQuestoesENomePaciente(
                  nomePaciente: nomeDoPacienteAtual,
                  questoesRespondidas: respondidas,
                  totalDeQuestoes: totalQuestoes,
                  iconePrincipal: Icons.assignment,
                  tituloPrincipal: "Protocolo de Atendimento",
                  subtitulo:
                      "Protocolo Socially Savvy para análise\n do comportamento social no\n contexto da criança",
                  textoInstrucoes:
                      "Este protocolo foi desenvolvido para auxiliar na análise do comportamento social de crianças em diferentes contextos.",
                  comentarioController: _comentarioController,
                  tituloComentario: "Comentários sobre o protocolo",
                  dicaTextoComentario:
                      "Anote aqui suas observações gerais sobre o protocolo, comportamento da criança, etc.",
                ),

                SizedBox(height: 8),

                ...sessaoAtual!.categoriasSessao.map((categoriaApi) {
                  return CategoriaProtocolo(
                    nomeCategoria: categoriaApi.nomeCategoria,
                    nomePaciente: nomeDoPacienteAtual,
                    categoriaSessaoId: categoriaApi.id,
                    iconeCategoria: Icons.assignment_turned_in,
                    questoesDestaCategoria: categoriaApi.atividades,
                    aoAtualizar: () {
                      setState(() {});
                    },
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
          height: 50,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Row(
            children: [
              if (_podeFinalizar) ...[
                Expanded(
                  child: ElevatedButton(
                    onPressed: _finalizarSessao,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Finalizar",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],

              Expanded(
                child: ElevatedButton(
                  onPressed: _handleSalvar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Salvar",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
