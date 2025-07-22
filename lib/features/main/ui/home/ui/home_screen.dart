import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gdgocms/features/main/ui/home/ui/app_bar.dart';
import 'package:gdgocms/features/main/ui/home/model/calendar.dart';
import 'package:gdgocms/features/main/ui/home/model/FeatureCard.dart';

Color hexToColor(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Keep track of the selected item's index
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    // Update the selected index
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CalendarScreen(),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 12),
                child: Column(
                  children: [
                    FeatureCard(
                        imageAsset: 'assets/calendar 1.png',
                        title: "Events",
                        description: "Updating next events, meetings,...",
                        backgroundColor: hexToColor('#fcf3cf'),
                        iconBackgroundColor: hexToColor("#fcf3cf")
                    ),
                    const SizedBox(height: 10.0,),
                    FeatureCard(
                        imageAsset: 'assets/teamwork 1.png',
                        title: "Teammates",
                        description: "Missing teammates to join contests? Here they are",
                        backgroundColor: hexToColor('#d6eaf8'),
                        iconBackgroundColor: hexToColor("#d6eaf8")
                    ),
                    const SizedBox(height: 10.0,),
                    FeatureCard(
                        imageAsset: 'assets/podium 1.png',
                        title: "Leaderboards",
                        description: "See the current top rankings of the leaderboard",
                        backgroundColor: hexToColor('#a3e4d7'),
                        iconBackgroundColor: hexToColor("#a3e4d7")
                    ),
                    const SizedBox(height: 10.0,),
                    FeatureCard(
                        imageAsset: 'assets/support.png',
                        title: "Tools",
                        description: "See GDGoC-HUST’s other products",
                        backgroundColor: hexToColor('#fadbd8'),
                        iconBackgroundColor: hexToColor("#FE2B25")
                    ),
                    const SizedBox(height: 10.0,),
                    FeatureCard(
                        imageAsset: 'assets/setting (1) 1.png',
                        title: "Settings",
                        description: "Language, themes, bugs, about us,...",
                        backgroundColor: hexToColor('#eaeded'),
                        iconBackgroundColor: hexToColor("#eaeded")
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0), // Add some padding around the bar
        child: Material(
          elevation: 4.0, // Add a subtle shadow for the "floating" effect
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.black, width: 1.0),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _BottomAppBarItem(
                  imagePath: 'assets/navBarItem1.png',
                  label: 'Home',
                  isSelected: _selectedIndex == 0,
                  onPressed: () => _onItemTapped(0),
                ),
                _BottomAppBarItem(
                  imagePath: 'assets/navBarItem2.png',
                  label: 'Memories',
                  isSelected: _selectedIndex == 1,
                  onPressed: () => _onItemTapped(1),
                ),
                _BottomAppBarItem(
                  imagePath: 'assets/navBarItem3.png',
                  label: 'Profile',
                  isSelected: _selectedIndex == 2,
                  onPressed: () => _onItemTapped(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// bottomNavigationBar
class _BottomAppBarItem extends StatefulWidget {
  final String imagePath; // Changed from IconData icon
  final String label;
  final VoidCallback onPressed;
  final bool isSelected;

  const _BottomAppBarItem({
    required this.imagePath, // Changed from required this.icon
    required this.label,
    required this.onPressed,
    this.isSelected = false,
  });

  @override
  State<_BottomAppBarItem> createState() => _BottomAppBarItemState();
}

class _BottomAppBarItemState extends State<_BottomAppBarItem> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTap: widget.onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 5.0
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox( // Optional: control the size of the image
                width: 24.0,
                height: 24.0,
                child: Image.asset(
                  widget.imagePath,
                  fit: BoxFit.contain,
                  // color: isSelected
                  //     ? Colors.blue
                  //     : Colors.grey, // Optional: tint the image
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                widget.label,
                style: GoogleFonts.openSans(
                  color: widget.isSelected ? Colors.blue : Colors.grey,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
