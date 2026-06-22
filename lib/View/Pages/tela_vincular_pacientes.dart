// tela_vincular_pacientes.dart
import 'package:flutter/material.dart';

class _Aluno {
  final String nome;
  final int numPacientes;
  const _Aluno({required this.nome, required this.numPacientes});
}

class _Paciente {
  final String nome;
  final String idade;
  bool vinculado;
  _Paciente({required this.nome, required this.idade, this.vinculado = false});
}

class TelaVincularPacientes extends StatefulWidget {
  final String? nomeAlunoPreSelecionado;

  const TelaVincularPacientes({super.key, this.nomeAlunoPreSelecionado});

  @override
  State<TelaVincularPacientes> createState() => _TelaVincularPacientesState();
}

class _TelaVincularPacientesState extends State<TelaVincularPacientes> {
  
  // mock de alunos
  final List<_Aluno> _alunos = const [
    _Aluno(nome: 'Ana Souza', numPacientes: 4),
    _Aluno(nome: 'Carlos Mendes', numPacientes: 0),
    _Aluno(nome: 'Beatriz Lima', numPacientes: 2),
    _Aluno(nome: 'João Pedro', numPacientes: 1),
  ];

  // mock de pacientes
  final List<_Paciente> _pacientes = [
    _Paciente(nome: 'Maria Oliveira', idade: '8 anos'),
    _Paciente(nome: 'Pedro Santos', idade: '10 anos'),
    _Paciente(nome: 'Lucas Pereira', idade: '6 anos'),
    _Paciente(nome: 'Sofia Costa', idade: '9 anos'),
    _Paciente(nome: 'Gabriel Rocha', idade: '7 anos'),
    _Paciente(nome: 'Helena Martins', idade: '11 anos'),
  ];

  int? _alunoSelecionado;
  String _busca = '';

  @override
  void initState() {
    super.initState();
    if (widget.nomeAlunoPreSelecionado != null) {
      final index = _alunos.indexWhere(
        (a) => a.nome == widget.nomeAlunoPreSelecionado,
      );
      if (index != -1) {
        _alunoSelecionado = index;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final cores = tema.colorScheme;
    final corFundo = tema.scaffoldBackgroundColor;
    final isDark = tema.brightness == Brightness.dark;

    final pacientesFiltrados = _pacientes
        .where((p) => p.nome.toLowerCase().contains(_busca.toLowerCase()))
        .toList();

    final qtdSelecionados = _pacientes.where((p) => p.vinculado).length;

    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        backgroundColor: corFundo,
        elevation: 0,
        foregroundColor: cores.onSurface,
        title: const Text('Vincular Pacientes'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Selecione o aluno',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: cores.onSurface.withOpacity(0.85),
              ),
            ),
            const SizedBox(height: 12),

            // Dropdown de aluno
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isDark
                    ? cores.surface.withOpacity(0.45)
                    : cores.surfaceContainer.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cores.onSurface.withOpacity(0.06)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  value: _alunoSelecionado,
                  isExpanded: true,
                  hint: Text(
                    'Escolha um aluno de psicologia',
                    style: TextStyle(color: cores.onSurface.withOpacity(0.5)),
                  ),
                  icon: Icon(Icons.keyboard_arrow_down, color: cores.primary),
                  dropdownColor: isDark
                      ? const Color(0xFF1E293B)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  items: List.generate(_alunos.length, (index) {
                    final aluno = _alunos[index];
                    return DropdownMenuItem<int>(
                      value: index,
                      child: Row(
                        children: [
                          Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              color: cores.primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Icon(
                              Icons.person,
                              color: cores.primary,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              aluno.nome,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: cores.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Text(
                            '${aluno.numPacientes} pac.',
                            style: TextStyle(
                              fontSize: 12,
                              color: cores.onSurface.withOpacity(0.4),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  onChanged: (value) {
                    setState(() => _alunoSelecionado = value);
                  },
                ),
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pacientes disponíveis',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: cores.onSurface.withOpacity(0.85),
                  ),
                ),
                if (qtdSelecionados > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: cores.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$qtdSelecionados selecionado(s)',
                      style: TextStyle(
                        color: cores.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // busca
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? cores.surface.withOpacity(0.45)
                    : cores.surfaceContainer.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cores.onSurface.withOpacity(0.06)),
              ),
              child: TextField(
                onChanged: (value) => setState(() => _busca = value),
                style: TextStyle(color: cores.onSurface),
                decoration: InputDecoration(
                  hintText: 'Buscar paciente...',
                  hintStyle: TextStyle(color: cores.onSurface.withOpacity(0.4)),
                  prefixIcon: Icon(
                    Icons.search,
                    color: cores.onSurface.withOpacity(0.4),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // lista de pacientes
            Expanded(
              child: pacientesFiltrados.isEmpty
                  ? Center(
                      child: Text(
                        'Nenhum paciente encontrado',
                        style: TextStyle(
                          color: cores.onSurface.withOpacity(0.4),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: pacientesFiltrados.length,
                      itemBuilder: (context, index) {
                        final paciente = pacientesFiltrados[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: paciente.vinculado
                                ? cores.primary.withOpacity(0.10)
                                : (isDark
                                    ? cores.surface.withOpacity(0.45)
                                    : cores.surfaceContainer.withOpacity(0.15)),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: paciente.vinculado
                                  ? cores.primary.withOpacity(0.4)
                                  : cores.onSurface.withOpacity(0.06),
                            ),
                          ),
                          child: CheckboxListTile(
                            value: paciente.vinculado,
                            onChanged: (value) {
                              setState(() {
                                paciente.vinculado = value ?? false;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: cores.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            title: Text(
                              paciente.nome,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: cores.onSurface,
                              ),
                            ),
                            subtitle: Text(
                              paciente.idade,
                              style: TextStyle(
                                fontSize: 12,
                                color: cores.onSurface.withOpacity(0.5),
                              ),
                            ),
                            secondary: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                color: cores.tertiary.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.person_outline,
                                color: cores.tertiary,
                                size: 20,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            const SizedBox(height: 8),

            // botão de confirmar
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cores.primary,
                  foregroundColor: cores.onPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  disabledBackgroundColor: cores.primary.withOpacity(0.3),
                ),
                onPressed: (_alunoSelecionado != null && qtdSelecionados > 0)
                    ? () {
                        final aluno = _alunos[_alunoSelecionado!];
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '$qtdSelecionados paciente(s) vinculado(s) a ${aluno.nome}',
                            ),
                            backgroundColor: cores.primary,
                          ),
                        );
                        Navigator.pop(context);
                      }
                    : null,
                icon: const Icon(Icons.link),
                label: const Text(
                  'Vincular pacientes selecionados',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}