import 'dart:convert';
import 'package:http/http.dart' as http;
class ApiClient {
  static const String _baseUrl = 'http://10.0.2.2:8080';

  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // ── GET ──────────────────────────────────────────────────────────
  static Future<http.Response> get(String path) {
    return http.get(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
    );
  }

  // ── POST ─────────────────────────────────────────────────────────
  static Future<http.Response> post(String path, Map<String, dynamic> body) {
    return http.post(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
  }

  // ── PUT ──────────────────────────────────────────────────────────
  static Future<http.Response> put(String path, Map<String, dynamic> body) {
    return http.put(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
      body: jsonEncode(body),
    );
  }

  // ── DELETE ───────────────────────────────────────────────────────
  static Future<http.Response> delete(String path) {
    return http.delete(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
    );
  }

  // ── PATCH ────────────────────────────────────────────────────────
  static Future<http.Response> patch(String path,
      [Map<String, dynamic>? body]) {
    return http.patch(
      Uri.parse('$_baseUrl$path'),
      headers: _headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }
}