import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gdgocms/core/router/app_router.dart';
import 'package:table_calendar/table_calendar.dart';

/// homepage.dart
/// Layer: Presentation
/// Feature: Main | Home
/// Description: Trang chủ chính thức của ứng dụng, hiển thị lịch sự kiện và menu chức năng.
/// File này quản lý việc tương tác với lịch ([TableCalendar]) và điều hướng nhanh đến các module con.

/// [HomePage] là nội dung chính được hiển thị bên trong Shell của [HomeScreen].
///
/// Lớp này quản lý trạng thái chọn ngày trên lịch và hiển thị hệ thống nút Menu
/// dẫn đến các tính năng: Events, Teammates, Leaderboards và Tools.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Ngày đang được tập trung (thường là tháng hiện tại đang hiển thị).
  DateTime _focusDay = DateTime.now();

  /// Ngày người dùng đang chọn trên lịch.
  DateTime? _selectDay;

  @override
  void initState() {
    super.initState();
    // Khởi tạo ngày chọn mặc định là ngày hiện tại.
    _selectDay = _focusDay;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,

        /// Logo đóng vai trò là nút reset hoặc chuyển đổi nhanh về [HomeScreen].
        title: GestureDetector(
          onTap: () {
            context.go(AppRoutes.home);
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Image.asset('assets/images/gdgsc_new.png', height: 30),
          ),
        ),
        actions: [
          /// Khu vực thông báo với Badge số lượng tin nhắn chưa đọc.
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.black,
                  size: 28,
                ),
                onPressed: () {
                  // TODO: Xử lý mở màn hình thông báo.
                },
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    '1',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          top: 10,
          bottom: 100,
        ),
        child: Column(
          children: [
            /// [Calendar Section]
            /// Hiển thị lịch để người dùng theo dõi và chọn ngày xem sự kiện.
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(1, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.only(bottom: 10),
              child: TableCalendar<Color>(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusDay,
                startingDayOfWeek: StartingDayOfWeek.monday,
                selectedDayPredicate: (day) => isSameDay(_selectDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  // Cập nhật ngày được chọn và làm mới UI.
                  setState(() {
                    _selectDay = selectedDay;
                    _focusDay = focusedDay;
                  });
                },
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  leftChevronIcon: Icon(Icons.arrow_back_ios, size: 16),
                  rightChevronIcon: Icon(Icons.arrow_forward_ios, size: 16),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekendStyle: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                  weekdayStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
                calendarStyle: CalendarStyle(
                  defaultTextStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  outsideTextStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.normal,
                  ),
                  weekendTextStyle: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                  todayDecoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            /// [Menu Grid Section]
            /// Hệ thống phím tắt nhanh dẫn đến các tính năng quan trọng.
            Row(
              children: [
                Expanded(
                  child: _buildMenuButton(
                    'assets/images/calender.png',
                    'Events',
                    'Check out the tech sharing,\n meetings schedule',
                    () => context.push(AppRoutes.events),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildMenuButton(
                    'assets/images/teamwork.png',
                    'Teammates',
                    'Find Teammates to join \nthe competition',
                    () => (),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: _buildMenuButton(
                    'assets/images/podium.png',
                    'Leaderboards',
                    'Active club member\nranking',
                    () => (),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildMenuButton(
                    'assets/images/setting.png',
                    'Tools',
                    'Some other products\nof GDG',
                    () => (),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// [_buildMenuButton] khởi tạo cấu trúc nút Menu chuyên dụng.
  ///
  /// Giải thích "Why": Sử dụng [Column] để tách biệt rõ ràng giữa Icon (trong Bordered Box)
  /// và phần văn bản mô tả giúp người dùng dễ dàng nhận diện tính năng.
  Widget _buildMenuButton(
    String imagePath,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Phần biểu tượng với Shadow và Border bo tròn.
          Container(
            width: 75,
            height: 75,
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.black87, width: 1.2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),

          const SizedBox(height: 12),

          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 5),

          // Mô tả chi tiết chức năng của nút.
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
