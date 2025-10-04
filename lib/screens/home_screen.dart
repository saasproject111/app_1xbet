import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:ui'; // لاستخدام BackdropFilter
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String currentDate = '';
  late AnimationController _pulseController;
  Timer? _dateTimer;

  @override
  void initState() {
    super.initState();
    _updateDate();
    
    _dateTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updateDate();
    });

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  void _updateDate() {
    setState(() {
      currentDate = DateFormat('dd MMM yyyy').format(DateTime.now());
    });
  }

  @override
  void dispose() {
    _dateTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  // دالة بناء مربع (Section) - الكود الخاص بك
  Widget _buildSection({required String title, required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E293B).withOpacity(0.85),
            const Color(0xFF0F172A).withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF334155).withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  // دالة بناء الكروت - الكود الخاص بك
  Widget _buildCouponCard({
    required String title,
    required String value,
    required List<Color> gradientColors,
    required Color shadowColor,
    required VoidCallback onTap,
    bool isSmallText = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.card_giftcard_rounded,
              color: Colors.white,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: isSmallText ? 12 : 24,
                fontWeight: FontWeight.w900,
                color: Colors.white.withOpacity(0.95),
              ),
            ),
          ],
        ),
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
              // 1. رأس الصفحة الضبابي (SliverAppBar with Blur)
              // ===============================================
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 150.0, 
                floating: true,
                pinned: true,
                elevation: 0,
                
                // *** التعديل 1: تحديد لون ثابت (معتم) يظهر عند التثبيت ***
                // عند التمرير، يتغير هذا اللون من الشفافية إلى العتامة الكاملة (100%)
                backgroundColor: const Color(0xFF1E293B).withOpacity(0.95), 
                
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 20), 
                  
                  title: const Text(
                    'الشاشة الرئيسية',
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
                          // *** التعديل 2: زيادة الضبابية لأقصى حد (30) ***
                          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30), 
                          child: Container(
                            // *** التعديل 3: استخدام عتامة منخفضة (20%) للـ BackdropFilter فقط ***
                            // هذا سيجعل الخلفية ضبابية وشفافة جدًا عندما يكون الشريط ممتدًا
                            color: const Color(0xFF1E293B).withOpacity(0.2), 
                          ),
                        ),
                        // *** تم حذف هذا الكونتينر ليحل محله خاصية backgroundColor في SliverAppBar ***
                        // Container(
                        //   color: const Color(0xFF1E293B).withOpacity(0.5), 
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
              
              // ===============================================
              // 2. محتوى الصفحة (SliverList)
              // ===============================================
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          // ===== مربع (1) كوبونات =====
                          _buildSection(
                            title: "🎁 كوبونات",
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildCouponCard(
                                      title: 'كوبون إيداع',
                                      value: '95%',
                                      gradientColors: const [Color(0xFF10B981), Color(0xFF059669)],
                                      shadowColor: const Color(0xFF10B981),
                                      onTap: () {},
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildCouponCard(
                                      title: 'كوبون عشوائي',
                                      value: 'قريباً',
                                      gradientColors: const [Color(0xFF3B82F6), Color(0xFF2563EB)],
                                      shadowColor: const Color(0xFF3B82F6),
                                      isSmallText: true,
                                      onTap: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // ===== مربع (2) آخر الأخبار =====
                          _buildSection(
                            title: "📰 آخر الأخبار",
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildCouponCard(
                                      title: 'خبر عاجل',
                                      value: 'جديد',
                                      gradientColors: const [Color(0xFFF59E0B), Color(0xFFD97706)],
                                      shadowColor: const Color(0xFFF59E0B),
                                      onTap: () {},
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildCouponCard(
                                      title: 'مقال مميز',
                                      value: 'اقرأ الآن',
                                      gradientColors: const [Color(0xFF06B6D4), Color(0xFF0891B2)],
                                      shadowColor: const Color(0xFF06B6D4),
                                      isSmallText: true,
                                      onTap: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // ===== مربع (3) الرئيسية =====
                          _buildSection(
                            title: "🏠 الرئيسية",
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildCouponCard(
                                      title: 'خدمة 1',
                                      value: 'متاح',
                                      gradientColors: const [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                                      shadowColor: const Color(0xFF8B5CF6),
                                      onTap: () {},
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildCouponCard(
                                      title: 'خدمة 2',
                                      value: 'مفتوح',
                                      gradientColors: const [Color(0xFFEF4444), Color(0xFFDC2626)],
                                      shadowColor: const Color(0xFFEF4444),
                                      onTap: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 30),

                          // ===== آخر تحديث =====
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedBuilder(
                                animation: _pulseController,
                                builder: (context, child) {
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        width: 12 + (_pulseController.value * 8),
                                        height: 12 + (_pulseController.value * 8),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(0xFF10B981).withOpacity(
                                            0.6 * (1 - _pulseController.value),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF10B981),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'آخر تحديث',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFFCBD5E1),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                currentDate,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
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