/// Normaliza número de telefone para apenas dígitos, garantindo que o
/// mesmo número sempre seja salvo/comparado da mesma forma, independente
/// de como a pessoa digitou (com espaço, parênteses, traço, etc.).
class FormatadorTelefone {
  static String apenasDigitos(String texto) {
    return texto.replaceAll(RegExp(r'[^0-9]'), '');
  }
}
