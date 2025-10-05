import 'package:flutter/material.dart';
import 'dart:ui';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends State<MatchesScreen> {
  // البيانات المؤقتة - يمكن استبدالها بـ Firebase لاحقاً
  final List<MatchPrediction> matches = [
    MatchPrediction(
      homeTeam: 'ريال مدريد',
      homeTeamLogo: '⚪',
      awayTeam: 'برشلونة',
      awayTeamLogo: '🔵',
      matchDate: '2025-10-06',
      matchTime: '20:00',
      predictedWinner: 'home',
      winProbability: 65,
      reasons: [
        'الفريق يلعب على أرضه',
        'أداء قوي في آخر 5 مباريات',
        'غياب لاعبين أساسيين للخصم',
        'سجل مواجهات إيجابي',
      ],
    ),
    MatchPrediction(
      homeTeam: 'مانشستر سيتي',
      homeTeamLogo: '🔷',
      awayTeam: 'ليفربول',
      awayTeamLogo: '🔴',
      matchDate: '2025-10-06',
      matchTime: '18:30',
      predictedWinner: 'draw',
      winProbability: 40,
      reasons: [
        'التعادل متوقع بنسبة عالية',
        'قوة متكافئة بين الفريقين',
        'آخر 3 لقاءات انتهت بالتعادل',
        'كلا الفريقين في قمة جاهزيتهم',
      ],
    ),
    MatchPrediction(
      homeTeam: 'باريس سان جيرمان',
      homeTeamLogo: '🔵',
      awayTeam: 'مارسيليا',
      awayTeamLogo: '⚪',
      matchDate: '2025-10-07',
      matchTime: '21:00',
      predictedWinner: 'home',
      winProbability: 75,
      reasons: [
        'تفوق واضح في جودة اللاعبين',
        'لم يخسر على أرضه هذا الموسم',
        'الخصم يعاني من إصابات',
        'معنويات عالية بعد الفوز الأخير',
      ],
    ),
    MatchPrediction(
      homeTeam: 'يوفنتوس',
      homeTeamLogo: '⚫',
      awayTeam: 'إنتر ميلان',
      awayTeamLogo: '🔵',
      matchDate: '2025-10-07',
      matchTime: '19:45',
      predictedWinner: 'away',
      winProbability: 55,
      reasons: [
        'الفريق الضيف في حالة ممتازة',
        'فوز في آخر 6 مباريات متتالية',
        'المهاجم الأول في أفضل حالاته',
        'ضعف في دفاع الفريق المضيف',
      ],
    ),
    MatchPrediction(
      homeTeam: 'بايرن ميونخ',
      homeTeamLogo: '🔴',
      awayTeam: 'دورتموند',
      awayTeamLogo: '🟡',
      matchDate: '2025-10-08',
      matchTime: '17:30',
      predictedWinner: 'home',
      winProbability: 70,
      reasons: [
        'هجوم ناري يسجل بكثرة',
        'سيطرة كاملة في الدوري',
        'احترافية عالية في المباريات الكبرى',
        'الجمهور سيكون العامل الحاسم',
      ],
    ),
  ];

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
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 150.0,
                floating: true,
                pinned: true,
                elevation: 0,
                backgroundColor: const Color(0xFF1E293B).withOpacity(0.95),

                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 20),
                  title: const Text(
                    'توقعات المباريات',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(15),
                    ),
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

              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _buildMatchCard(matches[index]);
                    },
                    childCount: matches.length,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCard(MatchPrediction match) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E293B).withOpacity(0.85),
            const Color(0xFF0F172A).withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF334155).withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildDateTimeSection(match),
                const SizedBox(height: 24),
                _buildTeamsSection(match),
                const SizedBox(height: 20),
                _buildProbabilityBar(match),
                const SizedBox(height: 24),
                _buildReasonsSection(match),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateTimeSection(MatchPrediction match) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF10B981),
            Color(0xFF059669),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.calendar_today_rounded,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            match.matchDate,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          const Icon(
            Icons.access_time_rounded,
            color: Colors.white,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            match.matchTime,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamsSection(MatchPrediction match) {
    return Row(
      children: [
        Expanded(
          child: _buildTeamInfo(
            teamName: match.homeTeam,
            teamLogo: match.homeTeamLogo,
            isWinner: match.predictedWinner == 'home',
            isDraw: match.predictedWinner == 'draw',
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF334155).withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'VS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        Expanded(
          child: _buildTeamInfo(
            teamName: match.awayTeam,
            teamLogo: match.awayTeamLogo,
            isWinner: match.predictedWinner == 'away',
            isDraw: match.predictedWinner == 'draw',
          ),
        ),
      ],
    );
  }

  Widget _buildTeamInfo({
    required String teamName,
    required String teamLogo,
    required bool isWinner,
    required bool isDraw,
  }) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF334155).withOpacity(0.8),
                const Color(0xFF1E293B).withOpacity(0.8),
              ],
            ),
            border: Border.all(
              color: isWinner
                  ? const Color(0xFF10B981)
                  : isDraw
                      ? const Color(0xFFF59E0B)
                      : const Color(0xFF475569),
              width: 3,
            ),
            boxShadow: isWinner
                ? [
                    BoxShadow(
                      color: const Color(0xFF10B981).withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : isDraw
                    ? [
                        BoxShadow(
                          color: const Color(0xFFF59E0B).withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
          ),
          child: Center(
            child: Text(
              teamLogo,
              style: const TextStyle(fontSize: 40),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          teamName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isWinner
                  ? Icons.check_circle_rounded
                  : isDraw
                      ? Icons.check_circle_outline_rounded
                      : Icons.circle_outlined,
              color: isWinner
                  ? const Color(0xFF10B981)
                  : isDraw
                      ? const Color(0xFFF59E0B)
                      : const Color(0xFF475569),
              size: 24,
            ),
            if (isWinner) ...[
              const SizedBox(width: 6),
              const Text(
                'فائز',
                style: TextStyle(
                  color: Color(0xFF10B981),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            if (isDraw) ...[
              const SizedBox(width: 6),
              const Text(
                'تعادل',
                style: TextStyle(
                  color: Color(0xFFF59E0B),
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildProbabilityBar(MatchPrediction match) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'احتمالية الفوز: ${match.winProbability}%',
              style: TextStyle(
                color: const Color(0xFFCBD5E1).withOpacity(0.9),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF10B981).withOpacity(0.2),
                    const Color(0xFF059669).withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF10B981).withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Text(
                match.winProbability >= 70
                    ? 'قوي جداً'
                    : match.winProbability >= 50
                        ? 'قوي'
                        : 'متوسط',
                style: const TextStyle(
                  color: Color(0xFF10B981),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: match.winProbability / 100,
            minHeight: 10,
            backgroundColor: const Color(0xFF334155).withOpacity(0.5),
            valueColor: AlwaysStoppedAnimation<Color>(
              match.winProbability >= 70
                  ? const Color(0xFF10B981)
                  : match.winProbability >= 50
                      ? const Color(0xFF3B82F6)
                      : const Color(0xFFF59E0B),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReasonsSection(MatchPrediction match) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF334155).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF3B82F6),
                      Color(0xFF2563EB),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.analytics_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'أسباب التوقع',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...match.reasons.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF10B981).withOpacity(0.3),
                          const Color(0xFF059669).withOpacity(0.3),
                        ],
                      ),
                      border: Border.all(
                        color: const Color(0xFF10B981),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: const TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        color: const Color(0xFFCBD5E1).withOpacity(0.9),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class MatchPrediction {
  final String homeTeam;
  final String homeTeamLogo;
  final String awayTeam;
  final String awayTeamLogo;
  final String matchDate;
  final String matchTime;
  final String predictedWinner;
  final int winProbability;
  final List<String> reasons;

  MatchPrediction({
    required this.homeTeam,
    required this.homeTeamLogo,
    required this.awayTeam,
    required this.awayTeamLogo,
    required this.matchDate,
    required this.matchTime,
    required this.predictedWinner,
    required this.winProbability,
    required this.reasons,
  });

  // يمكن إضافة دوال لتحويل البيانات من وإلى Firebase
  Map<String, dynamic> toJson() {
    return {
      'homeTeam': homeTeam,
      'homeTeamLogo': homeTeamLogo,
      'awayTeam': awayTeam,
      'awayTeamLogo': awayTeamLogo,
      'matchDate': matchDate,
      'matchTime': matchTime,
      'predictedWinner': predictedWinner,
      'winProbability': winProbability,
      'reasons': reasons,
    };
  }

  factory MatchPrediction.fromJson(Map<String, dynamic> json) {
    return MatchPrediction(
      homeTeam: json['homeTeam'] ?? '',
      homeTeamLogo: json['homeTeamLogo'] ?? '',
      awayTeam: json['awayTeam'] ?? '',
      awayTeamLogo: json['awayTeamLogo'] ?? '',
      matchDate: json['matchDate'] ?? '',
      matchTime: json['matchTime'] ?? '',
      predictedWinner: json['predictedWinner'] ?? 'home',
      winProbability: json['winProbability'] ?? 50,
      reasons: List<String>.from(json['reasons'] ?? []),
    );
  }
}
