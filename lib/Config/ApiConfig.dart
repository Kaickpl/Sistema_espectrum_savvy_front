import 'package:flutter/foundation.dart' show kIsWeb;

/// Configuração central do endereço do backend.
///
/// - Rodando no Chrome/Web: usa `localhost` automaticamente, já que o
///   navegador roda na mesma máquina do backend.
/// - Rodando em um celular físico (Android/iOS): o celular NÃO enxerga
///   "localhost" como sendo o seu computador. Você precisa colocar abaixo
///   o IP da sua máquina na mesma rede Wi-Fi do celular.
///
/// Como descobrir seu IP local:
///   Windows  -> abra o cmd e rode `ipconfig`           (campo "IPv4 Address")
///   Mac/Linux-> abra o terminal e rode `ifconfig` ou `ip a` (interface Wi-Fi)
///
/// Requisitos para o teste no celular físico funcionar:
///   1. Celular e computador na MESMA rede Wi-Fi.
///   2. Backend rodando (`./mvnw spring-boot:run`), escutando na porta 8080.
///   3. Firewall do computador liberando a porta 8080 (ou desativado durante o teste).
class ApiConfig {
  ApiConfig._();

  /// IP local da máquina rodando o backend. Só é usado quando o app
  /// roda fora da Web (ex: celular físico, emulador). TROQUE AQUI.
  static const String _ipLocalDoBackend = '192.168.0.100';

  static const int _porta = 8080;

  /// URL base usada em todas as chamadas HTTP ao backend.
  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:$_porta';
    }
    return 'http://$_ipLocalDoBackend:$_porta';
  }
}