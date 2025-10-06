import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

const Color darkBackgroundColor = Color(0xFF1E2129);
const Color darkAppBarColor = Color(0xFF121418);
const Color primaryPurple = Color(0xFF6C47E5);

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,

      appBar: AppBar(
        title: const Text('Custom Bottom Bar Example', style: TextStyle(color: Colors.white)),
        backgroundColor: darkBackgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Center(
        child: Text(
          'Selected Index: $_selectedIndex',
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),

      bottomNavigationBar: CustomTabBar(
        selectedIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}

class CustomTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const CustomTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  final List<String> labels = const [
    "الرئيسية",
    "المباريات",
    "الطائرة",
    "الكره",
    "ملفي",
    "الاشتراكات",
  ];

  final List<IconData> icons = const [
    Icons.home_outlined,
    Icons.sports_score_outlined,
    Icons.flight_takeoff,
    Icons.sports_basketball,
    Icons.person_outline_rounded,
    Icons.subscriptions,
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: bottomPadding > 0 ? bottomPadding : 12,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),

      decoration: BoxDecoration(
        color: darkAppBarColor,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(icons.length, (index) {
              final bool isSelected = selectedIndex == index;
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 4 : 2,
                  right: index == icons.length - 1 ? 4 : 2,
                ),
                child: _TabItem(
                  icon: icons[index],
                  label: labels[index],
                  isSelected: isSelected,
                  onTap: () => onTabSelected(index),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
    final IconData icon;
    final String label;
    final bool isSelected;
    final VoidCallback onTap;

    const _TabItem({
      required this.icon,
      required this.label,
      required this.isSelected,
      required this.onTap,
    });

    @override
    Widget build(BuildContext context) {
      const Color inactiveIconColor = Color(0xFFA0A4AE);

      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 18 : 12,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: isSelected ? primaryPurple : Colors.transparent,
            borderRadius: BorderRadius.circular(30),

            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: primaryPurple.withOpacity(0.4),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 0),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : inactiveIconColor,
                size: 24,
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                alignment: Alignment.centerRight,
                child: isSelected
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            height: 1.2,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
    }
}
