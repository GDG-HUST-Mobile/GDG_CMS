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
      final data = jsonDecode(response.body);
      // Lưu trữ dữ liệu ngay sau khi đăng ký thành công để người dùng có thể sử dụng app ngay.
      await _saveAuthData(data['accessToken'], data['refreshToken'], username);
      return true;
    }
    return false;
  }

  /// Thực hiện xác thực đăng nhập người dùng.
  ///
  /// Gửi [username] và [password] lên server. Trả về [true] nếu thông tin chính xác
  /// và lưu trữ bộ đôi Access Token & Refresh Token.
  Future<bool> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await _saveAuthData(data['accessToken'], data['refreshToken'], username);
      return true;
    }
    return false;
  }

  /// Cấp lại Access Token mới khi token cũ hết hạn.
  ///
  /// Sử dụng [_refreshTokenKey] còn hiệu lực để yêu cầu server cấp [accessToken] mới.
  /// Trả về chuỗi token mới nếu thành công, ngược lại trả về [null].
  Future<String?> refreshToken() async {
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
  }

  /// Đăng xuất người dùng khỏi hệ thống.
  ///
  /// Gửi yêu cầu hủy token lên server và thực hiện xóa toàn bộ dữ liệu xác thực tại local.
  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString(_usernameKey);
    final rToken = prefs.getString(_refreshTokenKey);

    final response = await http.post(
      Uri.parse('$baseUrl/logout'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": username,
        "refreshToken": rToken,
      }),
    );

    if (response.statusCode == 200) {
      // Clear toàn bộ để đảm bảo an toàn thông tin khi người dùng thoát.
      await prefs.clear();
      return true;
    }
    return false;
  }

  /// Hàm hỗ trợ lưu trữ bộ thông tin xác thực vào bộ nhớ máy.
  Future<void> _saveAuthData(String access, String refresh, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, access);
    await prefs.setString(_refreshTokenKey, refresh);
    await prefs.setString(_usernameKey, username);
  }

  /// Lấy Access Token hiện tại từ bộ nhớ máy.
  /// Thường dùng để gắn vào Header cho các request cần xác thực.
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }
}

/// [BaseApiService] là lớp cơ sở cho các yêu cầu API cần quyền truy cập.
///
/// Lớp này tự động đính kèm Bearer Token vào header của các request.
class BaseApiService {
  final AuthService _authService = AuthService();

  /// Khởi tạo Header mặc định bao gồm Content-Type và Authorization.
  Future<Map<String, String>> getHeaders() async {
    String? token = await _authService.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
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