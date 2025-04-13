// import 'package:flutter/material.dart';

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Simulate some initialization process
//     Future.delayed(Duration(seconds: 3), () {
//       // Navigate to the main screen after the delay
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => MainScreen()),
//       );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             // Your app logo or image
//             Image.asset('assets/logo.png', height: 100),
//             SizedBox(height: 20),
//             Text(
//               'Your App Name',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             CircularProgressIndicator(), // Optional loading indicator
//           ],
//         ),
//       ),
//     );
//   }
// }