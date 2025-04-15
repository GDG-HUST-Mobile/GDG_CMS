import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RoundedBottomAppBar extends StatefulWidget {
  const RoundedBottomAppBar({super.key});

  @override
  State<RoundedBottomAppBar> createState() => _RoundedBottomAppBarState();
}

class _RoundedBottomAppBarState extends State<RoundedBottomAppBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 4.0,
        borderRadius: BorderRadius.circular(30.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _BottomAppBarItem(
                imagePath: 'assets/home_icon.png', // Replace with your home icon path
                label: 'Home',
                isSelected: _selectedIndex == 0,
                onPressed: () => _onItemTapped(0),
              ),
              _BottomAppBarItem(
                imagePath: 'assets/memories_icon.png', // Replace with your memories icon path
                label: 'Memories',
                isSelected: _selectedIndex == 1,
                onPressed: () => _onItemTapped(1),
              ),
              _BottomAppBarItem(
                imagePath: 'assets/profile_icon.png', // Replace with your profile icon path
                label: 'Profile',
                isSelected: _selectedIndex == 2,
                onPressed: () => _onItemTapped(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomAppBarItem extends StatefulWidget {
  final String imagePath;
  final String label;
  final VoidCallback onPressed;
  final bool isSelected;

  const _BottomAppBarItem({
    required this.imagePath,
    required this.label,
    required this.onPressed,
    this.isSelected = false,
  });

  @override
  State<_BottomAppBarItem> createState() => _BottomAppBarItemState();
}

class _BottomAppBarItemState extends State<_BottomAppBarItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final bool isCurrentlySelected = widget.isSelected;
    final Color iconColor = _isHovering || isCurrentlySelected ? Colors.blue : Colors.grey;
    final Color textColor = _isHovering || isCurrentlySelected ? Colors.blue : Colors.grey;
    final double iconSize = _isHovering || isCurrentlySelected ? 28.0 : 24.0;
    final double textSize = _isHovering || isCurrentlySelected ? 14.0 : 12.0;

    return MouseRegion(
      onEnter: (event) {
        setState(() {
          _isHovering = true;
        });
      },
      onExit: (event) {
        setState(() {
          _isHovering = false;
        });
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20.0),
          onTap: widget.onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: iconSize,
                  height: iconSize,
                  child: Image.asset(
                    widget.imagePath,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  widget.label,
                  style: GoogleFonts.openSans(
                    color: textColor,
                    fontSize: textSize,
                    fontWeight: _isHovering || isCurrentlySelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
