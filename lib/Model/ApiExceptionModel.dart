class ApiException implements Exception {
  final String message;
  final int status;
  final String? request;

  ApiException({
    required this.message,
    required this.status,
    this.request,
  });

  factory ApiException.fromJson(Map<String, dynamic> json) {
    return ApiException(
      message: json['message'] ?? 'Erro desconhecido',
      status: json['status'] ?? 0,
      request: json['request'],
    );
  }

  @override
  String toString() => message;
}
