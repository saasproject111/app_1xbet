import 'package:flutter/material.dart';
import 'dart:ui'; // لتمكين استخدام BackdropFilter للضبابية

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  // دالة بناء مربع (Section) - يمكن استخدامها لتنظيم المحتوى
  Widget _buildSimpleSection({required String title, required String content}) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(height: 10),
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
                    'توقع المباريات', // العنوان الجديد
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
                      title: "⚽ مباراة اليوم",
                      content: "ريال مدريد ضد برشلونة - قمة الليلة!",
                    ),
                    _buildSimpleSection(
                      title: "📅 الجولة القادمة",
                      content: "استعد لتوقعات الجولة 15 للدوري الإنجليزي الممتاز.",
                    ),
                    _buildSimpleSection(
                      title: "🏅 تصنيفات",
                      content: "اكتشف أعلى 5 متوقعين في هذا الشهر.",
                    ),
                    _buildSimpleSection(
                      title: "🔔 إشعارات",
                      content: "تذكير: لم يتبقى سوى ساعتين لإرسال توقعاتك.",
                    ),
                    const SizedBox(height: 40),
                    const Center(
                      child: Text(
                        'تابع التوقعات وشارك بآرائك',
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
