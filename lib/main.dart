import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // الملف اللي بيتولد تلقائي من flutterfire configure

import 'custom_tab_bar.dart';
import 'screens/home_screen.dart';
import 'screens/matches_screen.dart';
import 'screens/flight_screen.dart';
import 'screens/apple_screen.dart';
import 'screens/cups_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/subscription_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 تهيئة Firebase هنا قبل أي شيء آخر
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const WelcomeScreen(),
    );
  }
}

class LayoutScreen extends StatefulWidget {
  const LayoutScreen({super.key});

  @override
  State<LayoutScreen> createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  int _selectedIndex = 0;
  final Color darkBackgroundColor = const Color(0xFF0F172A);

  final List<Widget> pages = const [
    HomeScreen(),
    MatchesScreen(),
    FlightScreen(),
    AppleScreen(),
    CupsScreen(),
    SubscriptionScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      body: pages[_selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: darkBackgroundColor,
        ),
        child: CustomTabBar(
          selectedIndex: _selectedIndex,
          onTabSelected: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
