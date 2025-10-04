import 'package:flutter/material.dart';
import 'dart:ui'; // لتمكين استخدام BackdropFilter للضبابية

class AppleScreen extends StatelessWidget {
  const AppleScreen({super.key});

  // دالة بناء مربع (Section) - يمكن استخدامها لتنظيم المحتوى
  Widget _buildSimpleSection({required String title, required String content, required Color color}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 5),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
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
                    '🍎 التفاحة (Apple Game)', // العنوان الجديد
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
                      title: "🍏 بداية الجولة",
                      content: "اختر طبقك الآن. تذكر، قد تكون التفاحة سامة!",
                      color: const Color(0xFF34D399), // Green
                    ),
                    _buildSimpleSection(
                      title: "🍎 لوح المتصدرين",
                      content: "شاهد اللاعبين الأعلى ربحًا في لعبة التفاحة اليوم.",
                      color: const Color(0xFFF87171), // Red
                    ),
                    _buildSimpleSection(
                      title: "💰 سحب سريع",
                      content: "سحب أرباحك فورًا بعد كل جولة ناجحة.",
                      color: const Color(0xFFFBBF24), // Yellow/Amber
                    ),
                    const SizedBox(height: 40),
                    const Center(
                      child: Text(
                        'اختر بحذر وتمنى الحظ السعيد!',
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