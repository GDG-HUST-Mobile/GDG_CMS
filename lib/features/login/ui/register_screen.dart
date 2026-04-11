import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gdgocms/core/theme/app_colors.dart';
import 'package:gdgocms/core/theme/app_fonts.dart';
import 'package:gdgocms/core/network/api_service.dart';
import 'package:gdgocms/features/main/ui/home/ui/home_screen.dart';

/// register_screen.dart
/// Layer: Presentation
/// Feature: Login/Register
/// Description: Quản lý giao diện và logic đăng ký tài khoản mới cho thành viên GDG CMS.
/// Xử lý việc nhập liệu thông tin cá nhân, kiểm tra tính hợp lệ của mật khẩu xác nhận
/// và điều phối luồng đăng ký qua [AuthService].

/// [RegisterScreen] cung cấp form đăng ký đa trường thông tin.
///
/// Lớp này quản lý trạng thái cho các controller nhập liệu, logic validation local
/// (kiểm tra trống, khớp mật khẩu) và hiển thị trạng thái chờ trong quá trình tạo tài khoản.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Bộ điều khiển cho các trường thông tin cá nhân
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();

  // Bộ điều khiển cho mật khẩu và xác nhận mật khẩu
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Trạng thái hiển thị mật khẩu riêng biệt cho từng ô nhập
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Trạng thái hệ thống
  bool _isLoading = false;
  String? _errorMessage;

  /// [_handleRegister] điều phối quy trình tạo tài khoản.
  ///
  /// Thực hiện validation tại chỗ:
  /// 1. Kiểm tra các trường bắt buộc không được để trống.
  /// 2. Đảm bảo mật khẩu xác nhận trùng khớp với mật khẩu đã nhập.
  /// Sau đó gọi API [AuthService.register] và điều hướng về [HomeScreen] nếu thành công.
  void _handleRegister() async {
    // 1. Validate: Kiểm tra các trường bắt buộc
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty || _confirmPasswordController.text.isEmpty) {
      setState(() => _errorMessage = "Vui lòng nhập đầy đủ các trường bắt buộc.");
      return;
    }

    // 2. Validate: Kiểm tra tính toàn vẹn của mật khẩu xác nhận
    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() => _errorMessage = "Mật khẩu xác nhận không khớp.");
      return;
    }

    setState(() {
      _errorMessage = null;
      _isLoading = true;
    });

    // Gọi API đăng ký qua Core Layer
    final success = await AuthService().register(
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
      email: _emailController.text.trim(),
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      // Đăng ký thành công, xóa lịch sử và vào thẳng trang chủ
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
            (route) => false,
      );
    } else {
      // Thông báo lỗi nghiệp vụ từ phía Server (trùng user/email)
      setState(() {
        _errorMessage = "Đăng ký thất bại. Tài khoản hoặc Email đã tồn tại.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tính toán kích thước responsive dựa trên không gian an toàn (Safe Area)
    final double screenWidth = MediaQuery.of(context).size.width;
    final double safeHeight = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.white,
      // Không đẩy layout khi hiện phím để giữ hình nền parabol ổn định
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Lớp nền Parabol đặc trưng phía dưới
          Align(
            alignment: Alignment.bottomCenter,
            child: SvgPicture.asset(
              'assets/images/hust_parabol_bg.svg',
              fit: BoxFit.contain,
              width: screenWidth,
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: safeHeight * 0.02),

                        // Nút quay lại màn hình đăng nhập
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                        ),

                        Text(
                          "Create Account",
                          style: AppTextStyles.h2.copyWith(
                            fontWeight: FontWeight.w300,
                            fontSize: safeHeight * 0.04,
                          ),
                        ),

                        SizedBox(height: safeHeight * 0.02),

                        // Form nhập Họ và Tên trên cùng một hàng
                        Row(
                          children: [
                            Expanded(child: _buildFieldColumn("First Name", "HUST", _firstNameController, safeHeight)),
                            const SizedBox(width: 16),
                            Expanded(child: _buildFieldColumn("Last Name", "GDGoC", _lastNameController, safeHeight)),
                          ],
                        ),

                        const SizedBox(height: 16),
                        _buildFieldColumn("Email", "example@email.com", _emailController, safeHeight),

                        const SizedBox(height: 16),
                        _buildFieldColumn("Username", "gdgoc_cms", _usernameController, safeHeight),

                        const SizedBox(height: 16),
                        // Trường nhập mật khẩu chính
                        _buildPasswordField("Password", _passwordController, _isPasswordVisible, (val) {
                          setState(() => _isPasswordVisible = !_isPasswordVisible);
                        }, safeHeight),

                        const SizedBox(height: 16),
                        // Trường xác nhận lại mật khẩu để tránh gõ nhầm
                        _buildPasswordField("Confirm Password", _confirmPasswordController, _isConfirmPasswordVisible, (val) {
                          setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible);
                        }, safeHeight),

                        const SizedBox(height: 24),

                        // Hiển thị thông báo lỗi Validation hoặc API Error
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(_errorMessage!, style: TextStyle(color: AppColors.red, fontSize: safeHeight * 0.016)),
                          ),

                        // Nút SignUp thực thi lệnh đăng ký
                        SizedBox(
                          width: double.infinity,
                          height: safeHeight * 0.07,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleRegister,
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : Text("Sign Up", style: TextStyle(fontSize: safeHeight * 0.02)),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Footer điều hướng ngược lại cho người dùng đã có tài khoản
                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: RichText(
                              text: TextSpan(
                                text: "Already a member? ",
                                style: TextStyle(color: Colors.black, fontSize: safeHeight * 0.018),
                                children: [
                                  TextSpan(
                                    text: "Sign In",
                                    style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // Khoảng trống an toàn phía dưới
                        SizedBox(height: safeHeight * 0.1),
                      ],
                    ),
                  ),
                ),
                // Xử lý vùng đệm cho Home Indicator
                SizedBox(height: MediaQuery.of(context).padding.bottom),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// [_buildPasswordField] khởi tạo ô nhập mật khẩu có chức năng ẩn/hiện.
  ///
  /// Giải thích "Why": Tách biệt logic ẩn hiện password để có thể áp dụng
  /// độc lập cho cả ô mật khẩu và ô xác nhận mật khẩu mà không bị trùng lặp code.
  Widget _buildPasswordField(String label, TextEditingController controller, bool isVisible, Function(bool) toggle, double safeHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputLabel(label, safeHeight),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: !isVisible,
          decoration: InputDecoration(
            hintText: "Enter $label",
            suffixIcon: IconButton(
              icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off, color: AppColors.grey, size: safeHeight * 0.025),
              onPressed: () => toggle(isVisible),
            ),
          ),
        ),
      ],
    );
  }

  /// Helper: Tạo cột nhập liệu tiêu chuẩn gồm Label và TextField.
  Widget _buildFieldColumn(String label, String hint, TextEditingController controller, double safeHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputLabel(label, safeHeight),
        const SizedBox(height: 8),
        TextField(controller: controller, decoration: InputDecoration(hintText: hint)),
      ],
    );
  }

  /// Helper: Tạo Widget văn bản nhãn cho các ô nhập liệu, kích thước tỷ lệ theo [safeHeight].
  Widget _buildInputLabel(String label, double safeHeight) {
    return Text(
      label,
      style: AppTextStyles.title2.copyWith(color: Colors.black87, fontSize: safeHeight * 0.018),
    );
  }
}