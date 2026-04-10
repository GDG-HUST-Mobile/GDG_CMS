import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gdgocms/core/theme/app_colors.dart';

/// app_fonts.dart
/// Layer: Core
/// Module: Theme
/// Description: Quản lý Typography và các kiểu chữ (TextStyles) toàn cục của ứng dụng.
/// Sử dụng font Inter làm font chữ chủ đạo thông qua [GoogleFonts].

/// [AppTextStyles] định nghĩa hệ thống phân cấp văn bản (Typography Hierarchy).
///
/// Giúp đảm bảo tính nhất quán về kích thước, trọng lượng (weight) và màu sắc
/// của văn bản trên tất cả các màn hình trong dự án GDG CMS.
class AppTextStyles {

  // --- HEADINGS (Độ dày 500) ---
  // Sử dụng cho các tiêu đề lớn, banner hoặc các điểm nhấn quan trọng nhất.

  /// [h1] - Tiêu đề lớn nhất (50px).
  static TextStyle h1 = GoogleFonts.inter(
    fontSize: 50,
    fontWeight: FontWeight.w500,
    color: AppColors.grey,
  );

  /// [h2] - Tiêu đề cấp 2 (35px).
  static TextStyle h2 = GoogleFonts.inter(
    fontSize: 35,
    fontWeight: FontWeight.w500,
    color: AppColors.grey,
  );

  /// [h3] - Tiêu đề cấp 3 (24px). Thường dùng cho tiêu đề màn hình chính.
  static TextStyle h3 = GoogleFonts.inter(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: AppColors.grey,
  );

  /// [h3Variant] - Biến thể của h3 (20px), dùng cho các tiêu đề card hoặc mục nhỏ hơn.
  static TextStyle h3Variant = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.grey,
  );

  // --- TITLES (Độ dày 500) ---
  // Sử dụng cho các tiêu đề danh mục, tiêu đề trên AppBar hoặc các đề mục nội dung.

  /// [title1] - Tiêu đề chính (20px).
  static TextStyle title1 = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.grey,
  );

  /// [title2] - Tiêu đề trung bình (14px).
  static TextStyle title2 = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.grey,
  );

  /// [title3] - Tiêu đề nhỏ (12px), thường dùng cho nhãn (labels).
  static TextStyle title3 = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.grey,
  );

  // --- SUBTITLES (Độ dày 400) ---
  // Sử dụng cho các dòng mô tả, văn bản chú thích hoặc thông tin bổ trợ.

  /// [subtitle1] - Chú thích lớn (16px).
  static TextStyle subtitle1 = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
  );

  /// [subtitle2] - Chú thích trung bình (12px).
  static TextStyle subtitle2 = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
  );

  /// [subtitle3] - Chú thích cực nhỏ (10px), dùng cho timestamp hoặc thông tin phụ.
  static TextStyle subtitle3 = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.grey,
  );

  // --- BODY (Độ dày 500) ---
  // Sử dụng cho nội dung văn bản chính, bài viết hoặc các đoạn văn cần sự nổi bật nhẹ.

  /// [body1] - Văn bản nội dung (16px).
  static TextStyle body1 = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.grey,
  );
}