import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gdgocms/core/router/app_router.dart';
import 'package:gdgocms/core/theme/app_colors.dart';
import 'package:gdgocms/core/theme/app_fonts.dart';
import 'package:gdgocms/core/network/api_service.dart';

/// login_screen.dart
/// Layer: Presentation
/// Feature: Login
/// Description: Quản lý giao diện và logic tương tác cho màn hình đăng nhập.
/// File này xử lý các thành phần UI responsive và điều phối luồng xác thực người dùng.

/// [SignInScreen] là màn hình chính cho phép người dùng đăng nhập vào hệ thống GDG CMS.
///
/// Sử dụng [StatefulWidget] để quản lý trạng thái của các ô nhập liệu,
/// hiệu ứng ẩn/hiện mật khẩu và trạng thái loading khi gọi API.
class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  /// Điều khiển dữ liệu nhập vào cho trường Username và Password.
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  /// Trạng thái hiển thị mật khẩu (true: ẩn, false: hiện).
  bool _isPasswordVisible = false;

  /// Lưu trữ thông báo lỗi trả về từ server hoặc validate.
  String? _errorMessage;

  /// Trạng thái chờ khi đang thực hiện request API.
  bool _isLoading = false;

  /// [_handleSignIn] thực hiện xử lý logic đăng nhập.
  ///
  /// Quy trình:
  /// 1. Bật trạng thái [_isLoading].
  /// 2. Gọi phương thức login từ [AuthService].
  /// 3. Điều hướng sang [HomeScreen] nếu thành công hoặc hiển thị lỗi nếu thất bại.
  void _handleSignIn() async {
    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    final success = await AuthService().login(
      _usernameController.text,
      _passwordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      // Đăng nhập thành công, thay thế màn hình hiện tại bằng trang chủ.
      context.go(AppRoutes.home);
    } else {
      // Cập nhật thông báo lỗi để hiển thị lên UI.
      setState(() {
        _errorMessage = "Oops! Incorrect password. Try again!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 1. Tính toán kích thước màn hình thực tế (trừ đi padding hệ thống như status bar/notch)
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fullHeight = MediaQuery.of(context).size.height;
    final double safeHeight =
        fullHeight -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.white,
      // Tránh việc đẩy layout lên trên khi bàn phím xuất hiện để bảo toàn vị trí hình nền Parabol.
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background: Hình ảnh Parabol đặc trưng của HUST.
          Align(
            alignment: Alignment.bottomCenter,
            child: SvgPicture.asset(
              'assets/images/hust_parabol_bg.svg',
              fit: BoxFit.contain,
              width: screenWidth,
            ),
          ),

          // Lớp nội dung chính
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Căn chỉnh khoảng cách theo tỷ lệ màn hình (Responsive Spacing)
                        SizedBox(height: safeHeight * 0.05),

                        // Nhãn hiệu/Logo chương trình
                        SvgPicture.asset(
                          'assets/images/gdsc_hust_horizontal_colored-cropped.svg',
                          width: screenWidth * 0.9,
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        ),

                        SizedBox(height: safeHeight * 0.06),

                        Text(
                          "Sign in",
                          style: AppTextStyles.h2.copyWith(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontSize: safeHeight * 0.045,
                          ),
                        ),

                        SizedBox(height: safeHeight * 0.04),

                        _buildInputLabel("ID/Username", safeHeight),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            hintText: "Your ID/Username",
                          ),
                        ),

                        SizedBox(height: safeHeight * 0.03),

                        _buildInputLabel("Password", safeHeight),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          decoration: InputDecoration(
                            hintText: "Enter your password",
                            // Nút IconButton để bật/tắt hiển thị mật khẩu
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColors.grey,
                                size: safeHeight * 0.025,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ),
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot Password?",
                              style: AppTextStyles.subtitle2.copyWith(
                                color: AppColors.blue,
                                fontSize: safeHeight * 0.018,
                              ),
                            ),
                          ),
                        ),

                        // Hiển thị thông báo lỗi khi có lỗi từ server
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              _errorMessage!,
                              style: AppTextStyles.subtitle2.copyWith(
                                color: AppColors.red,
                                fontSize: safeHeight * 0.016,
                              ),
                            ),
                          ),

                        const SizedBox(height: 8),

                        // Nút xác nhận đăng nhập
                        SizedBox(
                          width: double.infinity,
                          height: safeHeight * 0.075,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleSignIn,
                            child: _isLoading
                                ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text(
                                    "Sign In",
                                    style: TextStyle(
                                      fontSize: safeHeight * 0.022,
                                    ),
                                  ),
                          ),
                        ),

                        SizedBox(height: safeHeight * 0.04),

                        // Khu vực đăng nhập bằng phương thức khác
                        Center(
                          child: Column(
                            children: [
                              Text(
                                "--------- Or continue with ---------",
                                style: AppTextStyles.subtitle3.copyWith(
                                  fontSize: safeHeight * 0.014,
                                ),
                              ),
                              SizedBox(height: safeHeight * 0.02),

                              Container(
                                padding: EdgeInsets.all(safeHeight * 0.015),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: SvgPicture.asset(
                                  'assets/images/google_icon.svg',
                                  width: safeHeight * 0.035,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: safeHeight * 0.04),

                        // Chuyển hướng đến màn hình đăng ký tài khoản
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            children: [
                              Text(
                                "Not a member? ",
                                style: TextStyle(fontSize: safeHeight * 0.018),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.push(AppRoutes.register);
                                },
                                child: Text(
                                  "Create an account",
                                  style: AppTextStyles.body1.copyWith(
                                    color: AppColors.blue,
                                    decoration: TextDecoration.underline,
                                    fontSize: safeHeight * 0.018,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Tạo khoảng trống an toàn để không bị hình nền đè lên nội dung cuối.
                        SizedBox(height: safeHeight * 0.15),
                      ],
                    ),
                  ),
                ),
                // Padding cho Home Indicator trên các thiết bị không có nút cứng.
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// [_buildInputLabel] hỗ trợ tạo các nhãn cho ô nhập liệu.
  ///
  /// Tự động điều chỉnh [fontSize] theo [safeHeight] của màn hình hiện tại.
  Widget _buildInputLabel(String label, double safeHeight) {
    return Text(
      label,
      style: AppTextStyles.title2.copyWith(
        color: Colors.black87,
        fontSize: safeHeight * 0.018,
      ),
    );
  }
}
