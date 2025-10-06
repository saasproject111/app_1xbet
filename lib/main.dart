import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'firebase_options.dart'; // الملف الذي يولده flutterfire configure

import 'custom_tab_bar.dart';
import 'screens/home_screen.dart';
import 'screens/matches_screen.dart';
import 'screens/flight_screen.dart';
import 'screens/cups_screen.dart';
import 'screens/profile_screen.dart'; // 👤 صفحة ملفي الجديدة بدل التفاحة
import 'screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔥 تهيئة Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🧩 تهيئة Supabase
  await Supabase.initialize(
    url: 'https://uzxjgdhkrruzppvdziso.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV6eGpnZGhrcnJ1enBwdmR6aXNvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk2MzAzMDYsImV4cCI6MjA3NTIwNjMwNn0.3iV-KoF-AvDvM2Vb_LZzHEUmOeCanoMmcX2DTHSxZko',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crash Game Predictor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        fontFamily: 'Arial',
      ),
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

  // ✅ ترتيب الصفحات الجديد من اليسار لليمين
  final List<Widget> pages = const [
  HomeScreen(),
  MatchesScreen(),
  FlightScreen(),
  CupsScreen(),  // 🏆 Cups
  AppleScreen(), // 👤 ملفي
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
