import 'package:flutter/material.dart';
import 'dart:ui'; // لتمكين استخدام BackdropFilter للضبابية

class CupsScreen extends StatelessWidget {
  const CupsScreen({super.key});

  // دالة بناء مربع (Section) - يمكن استخدامها لتنظيم المحتوى
  Widget _buildSimpleSection({required String title, required String content, required IconData icon}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF334155).withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.amber, size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF94A3B8),
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 5),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // خلفية الشاشة (Gradient Background)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFF0F172A),
                  Color(0xFF1E293B),
                  Color(0xFF0F172A),
                ],
              ),
            ),
          ),
          
          CustomScrollView(
            slivers: [
              // ===============================================
              // رأس الصفحة الضبابي (SliverAppBar with Blur)
              // ===============================================
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 150.0, 
                floating: true,
                pinned: true,
                elevation: 0,
                
                // اللون الذي يظهر عند التثبيت (معتم بنسبة 95% لإخفاء المحتوى تحته)
                backgroundColor: const Color(0xFF1E293B).withOpacity(0.95), 
                
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 20), 
                  
                  title: const Text(
                    '🏆 الكؤوس والتحديات', // العنوان الجديد
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  background: ClipRRect(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
                    child: Stack(
                      children: [
                        BackdropFilter(
                          // تطبيق الضبابية القصوى
                          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30), 
                          child: Container(
                            // عتامة منخفضة (20%) لضمان أن الشريط شفاف عندما يكون ممتدًا
                            color: const Color(0xFF1E293B).withOpacity(0.2), 
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // ===============================================
              // محتوى الصفحة (SliverList)
              // ===============================================
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _buildSimpleSection(
                      title: "كأس اليوم",
                      content: "انضم إلى تحدي الـ 24 ساعة للفوز بجائزة كبرى.",
                      icon: Icons.access_time_filled,
                    ),
                    _buildSimpleSection(
                      title: "تحدي الأسبوع",
                      content: "توقع الفائزين في البطولات الكبرى لتتصدر القائمة.",
                      icon: Icons.calendar_today,
                    ),
                    _buildSimpleSection(
                      title: "أرشيف الكؤوس",
                      content: "استعرض إنجازاتك والكؤوس التي حصلت عليها سابقاً.",
                      icon: Icons.archive_outlined,
                    ),
                    _buildSimpleSection(
                      title: "القوانين والإرشادات",
                      content: "تعرف على قواعد كل مسابقة لضمان مشاركة عادلة.",
                      icon: Icons.rule_sharp,
                    ),
                    const SizedBox(height: 40),
                    const Center(
                      child: Text(
                        'ابدأ التحدي واكسب جوائزك',
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
