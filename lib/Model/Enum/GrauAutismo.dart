enum GrauAutismo {
  nivel1,
  nivel2,
  nivel3;

  /// Converte a string vinda do backend (ex: "NIVEL_1") para o enum
  static GrauAutismo fromString(String value) {
    switch (value) {
      case 'NIVEL_1':
        return GrauAutismo.nivel1;
      case 'NIVEL_2':
        return GrauAutismo.nivel2;
      case 'NIVEL_3':
        return GrauAutismo.nivel3;
      default:
        throw ArgumentError('Grau de autismo desconhecido: $value');
    }
  }

  /// Nome amigável para exibir na tela
  String get displayName {
    switch (this) {
      case GrauAutismo.nivel1:
        return 'Nível 1 - Suporte Leve';
      case GrauAutismo.nivel2:
        return 'Nível 2 - Suporte Moderado';
      case GrauAutismo.nivel3:
        return 'Nível 3 - Suporte Substancial';
    }
  }

  /// String no formato do backend para enviar no JSON
  String get backendValue {
    switch (this) {
      case GrauAutismo.nivel1:
        return 'NIVEL_1';
      case GrauAutismo.nivel2:
        return 'NIVEL_2';
      case GrauAutismo.nivel3:
        return 'NIVEL_3';
    }
  }
}
