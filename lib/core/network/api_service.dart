import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// api_service.dart
/// Layer: Core
/// Module: Network
/// Description: Quản lý các dịch vụ API, xác thực người dùng (Auth) và cấu hình Header chung cho toàn dự án.
/// Dependencies: http, shared_preferences.

/// [AuthService] chịu trách nhiệm quản lý vòng đời xác thực của người dùng.
///
/// Bao gồm các tác vụ: Đăng ký, Đăng nhập, Đăng xuất và Làm mới Access Token (Refresh Token).
/// Dữ liệu xác thực được lưu trữ cục bộ thông qua [SharedPreferences].
class AuthService {
  /// URL cơ sở cho các dịch vụ API của hệ thống GDG CMS.
  static const String baseUrl = 'https://gdg-cms.vercel.app';

  /// Các khóa (Keys) dùng để định danh dữ liệu trong [SharedPreferences].
  static const String _accessTokenKey = 'accessToken';
  static const String _refreshTokenKey = 'refreshToken';
  static const String _usernameKey = 'username';
  static const String _firstNameKey = 'firstName';
  static const String _lastNameKey = 'lastName';
  static const String _emailKey = 'email';
  static const String _roleKey = 'role';

  /// Thực hiện đăng ký tài khoản mới.
  ///
  /// Nhận vào các thông tin bắt buộc: [username], [password], [email], [firstName], [lastName].
  /// Nếu thành công (200/201), tự động lưu trữ thông tin xác thực và trả về [true].
  Future<bool> register({
    required String username,
    required String password,
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "username": username,
          "password": password,
          "firstName": firstName,
          "lastName": lastName,
          "email": email,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(
          jsonDecode(response.body),
        );
        final Map<String, dynamic> user = _extractUserMap(data);
        await _saveAuthData(
          data['accessToken']?.toString() ?? '',
          data['refreshToken']?.toString() ?? '',
          _readString(user, 'username') ?? username,
          _readString(user, 'firstName') ?? firstName,
          _readString(user, 'lastName') ?? lastName,
          _readString(user, 'email') ?? email,
          _readString(user, 'role') ?? 'Member',
        );
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Thực hiện xác thực đăng nhập người dùng.
  ///
  /// Gửi [username] và [password] lên server. Trả về [true] nếu thông tin chính xác
  /// và lưu trữ bộ đôi Access Token & Refresh Token.
  Future<bool> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = Map<String, dynamic>.from(
          jsonDecode(response.body),
        );
        final Map<String, dynamic> user = _extractUserMap(data);
        await _saveAuthData(
          data['accessToken']?.toString() ?? '',
          data['refreshToken']?.toString() ?? '',
          _readString(user, 'username') ?? username,
          _readString(user, 'firstName') ?? '',
          _readString(user, 'lastName') ?? '',
          _readString(user, 'email') ?? '',
          _readString(user, 'role') ?? 'Member',
        );
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Cấp lại Access Token mới khi token cũ hết hạn.
  ///
  /// Sử dụng [_refreshTokenKey] còn hiệu lực để yêu cầu server cấp [accessToken] mới.
  /// Trả về chuỗi token mới nếu thành công, ngược lại trả về [null].
  Future<String?> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final rToken = prefs.getString(_refreshTokenKey);

      if (rToken == null) return null;

      final response = await http.post(
        Uri.parse('$baseUrl/refresh'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"refreshToken": rToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccessToken = data['accessToken'];
        await prefs.setString(_accessTokenKey, newAccessToken);
        return newAccessToken;
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Đăng xuất người dùng khỏi hệ thống.
  ///
  /// Gửi yêu cầu hủy token lên server và thực hiện xóa toàn bộ dữ liệu xác thực tại local.
  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString(_usernameKey);
      final rToken = prefs.getString(_refreshTokenKey);

      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"username": username, "refreshToken": rToken}),
      );

      if (response.statusCode == 200) {
        await prefs.clear();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  /// Hàm hỗ trợ lưu trữ bộ thông tin xác thực vào bộ nhớ máy.
  Future<void> _saveAuthData(
    String access,
    String refresh,
    String username,
    String firstName,
    String lastName,
    String email,
    String role,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, access);
    await prefs.setString(_refreshTokenKey, refresh);
    await prefs.setString(_usernameKey, username);
    await prefs.setString(_firstNameKey, firstName);
    await prefs.setString(_lastNameKey, lastName);
    await prefs.setString(_emailKey, email);
    await prefs.setString(_roleKey, role);
  }

  /// Lấy Access Token hiện tại từ bộ nhớ máy.
  /// Thường dùng để gắn vào Header cho các request cần xác thực.
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Map<String, dynamic> _extractUserMap(Map<String, dynamic> payload) {
    final dynamic candidate =
        payload['user'] ?? payload['data'] ?? payload['profile'];
    if (candidate is Map) {
      return Map<String, dynamic>.from(candidate);
    }
    return payload;
  }

  String? _readString(Map<String, dynamic> map, String key) {
    final dynamic value = map[key];
    if (value == null) {
      return null;
    }
    final String normalized = value.toString().trim();
    return normalized.isEmpty ? null : normalized;
  }
}

/// [BaseApiService] là lớp cơ sở cho các yêu cầu API cần quyền truy cập.
///
/// Lớp này tự động đính kèm Bearer Token vào header của các request.
class BaseApiService {
  final AuthService _authService = AuthService();

  /// Khởi tạo Header mặc định bao gồm Content-Type và Authorization.
  Future<Map<String, String>> getHeaders() async {
    try {
      String? token = await _authService.getAccessToken();
      return {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
    } catch (_) {
      return {'Content-Type': 'application/json'};
    }
  }

  /// Thực hiện lấy danh sách bài viết từ hệ thống.
  ///
  /// Đây là hàm ví dụ về cách sử dụng [getHeaders] để gọi một Private API.
  Future<http.Response> getPosts() async {
    final headers = await getHeaders();
    return await http.get(
      Uri.parse('${AuthService.baseUrl}/posts'),
      headers: headers,
    );
  }
}

class UserService {
  final BaseApiService _apiService = BaseApiService();
  final AuthService _authService = AuthService();

  Future<Map<String, dynamic>?> fetchCurrentUser() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? username = prefs.getString('username');
      final String? firstName = prefs.getString('firstName');
      final String? lastName = prefs.getString('lastName');
      final String? email = prefs.getString('email');
      final String? role = prefs.getString('role');

      if (username == null &&
          firstName == null &&
          lastName == null &&
          email == null &&
          role == null) {
        return null;
      }

      return <String, dynamic>{
        'username': username ?? '',
        'firstName': firstName ?? '',
        'lastName': lastName ?? '',
        'email': email ?? '',
        'role': role ?? 'Member',
      };
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> updateCurrentUser({
    required String firstName,
    required String lastName,
    required String email,
  }) async {
    try {
      final Map<String, dynamic> payload = <String, dynamic>{
        'firstName': firstName.trim(),
        'lastName': lastName.trim(),
        'email': email.trim(),
      };

      final List<String> candidatePaths = <String>[
        '/users/me',
        '/users/profile',
      ];
      final String? storedUsername = await _getStoredUsername();

      for (final String path in candidatePaths) {
        final http.Response response = await _authorizedPut(path, payload);
        if (response.statusCode != 200 && response.statusCode != 201) {
          continue;
        }

        final dynamic decoded = jsonDecode(response.body);
        final Map<String, dynamic>? normalized = _normalizeUserPayload(
          decoded,
          storedUsername,
        );
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('firstName', payload['firstName'] as String);
        await prefs.setString('lastName', payload['lastName'] as String);
        await prefs.setString('email', payload['email'] as String);

        if (normalized != null) {
          return normalized;
        }
        return <String, dynamic>{
          'firstName': payload['firstName'],
          'lastName': payload['lastName'],
          'email': payload['email'],
        };
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<http.Response> _authorizedPut(
    String path,
    Map<String, dynamic> payload,
  ) async {
    try {
      http.Response response = await _rawPut(path, payload);
      if (response.statusCode == 401 || response.statusCode == 403) {
        final String? refreshed = await _authService.refreshToken();
        if (refreshed != null) {
          response = await _rawPut(path, payload);
        }
      }
      return response;
    } catch (_) {
      return http.Response('{"message":"Request failed"}', 500);
    }
  }

  Future<http.Response> _rawPut(
    String path,
    Map<String, dynamic> payload,
  ) async {
    final Map<String, String> headers = await _apiService.getHeaders();
    return http.put(
      Uri.parse('${AuthService.baseUrl}$path'),
      headers: headers,
      body: jsonEncode(payload),
    );
  }

  Map<String, dynamic>? _normalizeUserPayload(
    dynamic decoded,
    String? storedUsername,
  ) {
    if (decoded is List) {
      final Iterable<Map<String, dynamic>> users = decoded.whereType<Map>().map(
        (e) => Map<String, dynamic>.from(e),
      );
      if (users.isEmpty) {
        return null;
      }
      if (storedUsername == null || storedUsername.isEmpty) {
        return users.first;
      }
      return users.firstWhere(
        (u) =>
            (u['username']?.toString() ?? '').toLowerCase() ==
            storedUsername.toLowerCase(),
        orElse: () => users.first,
      );
    }

    if (decoded is Map<String, dynamic>) {
      final dynamic user =
          decoded['user'] ?? decoded['data'] ?? decoded['profile'];
      if (user is Map) {
        return Map<String, dynamic>.from(user);
      }
      return decoded;
    }

    return null;
  }

  Future<String?> _getStoredUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }
}
