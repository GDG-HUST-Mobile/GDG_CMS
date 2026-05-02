import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:go_router/go_router.dart';
import 'package:gdgocms/core/router/app_router.dart';

class UpcomingEventsScreen extends StatefulWidget {
  const UpcomingEventsScreen({super.key});

  @override
  State<UpcomingEventsScreen> createState() => _UpcomingEventsScreenState();
}

class _UpcomingEventsScreenState extends State<UpcomingEventsScreen> {
  final List<Map<String, dynamic>> _events = [
    {
      'id': '1',
      'title': 'Bonding Noel',
      'time': 'Tuesday, 26 - 6:00pm',
      'type': 'Offline',
      'location': '2nd floor Alumni',
      'description':
          'Đây là chương trình giao lưu nội bộ chào mừng giáng sinh. Sẽ có phát quà và trò chơi nhỏ. Yêu cầu dresscode màu đỏ hoặc xanh lá mạ!\nVui lòng có mặt đúng giờ để tham gia đầy đủ các minigame và ăn tiệc tối!',
    },
    {
      'id': '2',
      'title': 'Tech Talk 2024',
      'time': 'Friday, 29 - 8:00pm',
      'type': 'Online',
      'location': 'Google Meet',
      'description':
          'Chia sẻ về lộ trình trở thành kỹ sư phần mềm chuyên nghiệp. Gặp gỡ các anh chị Alumni có nhiều năm kinh nghiệm thực chiến.\nAgenda:\n- 8:00: Chào mừng\n- 8:15: Keynote Speaker\n- 9:00: Q&A',
    },
    {
      'id': '3',
      'title': 'Year End Party',
      'time': 'Sunday, 31 - 7:00pm',
      'type': 'Offline',
      'location': 'Central Park',
      'description':
          'Lễ tổng kết hoạt động quý cuối năm. Toàn bộ các mảng sẽ có tiết mục văn nghệ riêng, có buffet nướng ngoài trời thả ga.\nSẽ có màn trao giải vinh danh các thành viên xuất sắc nhất trong năm!',
    },
    {
      'id': '4',
      'title': 'Giao hữu cầu lông',
      'time': 'Monday, 1 - 5:00pm',
      'type': 'Offline',
      'location': 'Sân ĐH Bách Khoa',
      'description':
          'Rèn luyện sức khoẻ giữa tuần. Chuẩn bị tự mang theo vợt nếu có. CLB sẽ tài trợ nước uống và cầu tiêu chuẩn.\nNếu trời mưa thì sự kiện sẽ bị dời sang tuần sau nhé!',
    },
  ];

  void _onSwipe(int index) {
    setState(() {
      _events.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Upcoming Events',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: _events.isEmpty
          ? _buildEmptyState()
          : Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 520,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: _buildCardStack(),
                ),
              ),
            ),
    );
  }

  List<Widget> _buildCardStack() {
    final List<double> fanAngles = [0, -0.10, 0.10, -0.04];
    final List<double> fanOffsetX = [0, -8.0, 12.0, -16.0];
    final List<double> fanOffsetY = [0, 6.0, 3.0, 10.0];

    final List<Widget> cards = [];

    for (int i = _events.length - 1; i >= 0; i--) {
      final eventData = _events[i];

      final angle = i < fanAngles.length ? fanAngles[i] : fanAngles.last;
      final offX = i < fanOffsetX.length ? fanOffsetX[i] : fanOffsetX.last;
      final offY = i < fanOffsetY.length ? fanOffsetY[i] : fanOffsetY.last;
      final scale = 1.0 - (i * 0.03);

      Widget card = Hero(
        tag: 'event_card_${eventData['id']}',
        flightShuttleBuilder:
            (
              flightContext,
              animation,
              flightDirection,
              fromHeroContext,
              toHeroContext,
            ) {
              return SingleChildScrollView(child: toHeroContext.widget);
            },
        child: Material(
          color: Colors.transparent,
          child: EventCard(data: eventData),
        ),
      );

      if (i == 0) {
        card = TinderSwipeCard(
          key: ValueKey(eventData['id']),
          onSwipe: () => _onSwipe(0),
          onTap: () {
            context.push(AppRoutes.eventDetail, extra: eventData);
          },
          child: card,
        );
      } else {
        card = Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(offX, offY)
            ..rotateZ(angle)
            ..scale(scale),
          child: card,
        );
      }

      cards.add(card);
    }

    return cards;
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, color: Colors.grey, size: 80),
          SizedBox(height: 16),
          Text(
            'Đã xem hết sự kiện!',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class TinderSwipeCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onSwipe;
  final VoidCallback onTap;

  const TinderSwipeCard({
    super.key,
    required this.child,
    required this.onSwipe,
    required this.onTap,
  });

  @override
  State<TinderSwipeCard> createState() => _TinderSwipeCardState();
}

class _TinderSwipeCardState extends State<TinderSwipeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Alignment _dragAlignment = Alignment.center;
  Animation<Alignment>? _animation;
  double _angle = 0;
  bool _swiped = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation!.value;
        _angle = _dragAlignment.x * 0.3;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _runSpringBack() {
    _animation = _controller.drive(
      AlignmentTween(begin: _dragAlignment, end: Alignment.center),
    );
    const spring = SpringDescription(mass: 30, stiffness: 1500, damping: 80);
    final simulation = SpringSimulation(spring, 0, 1, -5);
    _controller.animateWith(simulation);
  }

  void _runFlyAway(double directionX) {
    final endX = directionX > 0 ? 5.0 : -5.0;
    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment(endX, _dragAlignment.y),
      ),
    );
    _controller
        .animateTo(
          1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        )
        .then((_) {
          if (!_swiped) {
            _swiped = true;
            widget.onSwipe();
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onPanDown: (_) => _controller.stop(),
      onPanUpdate: (details) {
        setState(() {
          _dragAlignment += Alignment(
            details.delta.dx / (size.width / 2),
            details.delta.dy / (size.height / 2),
          );
          _angle = _dragAlignment.x * 0.3;
        });
      },
      onPanEnd: (details) {
        final dx = _dragAlignment.x;
        final speedX = details.velocity.pixelsPerSecond.dx;

        if (dx.abs() > 1.2 || speedX.abs() > 700) {
          _runFlyAway(dx != 0 ? dx : speedX);
        } else {
          _runSpringBack();
        }
      },
      onTap: widget.onTap,
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..translate(
            _dragAlignment.x * (size.width / 2),
            _dragAlignment.y * (size.height / 2),
          )
          ..rotateZ(_angle),
        child: widget.child,
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const EventCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 480,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.green.shade500, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.event, color: Colors.green.shade600, size: 80),
          ),
          const SizedBox(height: 32),
          Text(
            data['title'] ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _infoRow(Icons.access_time_filled, data['time'] ?? '', Colors.blue),
          const SizedBox(height: 12),
          _infoRow(Icons.location_on, data['location'] ?? '', Colors.red),
          const SizedBox(height: 12),
          _infoRow(Icons.tag, data['type'] ?? '', Colors.orange),
          const Spacer(),
          const Text(
            'Nhấn để xem chi tiết  •  Vuốt để chọn',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class EventDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const EventDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_drop_down_circle,
            color: Colors.black,
            size: 36,
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: 'event_card_${data['id']}',
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: EventCard(data: data),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.description, color: Colors.green, size: 28),
                      SizedBox(width: 12),
                      Text(
                        'Chi Tiết Mô Tả Chương Trình',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 1.5, height: 40),
                  Text(
                    data['description'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 60),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: () => context.pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      icon: const Icon(Icons.favorite, color: Colors.white),
                      label: const Text(
                        'Tham gia nhanh',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
