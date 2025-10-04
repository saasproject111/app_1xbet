import 'package:flutter/material.dart';
import 'dart:ui'; // لتمكين استخدام BackdropFilter للضبابية

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  // ===============================================
  // دالة بناء بطاقة الاشتراك
  // ===============================================
  Widget _buildSubscriptionCard({
    required String title,
    required String subtitle,
    required String price,
    required Color accentColor,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E293B).withOpacity(0.85),
            const Color(0xFF0F172A).withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: accentColor.withOpacity(0.4),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: accentColor.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 40, color: accentColor),
              Text(
                price,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF94A3B8),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Text(
              'اشترك الآن',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
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
                expandedHeight: 180.0, // ارتفاع أكبر ليتسع العنوان
                floating: true,
                pinned: true,
                elevation: 0,
                
                // اللون الذي يظهر عند التثبيت (معتم بنسبة 95% لإخفاء المحتوى تحته)
                backgroundColor: const Color(0xFF1E293B).withOpacity(0.95), 
                
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 20), 
                  
                  title: const Text(
                    '💰 خطط الاشتراكات المميزة', // عنوان الشاشة
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
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
              // محتوى الصفحة (SliverList) - خطط الاشتراكات
              // ===============================================
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(20, 30, 20, 10),
                      child: Text(
                        "اختر الخطة المناسبة لك للوصول للميزات الإضافية.",
                        style: TextStyle(fontSize: 18, color: Color(0xFFCBD5E1)),
                        textAlign: TextAlign.right,
                      ),
                    ),

                    // 1. اشتراك توقع المباريات
                    _buildSubscriptionCard(
                      title: "باقة توقع المباريات المتقدمة",
                      subtitle: "تحليلات عميقة، وتوقعات الخبراء، ودخول للمسابقات الحصرية.",
                      price: "50\$ / ش",
                      accentColor: const Color(0xFF3B82F6), // Blue
                      icon: Icons.sports_soccer_rounded,
                    ),

                    // 2. اشتراك لعبة Crash
                    _buildSubscriptionCard(
                      title: "باقة Crash الذهبية",
                      subtitle: "وصول لسجل النتائج المباشرة، وخاصية السحب التلقائي الذكي.",
                      price: "75\$ / ش",
                      accentColor: const Color(0xFFF59E0B), // Amber
                      icon: Icons.rocket_launch_rounded,
                    ),

                    // 3. اشتراك الكؤوس والتحديات
                    _buildSubscriptionCard(
                      title: "باقة تحدي الكؤوس الممتاز",
                      subtitle: "إشعارات فورية، ومضاعف نقاط إضافي، وتصنيف خاص في التحديات.",
                      price: "40\$ / ش",
                      accentColor: const Color(0xFF10B981), // Green
                      icon: Icons.emoji_events_rounded,
                    ),

                    // 4. اشتراك لعبة التفاحة
                    _buildSubscriptionCard(
                      title: "باقة التفاحة VIP",
                      subtitle: "نسب ربح محسّنة قليلاً، وميزة إعادة اللعب في الجولات الخاسرة.",
                      price: "60\$ / ش",
                      accentColor: const Color(0xFFEF4444), // Red
                      icon: Icons.apple_rounded,
                    ),

                    const SizedBox(height: 40),
                    const Center(
                      child: Text(
                        'الإشتراكات تجدد تلقائياً شهرياً.',
                        style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
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