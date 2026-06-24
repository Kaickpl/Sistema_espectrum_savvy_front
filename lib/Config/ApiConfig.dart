import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String _baseUrl = 'http://localhost:8080';

  static Map<String, String> _headers([String? token]) => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (token != null) 'Authorization': 'Bearer $token',
  };

  // ── GET ──────────────────────────────────────────────────────────
  static Future<http.Response> get(String path, {String? token}) {
    return http.get(Uri.parse('$_baseUrl$path'), headers: _headers(token));
  }

  // ── POST ─────────────────────────────────────────────────────────
  static Future<http.Response> post(
    String path,
    Map<String, dynamic> body, {
    String? token,
  }) {
    return http.post(
      Uri.parse('$_baseUrl$path'),
      headers: _headers(token),
      body: jsonEncode(body),
    );
  }

  // ── PUT ──────────────────────────────────────────────────────────
  static Future<http.Response> put(
    String path,
    Map<String, dynamic> body, {
    String? token,
  }) {
    return http.put(
      Uri.parse('$_baseUrl$path'),
      headers: _headers(token),
      body: jsonEncode(body),
    );
  }

  // ── DELETE ───────────────────────────────────────────────────────
  static Future<http.Response> delete(String path, {String? token}) {
    return http.delete(Uri.parse('$_baseUrl$path'), headers: _headers(token));
  }

  // ── PATCH ────────────────────────────────────────────────────────
  static Future<http.Response> patch(
    String path, [
    Map<String, dynamic>? body,
    String? token,
  ]) {
    return http.patch(
      Uri.parse('$_baseUrl$path'),
      headers: _headers(token),
      body: body != null ? jsonEncode(body) : null,
    );
  }
}
