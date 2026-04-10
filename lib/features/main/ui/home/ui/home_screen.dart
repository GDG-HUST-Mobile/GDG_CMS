import 'package:flutter/material.dart';
import 'package:gdgocms/features/main/ui/profile/ui/profile_screen.dart';
import 'package:gdgocms/features/main/ui/home/ui/homepage.dart';

/// home_screen.dart
/// Layer: Presentation
/// Feature: Main
/// Description: Widget gốc (Shell) quản lý luồng giao diện chính sau khi đăng nhập.
/// Điều hướng giữa các phân vùng nội dung (Home, Memories, Profile) sử dụng [PageView] và Custom Bottom Navigation Bar.

/// [HomeScreen] đóng vai trò là khung chứa (Container) cho các tính năng chính của ứng dụng.
///
/// Lớp này quản lý việc chuyển đổi giữa các trang thông qua chỉ số [_selectedIndex]
/// và đồng bộ hóa trạng thái giữa thanh điều hướng phía dưới với nội dung hiển thị phía trên.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State <HomeScreen> createState() =>  _HomeScreenState();
}

class  _HomeScreenState extends State <HomeScreen> {
  /// Chỉ số của trang đang được chọn.
  int _selectedIndex = 0;

  /// Biến cờ ngăn chặn xung đột sự kiện khi đang thực hiện hiệu ứng chuyển trang.
  bool _isAnimating = false;

  /// Bộ điều khiển cho [PageView] để thực hiện trượt nội dung.
  late PageController _pageController;

  /// Danh sách các trang nội dung chính thuộc Feature Main.
  final List<Widget> _pages = [
    const HomePage(),
    const Center(child: Text('Đây là trang Memories', style: TextStyle(fontSize: 24))),
    const ProfileScreen(),
  ];

  @override
  void initState(){
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }

  /// [_onItemTapped] xử lý sự kiện khi người dùng nhấn vào các mục trên Bottom Bar.
  ///
  /// Thực hiện cập nhật UI cục bộ và kích hoạt hiệu ứng trượt đến trang tương ứng.
  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
      _isAnimating = true;
    });

    // Thực hiện hoạt ảnh trượt trang
    await _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuad
    );

    _isAnimating = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      /// Sử dụng [PageView] để cho phép người dùng vuốt ngang giữa các tính năng.
      body: PageView(
        controller: _pageController,
        onPageChanged: (index){
          // Chỉ cập nhật index nếu việc đổi trang đến từ thao tác vuốt tay (không phải do animateToPage).
          if (!_isAnimating) {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        physics: const BouncingScrollPhysics(),
        children: _pages,
      ),

      /// Thanh điều hướng tùy chỉnh với thiết kế nổi (Floating style).
      bottomNavigationBar: Container(
        margin: const EdgeInsets.only(left: 20,right: 20,bottom: 30),
        height: 70,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(35),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 5)
              )
            ]
        ),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(0, 'assets/images/home.png', 'Home'),
              _buildNavItem(1, 'assets/images/photo.png', 'Memories'),
              _buildNavItem(2, 'assets/images/user.png', 'Profile'),
            ]
        ),
      ),
    );
  }

  /// [_buildNavItem] khởi tạo cấu trúc cho từng mục điều hướng.
  ///
  /// Tự động thay đổi màu sắc và độ dày chữ dựa trên trạng thái [index] đang được chọn.
  Widget _buildNavItem(int index, String assetPath, String label) {
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(assetPath, width: 24, height: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: _selectedIndex == index ? Colors.blue : Colors.grey,
              fontSize: 12,
              fontWeight: _selectedIndex == index
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}