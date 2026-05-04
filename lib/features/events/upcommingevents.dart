import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:gdgocms/core/network/api_service.dart';
import 'package:gdgocms/core/router/app_router.dart';
import 'package:gdgocms/core/theme/app_colors.dart';
import 'package:gdgocms/core/theme/app_fonts.dart';

class UpcomingEventsScreen extends StatefulWidget {
  const UpcomingEventsScreen({super.key});

  @override
  State<UpcomingEventsScreen> createState() => _UpcomingEventsScreenState();
}

class _UpcomingEventsScreenState extends State<UpcomingEventsScreen> {
  final BaseApiService _apiService = BaseApiService();
  final AuthService _authService = AuthService();
  List<Map<String, dynamic>> _events = <Map<String, dynamic>>[];
  bool _isLoading = true;
  String? _errorMessage;
  bool _isListView = false;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      http.Response response = await _getEventsResponse();

      if (response.statusCode == 401 || response.statusCode == 403) {
        debugPrint(
          'Token expired/invalid (Status: ${response.statusCode}), attempting refresh...',
        );

        final String? refreshedToken = await _authService.refreshToken();

        if (refreshedToken != null) {
          // Thử gọi lại API một lần nữa với token mới
          response = await _getEventsResponse();
        } else {
          // Nếu không refresh được, yêu cầu người dùng đăng nhập lại
          setState(() {
            _errorMessage = "Phiên đăng nhập hết hạn. Vui lòng đăng nhập lại.";
            _isLoading = false;
          });
          return;
        }
      }

      if (response.statusCode != 200) {
        if (!mounted) {
          return;
        }
        setState(() {
          _isLoading = false;
          _errorMessage =
              'Không thể tải dữ liệu sự kiện (${response.statusCode}).';
        });
        return;
      }

      final dynamic decoded = jsonDecode(response.body);
      final List<Map<String, dynamic>> mapped = _extractEventsList(
        decoded,
      ).map(_mapEvent).toList();

      if (!mounted) {
        return;
      }

      setState(() {
        _events = mapped;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isLoading = false;
        _errorMessage = 'Mất kết nối hoặc có lỗi xảy ra. Vui lòng thử lại.';
      });
    }
  }

  Future<http.Response> _getEventsResponse() async {
    final Map<String, String> headers = await _apiService.getHeaders();
    return http.get(
      Uri.parse('${AuthService.baseUrl}/events'),
      headers: headers,
    );
  }

  List<Map<String, dynamic>> _extractEventsList(dynamic decoded) {
    if (decoded is List) {
      return decoded
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    if (decoded is Map<String, dynamic>) {
      final dynamic events =
          decoded['events'] ?? decoded['data'] ?? decoded['items'];
      if (events is List) {
        return events
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
    }

    return <Map<String, dynamic>>[];
  }

  Map<String, dynamic> _mapEvent(Map<String, dynamic> raw) {
    final String id = _readEventId(raw);
    final String title =
        _firstNonEmptyString(raw, const ['title']) ?? 'Untitled Event';
    final String description =
        _firstNonEmptyString(raw, const [
          'content',
          'description',
          'details',
          'summary',
        ]) ??
        '';
    final String author =
        _firstNonEmptyString(raw, const ['author', 'username']) ?? 'Ẩn danh';
    final int vote = _readVote(raw['vote']);
    final String time = _buildTime(raw);

    return <String, dynamic>{
      'id': id.isNotEmpty ? id : title,
      'title': title,
      'time': time,
      'author': author,
      'vote': vote,
      'description': description,
      'notifyTo': raw['notifyTo'],
      'confirmed': raw['confirmed'],
    };
  }

  String _buildTime(Map<String, dynamic> raw) {
    final String? createdAt = _formatCreatedAt(raw['createdAt']);
    if (createdAt != null) {
      return createdAt;
    }

    final String? timeText = _firstNonEmptyString(raw, const [
      'time',
      'dateTime',
      'startAt',
      'startsAt',
      'eventTime',
    ]);
    if (timeText != null) {
      return timeText;
    }

    final String? date = _firstNonEmptyString(raw, const [
      'date',
      'startDate',
      'eventDate',
    ]);
    final String? clock = _firstNonEmptyString(raw, const [
      'startTime',
      'hour',
    ]);
    if (date != null && clock != null) {
      return '$date - $clock';
    }
    return date ?? '';
  }

  String _readEventId(Map<String, dynamic> raw) {
    final dynamic idRaw = raw['_id'] ?? raw['id'];
    if (idRaw is Map && idRaw['\$oid'] != null) {
      return idRaw['\$oid'].toString();
    }
    return idRaw?.toString() ?? '';
  }

  int _readVote(dynamic voteRaw) {
    if (voteRaw is int) {
      return voteRaw;
    }
    if (voteRaw is String) {
      return int.tryParse(voteRaw) ?? 0;
    }
    return 0;
  }

  String? _formatCreatedAt(dynamic createdAtRaw) {
    String? isoString;
    if (createdAtRaw is String) {
      isoString = createdAtRaw;
    } else if (createdAtRaw is Map && createdAtRaw['\$date'] != null) {
      isoString = createdAtRaw['\$date'].toString();
    }

    if (isoString == null || isoString.isEmpty) {
      return null;
    }

    final DateTime? parsed = DateTime.tryParse(isoString);
    if (parsed == null) {
      return null;
    }
    final DateTime local = parsed.toLocal();
    return DateFormat("'Ngày' dd 'tháng' MM, yyyy").format(local);
  }

  String? _firstNonEmptyString(Map<String, dynamic> raw, List<String> keys) {
    for (final String key in keys) {
      final dynamic value = raw[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
      if (value != null && value is! String) {
        final String normalized = value.toString().trim();
        if (normalized.isNotEmpty) {
          return normalized;
        }
      }
    }
    return null;
  }

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
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isListView = !_isListView;
              });
            },
            icon: Icon(
              _isListView ? Icons.style_outlined : Icons.view_list_rounded,
              color: Colors.black,
            ),
            tooltip: _isListView ? 'Card view' : 'List view',
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? _buildErrorState()
          : _events.isEmpty
          ? _buildEmptyState()
          : _isListView
          ? _buildListView()
          : _buildCardsView(),
    );
  }

  Widget _buildCardsView() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        height: 520,
        child: Stack(clipBehavior: Clip.none, children: _buildCardStack()),
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

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 72),
            const SizedBox(height: 16),
            Text(
              _errorMessage ?? 'Đã xảy ra lỗi khi tải dữ liệu.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchEvents,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      itemCount: _events.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final Map<String, dynamic> eventData = _events[index];
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              context.push(AppRoutes.eventDetail, extra: eventData);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.green.shade300, width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.event,
                      color: Colors.green.shade600,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          eventData['title'] ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        if ((eventData['time'] ?? '').toString().isNotEmpty)
                          _buildListMetaRow(
                            Icons.access_time_filled,
                            (eventData['time'] ?? '').toString(),
                            Colors.blue,
                          ),
                        if ((eventData['author'] ?? '').toString().isNotEmpty)
                          _buildListMetaRow(
                            Icons.person_outline,
                            'Tạo bởi: ${(eventData['author'] ?? '').toString()}',
                            Colors.green,
                          ),
                        if (eventData['vote'] != null)
                          _buildListMetaRow(
                            Icons.thumb_up_alt_rounded,
                            '${eventData['vote']} lượt vote',
                            Colors.orange,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildListMetaRow(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
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
    final String title = (data['title'] ?? '').toString();
    final String author = (data['author'] ?? '').toString();
    final String description = (data['description'] ?? '').toString();
    final int vote = data['vote'] is int
        ? data['vote'] as int
        : int.tryParse((data['vote'] ?? '0').toString()) ?? 0;
    final String time = (data['time'] ?? '').toString();

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.event,
                  color: Colors.green.shade600,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Row(
                children: const [
                  _GoogleDot(color: Color(0xFF4285F4)),
                  SizedBox(width: 5),
                  _GoogleDot(color: Color(0xFFEA4335)),
                  SizedBox(width: 5),
                  _GoogleDot(color: Color(0xFFFBBC05)),
                  SizedBox(width: 5),
                  _GoogleDot(color: Color(0xFF34A853)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.h3.copyWith(
              fontSize: 23,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.person_outline, size: 16, color: AppColors.grey),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Tạo bởi: $author',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.subtitle2.copyWith(
                    color: AppColors.grey,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.subtitle1.copyWith(
              fontSize: 15,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              _MetaChip(
                icon: Icons.access_time_filled,
                label: time,
                iconColor: AppColors.blue,
              ),
              const SizedBox(width: 10),
              _MetaChip(
                icon: Icons.thumb_up_alt_rounded,
                label: '$vote lượt vote',
                iconColor: AppColors.yellow,
              ),
            ],
          ),
          const SizedBox(height: 12),
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
}

class EventDetailScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  const EventDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String title = (data['title'] ?? '').toString();
    final String author = (data['author'] ?? '').toString();
    final String description = (data['description'] ?? '').toString();
    final String time = (data['time'] ?? '').toString();
    final int vote = data['vote'] is int
        ? data['vote'] as int
        : int.tryParse((data['vote'] ?? '0').toString()) ?? 0;

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
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFEAF4FF), Color(0xFFEFFAF2)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.h3.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Thông tin sự kiện',
                    style: AppTextStyles.subtitle2.copyWith(fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _DetailInfoBox(
                    icon: Icons.access_time_filled,
                    label: time,
                    iconColor: AppColors.blue,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _DetailInfoBox(
                    icon: Icons.person_outline,
                    label: author,
                    iconColor: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _DetailInfoBox(
                    icon: Icons.thumb_up_alt_rounded,
                    label: '$vote vote',
                    iconColor: AppColors.yellow,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(Icons.description, color: AppColors.primary, size: 22),
                const SizedBox(width: 8),
                Text(
                  'Mô tả chi tiết',
                  style: AppTextStyles.title1.copyWith(
                    color: Colors.black87,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              description,
              style: AppTextStyles.subtitle1.copyWith(
                fontSize: 16,
                color: Colors.black87,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: SizedBox(
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: const StadiumBorder(),
            ),
            icon: const Icon(Icons.favorite, color: Colors.white),
            label: Text(
              'Tham gia ngay',
              style: AppTextStyles.title2.copyWith(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GoogleDot extends StatelessWidget {
  final Color color;
  const _GoogleDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: iconColor),
          const SizedBox(width: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.subtitle2.copyWith(
              color: AppColors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailInfoBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;

  const _DetailInfoBox({
    required this.icon,
    required this.label,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: iconColor),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTextStyles.subtitle2.copyWith(
              fontSize: 12,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
