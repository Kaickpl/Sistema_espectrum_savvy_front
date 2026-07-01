enum Perfil {
  ROLE_SUPERVISOR_ESTAGIO,
  roleTerapeuta,
  roleResponsavel,
  roleProfessor;

  /// Converte a string vinda do backend (ex: "ROLE_ADMIN") para o enum
  static Perfil fromString(String value) {
    switch (value) {
      case 'ROLE_SUPERVISOR_ESTAGIO':
        return Perfil.ROLE_SUPERVISOR_ESTAGIO;
      case 'ROLE_TERAPEUTA':
        return Perfil.roleTerapeuta;
      case 'ROLE_RESPONSAVEL':
        return Perfil.roleResponsavel;
      case 'ROLE_PROFESSOR':
        return Perfil.roleProfessor;
      default:
        throw ArgumentError('Perfil desconhecido: $value');
    }
  }

  /// Nome amigável para exibir na tela
  String get displayName {
    switch (this) {
      case Perfil.ROLE_SUPERVISOR_ESTAGIO:
        return 'Supervisor de Estágio';
      case Perfil.roleTerapeuta:
        return 'Terapeuta';
      case Perfil.roleResponsavel:
        return 'Responsável';
      case Perfil.roleProfessor:
        return 'Professor';
    }
  }

  /// String no formato do backend para enviar no JSON
  String get backendValue {
    switch (this) {
      case Perfil.ROLE_SUPERVISOR_ESTAGIO:
        return 'ROLE_SUPERVISOR_ESTAGIO';
      case Perfil.roleTerapeuta:
        return 'ROLE_TERAPEUTA';
      case Perfil.roleResponsavel:
        return 'ROLE_RESPONSAVEL';
      case Perfil.roleProfessor:
        return 'ROLE_PROFESSOR';
    }
  }
}
