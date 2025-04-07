//define api service like post, get, put, delete,... with exception handling and authorization jwt token in header
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import "../utils/constants.dart";
// import '../error/custom_exception.dart';
//
// class ApiService {
//   final http.Client _client;
//   final String? authToken;
//
//   ApiService({http.Client? client, this.authToken}) : _client = client ?? http.Client();
//
//   Future<dynamic> get(String endpoint) async {
//     final uri = Uri.parse('${AppConstants.baseUrl}/$endpoint');
//     try {
//       final response = await _client.get(uri, headers: _buildHeaders());
//       return _handleResponse(response);
//     } catch (e) {
//       throw NetworkException('GET request failed: $e');
//     }
//   }
//
//   Future<dynamic> post(String endpoint, dynamic body) async {
//     final uri = Uri.parse('${AppConstants.baseUrl}/$endpoint');
//     try {
//       final response = await _client.post(
//         uri,
//         headers: _buildHeaders(),
//         body: jsonEncode(body),
//       );
//       return _handleResponse(response);
//     } catch (e) {
//       throw NetworkException('POST request failed: $e');
//     }
//   }
//
//   Map<String, String> _buildHeaders() {
//     return {
//       'Content-Type': 'application/json',
//       if (authToken != null) 'Authorization': 'Bearer $authToken',
//     };
//   }
//
//   dynamic _handleResponse(http.Response response) {
//     switch (response.statusCode) {
//       case 200:
//       case 201:
//         return jsonDecode(response.body);
//       case 401:
//         throw UnauthorizedException();
//       case 400:
//       case 403:
//       case 404:
//       case 500:
//         throw ServerException('Status code: ${response.statusCode}, body: ${response.body}');
//       default:
//         throw UnknownException('Unexpected error: ${response.statusCode}');
//     }
//   }
// }
