class AdminDashboardModel {
  final int totalPacientes;
  final int totalProtocolosFinalizados;

  AdminDashboardModel({
    required this.totalPacientes,
    required this.totalProtocolosFinalizados,
  });

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) {
    return AdminDashboardModel(
      totalPacientes: json['totalPacientes'] ?? 0,
      totalProtocolosFinalizados: json['totalProtocolosFinalizados'] ?? 0,
    );
  }
}
