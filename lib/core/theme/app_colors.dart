import 'package:flutter/material.dart';

/// app_colors.dart
/// Layer: Core
/// Module: Theme
/// Description: Quản lý bảng màu hệ thống (Style Guide) cho ứng dụng GDG CMS.
/// Tập trung các màu sắc thương hiệu của HUST (Xanh, Đỏ, Vàng...) để đảm bảo tính nhất quán UI.

/// [AppColors] chứa toàn bộ định nghĩa màu sắc tĩnh của ứng dụng.
///
/// Lớp này không được khởi tạo (static-only) và cung cấp các hằng số màu
/// dùng cho Text, Background, Icons và các hiệu ứng giao diện khác.
class AppColors {
  /// [primary] - Màu xanh thương hiệu chủ đạo (HUST Green).
  /// Sử dụng cho các thành phần chính như: Appbar, Primary Buttons, Active States.
  static const Color primary = Color(0xFF00A050); // R:0, G:160, B:80

  /// Nhóm màu phụ (Secondary Colors)
  /// Thường dùng cho các minh họa (Illustrations), Icon trong màn hình Onboarding hoặc trạng thái thông báo.
  static const Color blue = Color(0xFF1F87FC);   // R:31, G:135, B:252
  static const Color red = Color(0xFFFE2B25);    // R:254, G:43, B:37
  static const Color yellow = Color(0xFFFFB900); // R:255, G:185, B:0

  /// Nhóm màu trung tính (Neutral Colors)
  /// [grey]: Sử dụng cho văn bản phụ (Secondary Text) hoặc nhãn (Labels).
  static const Color grey = Color(0xFF666C73);       // R:102, G:108, B:115

  /// [lightGrey]: Sử dụng cho đường kẻ phân cách (Dividers), Border hoặc nền yếu tố phụ.
  static const Color lightGrey = Color(0xFFD9D9D9);  // R:217, G:217, B:217

  /// [pageColors] cung cấp danh sách màu sắc tương ứng cho các trang trong PageView Onboarding.
  /// Giúp đồng bộ màu nền hoặc màu icon theo từng bước giới thiệu.
  static const List<Color> pageColors = [
    primary,
    blue,
    yellow,
    red,
  ];

  /// [white] - Màu trắng chuẩn hệ thống.
  /// Dùng làm nền cho Scaffold hoặc nền của các Card UI.
  static const Color white = Colors.white;
}