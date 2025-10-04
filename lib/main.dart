import 'package:flutter/material.dart';
import 'custom_tab_bar.dart'; // تأكد من وجود هذا الملف
import 'screens/home_screen.dart';
import 'screens/matches_screen.dart';
import 'screens/flight_screen.dart';
import 'screens/apple_screen.dart';
import 'screens/cups_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/subscription_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // للتجربة: يمكنك تغيير home إلى LayoutScreen() لرؤية البار مباشرة
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
  
  // تعريف اللون الداكن لخلفية الشاشة (يمكنك تعديل القيمة لتناسب اللون الفعلي)
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
      // 1. تعيين لون خلفية الـ Scaffold باللون الداكن
      backgroundColor: darkBackgroundColor,
      
      // 2. الجسم (body) الآن يحتوي فقط على الصفحة المحددة
      body: pages[_selectedIndex],
      
      // 3. البار السفلي (bottomNavigationBar) تم وضعه هنا
      bottomNavigationBar: Theme(
        // استخدام Theme لتغيير الخلفية البيضاء التي تظهر تحت البار
        data: Theme.of(context).copyWith(
          // canvasColor هو الخاصية التي تتحكم بلون خلفية bottomNavigationBar
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