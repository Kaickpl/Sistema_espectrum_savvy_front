enum Perfil {
  roleAdmin,
  roleTerapeuta,
  roleResponsavel,
  roleProfessor;

  /// Converte a string vinda do backend (ex: "ROLE_ADMIN") para o enum
  static Perfil fromString(String value) {
    switch (value) {
      case 'ROLE_ADMIN':
        return Perfil.roleAdmin;
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
      case Perfil.roleAdmin:
        return 'Administrador';
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
      case Perfil.roleAdmin:
        return 'ROLE_ADMIN';
      case Perfil.roleTerapeuta:
        return 'ROLE_TERAPEUTA';
      case Perfil.roleResponsavel:
        return 'ROLE_RESPONSAVEL';
      case Perfil.roleProfessor:
        return 'ROLE_PROFESSOR';
    }
  }
}