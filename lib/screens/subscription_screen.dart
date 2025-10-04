import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/subscription_plan.dart';
import 'subscription_detail_screen.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  Widget _buildSubscriptionCard({
    required BuildContext context,
    required SubscriptionPlan plan,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubscriptionDetailScreen(plan: plan),
          ),
        );
      },
      child: Container(
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
            color: plan.accentColor.withOpacity(0.4),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: plan.accentColor.withOpacity(0.15),
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
                Icon(plan.icon, size: 40, color: plan.accentColor),
                Text(
                  '${plan.price}\$ / ش',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: plan.accentColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Text(
              plan.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              plan.subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF94A3B8),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: plan.accentColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: plan.accentColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    'اشترك الآن',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_back, color: Colors.white, size: 18),
                ],
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
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 180.0,
                floating: true,
                pinned: true,
                elevation: 0,
                backgroundColor: const Color(0xFF1E293B).withOpacity(0.95),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 20),
                  title: const Text(
                    '💰 خطط الاشتراكات المميزة',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(bottom: Radius.circular(15)),
                    child: Stack(
                      children: [
                        BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                          child: Container(
                            color: const Color(0xFF1E293B).withOpacity(0.2),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
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
                    _buildSubscriptionCard(
                      context: context,
                      plan: SubscriptionPlans.matchPrediction,
                    ),
                    _buildSubscriptionCard(
                      context: context,
                      plan: SubscriptionPlans.crashGame,
                    ),
                    _buildSubscriptionCard(
                      context: context,
                      plan: SubscriptionPlans.cupsChallenge,
                    ),
                    _buildSubscriptionCard(
                      context: context,
                      plan: SubscriptionPlans.appleGame,
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
