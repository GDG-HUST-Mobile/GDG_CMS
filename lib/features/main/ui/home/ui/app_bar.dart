import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(70); // Standard AppBar height

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: AppBar(
          // automaticallyImplyLeading: true,
          title: SizedBox(
            width: 60.0,
            height: 40.0,
            child: Image.asset(
              'assets/Logo.png',
              fit: BoxFit.contain,
            ),
          ),
          actions: <Widget>[
            Stack(
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {
                    // Handle notification button press
                    print('Notifications pressed');
                  },
                ),
                Positioned(
                  right: 8.0,
                  top: 8.0,
                  child: Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16.0,
                      minHeight: 16.0,
                    ),
                    child: const Text(
                      '1', // Replace with your notification count
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            // const SizedBox(width: 16.0), // Add some spacing on the right
          ],
        ),
      ),
    );
  }
}

