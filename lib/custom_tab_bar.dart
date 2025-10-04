import 'package:flutter/material.dart';

// ==================================================================
// ** 1. تعريف الألوان الجديدة لتطابق الصورة المرفقة **
// ==================================================================

// لون خلفية الصفحة الداكن
const Color darkBackgroundColor = Color(0xFF1E2129); 
// لون أغمق لخلفية شريط التنقل العائم
const Color darkAppBarColor = Color(0xFF121418); 
// اللون الأرجواني للتبويب المختار (نفس اللون تقريبًا في الصورة)
const Color primaryPurple = Color(0xFF6C47E5); 


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // نجعل التبويب الأول (الرئيسية) هو المختار افتراضيًا
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. تعيين لون خلفية الـ Scaffold باللون الداكن
      backgroundColor: darkBackgroundColor,
      
      appBar: AppBar(
        title: const Text('Custom Bottom Bar Example', style: TextStyle(color: Colors.white)),
        backgroundColor: darkBackgroundColor, // لجعل الـ AppBar داكنًا أيضًا
        elevation: 0, // لإزالة الظل الافتراضي للـ AppBar
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      
      body: Center(
        child: Text(
          'Selected Index: $_selectedIndex',
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
      
      // 2. تم حذف Theme حول bottomNavigationBar للسماح للـ Container بالتحكم في الخلفية
      bottomNavigationBar: CustomTabBar(
        selectedIndex: _selectedIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}

// ------------------------------------------------------------------
// ** CustomTabBar - التعديلات لجعله عائمًا وبلون داكن واضح **
// ------------------------------------------------------------------

class CustomTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const CustomTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  // تم تعديل التسميات لتطابق المثال
  final List<String> labels = const [
    "الرئيسية", // لاحظ أن النص في الصورة "الانيسية" قد يكون خطأ مطبعي، تم تعديله إلى "الرئيسية"
    "المباريات",
    "الطائرة",
    "التفاحة",
    "Cups",
    "الاشتراكات",
  ];

  // تم تعديل بعض الأيقونات
  final List<IconData> icons = const [
    Icons.home_outlined,
    Icons.sports_soccer,
    Icons.flight_takeoff,
    Icons.apple,
    Icons.emoji_events_outlined,
    Icons.subscriptions,
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      // إضافة حواف (Margin) لجعل البار عائمًا
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: bottomPadding > 0 ? bottomPadding : 12,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      
      // *** 3. التعديل لجعل الخلفية داكنة صلبة ومستديرة ***
      decoration: BoxDecoration(
        color: darkAppBarColor, // لون خلفية شريط التنقل
        borderRadius: BorderRadius.circular(35), // زيادة الاستدارة
        boxShadow: [
          // إضافة ظل خفيف جدًا لجعله يبدو أكثر بروزًا
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

// ------------------------------------------------------------------
// ** _TabItem - التعديلات لتطبيق اللون الأرجواني والإضاءة (Glow) **
// ------------------------------------------------------------------

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
      // اللون للرموز غير المختارة، وهو لون رمادي فاتح تقريبًا #A0A4AE
      const Color inactiveIconColor = Color(0xFFA0A4AE);

      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          // زيادة الـ padding ليتطابق مع شكل الشريط في الصورة
          padding: EdgeInsets.symmetric(
            horizontal: isSelected ? 18 : 12, 
            vertical: 10,
          ),
          decoration: BoxDecoration(
            // *** التعديل 1: استخدام اللون الأرجواني للخلفية المختارة ***
            color: isSelected ? primaryPurple : Colors.transparent, 
            borderRadius: BorderRadius.circular(30),
            
            // *** التعديل 2: إضافة الظل/الإضاءة (Glow) للتبويب المختار ***
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: primaryPurple.withOpacity(0.4), // لون ظل بنفسجي شفاف
                      blurRadius: 10, // نصف قطر ضبابية عالية
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
                // لون الرمز: أبيض للمختار، رمادي لغير المختار
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