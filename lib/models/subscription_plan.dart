import 'package:flutter/material.dart';

/// نموذج خطة الاشتراك
class SubscriptionPlan {
  final String id;
  final String title;
  final String subtitle;
  final String price;
  final String duration;
  final Color accentColor;
  final IconData icon;
  final List<SubscriptionFeature> features;
  final String description;
  final List<String> highlights;

  const SubscriptionPlan({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.duration,
    required this.accentColor,
    required this.icon,
    required this.features,
    required this.description,
    required this.highlights,
  });
}

/// ميزة من ميزات الاشتراك
class SubscriptionFeature {
  final String title;
  final String description;
  final IconData icon;
  final bool isPremium;

  const SubscriptionFeature({
    required this.title,
    required this.description,
    required this.icon,
    this.isPremium = false,
  });
}

/// بيانات الخطط الثابتة
class SubscriptionPlans {
  static const matchPrediction = SubscriptionPlan(
    id: 'match_prediction',
    title: 'باقة توقع المباريات المتقدمة',
    subtitle: 'تحليلات عميقة، وتوقعات الخبراء، ودخول للمسابقات الحصرية.',
    price: '50',
    duration: 'شهرياً',
    accentColor: Color(0xFF3B82F6),
    icon: Icons.sports_soccer_rounded,
    description: 'احصل على تحليلات احترافية وتوقعات دقيقة للمباريات من خبراء كرة القدم، مع إمكانية الدخول في مسابقات حصرية والفوز بجوائز قيمة.',
    highlights: [
      'تحليلات مباريات يومية من خبراء محترفين',
      'توقعات دقيقة بنسبة نجاح عالية',
      'دخول حصري للمسابقات الأسبوعية',
      'جوائز نقدية للفائزين',
    ],
    features: [
      SubscriptionFeature(
        title: 'تحليلات متقدمة',
        description: 'تحليل شامل لكل مباراة يشمل الإحصائيات والتشكيلات المتوقعة',
        icon: Icons.analytics_rounded,
      ),
      SubscriptionFeature(
        title: 'توقعات الخبراء',
        description: 'توقعات من محللين رياضيين محترفين بخبرة تزيد عن 10 سنوات',
        icon: Icons.person_rounded,
        isPremium: true,
      ),
      SubscriptionFeature(
        title: 'مسابقات حصرية',
        description: 'شارك في مسابقات أسبوعية واربح جوائز نقدية قيمة',
        icon: Icons.emoji_events_rounded,
        isPremium: true,
      ),
      SubscriptionFeature(
        title: 'إشعارات فورية',
        description: 'احصل على إشعارات مباشرة قبل بداية المباريات المهمة',
        icon: Icons.notifications_active_rounded,
      ),
      SubscriptionFeature(
        title: 'سجل التوقعات',
        description: 'تتبع نسبة نجاح توقعاتك وقارنها مع اللاعبين الآخرين',
        icon: Icons.history_rounded,
      ),
      SubscriptionFeature(
        title: 'دعم فني مميز',
        description: 'دعم فني على مدار الساعة لحل أي مشكلة تواجهك',
        icon: Icons.support_agent_rounded,
      ),
    ],
  );

  static const crashGame = SubscriptionPlan(
    id: 'crash_game',
    title: 'باقة Crash الذهبية',
    subtitle: 'وصول لسجل النتائج المباشرة، وخاصية السحب التلقائي الذكي.',
    price: '75',
    duration: 'شهرياً',
    accentColor: Color(0xFFF59E0B),
    icon: Icons.rocket_launch_rounded,
    description: 'استمتع بتجربة لعب Crash محسّنة مع ميزات حصرية تشمل السحب التلقائي الذكي وتتبع النتائج المباشرة لتحسين استراتيجيتك.',
    highlights: [
      'خاصية السحب التلقائي الذكي',
      'سجل النتائج المباشرة والإحصائيات',
      'تنبيهات للفرص الذهبية',
      'استراتيجيات متقدمة للعب',
    ],
    features: [
      SubscriptionFeature(
        title: 'السحب التلقائي الذكي',
        description: 'نظام ذكي يسحب أموالك تلقائياً عند الوصول للمضاعف المحدد',
        icon: Icons.smart_toy_rounded,
        isPremium: true,
      ),
      SubscriptionFeature(
        title: 'سجل النتائج المباشر',
        description: 'تتبع آخر 100 نتيجة مع تحليلات إحصائية متقدمة',
        icon: Icons.bar_chart_rounded,
        isPremium: true,
      ),
      SubscriptionFeature(
        title: 'تنبيهات الفرص',
        description: 'احصل على تنبيهات عند ظهور أنماط واعدة في اللعبة',
        icon: Icons.lightbulb_rounded,
      ),
      SubscriptionFeature(
        title: 'استراتيجيات محفوظة',
        description: 'احفظ واستخدم استراتيجيات اللعب المفضلة لديك',
        icon: Icons.bookmark_rounded,
      ),
      SubscriptionFeature(
        title: 'وضع التدريب',
        description: 'تدرب على استراتيجيات جديدة بدون مخاطرة',
        icon: Icons.school_rounded,
      ),
      SubscriptionFeature(
        title: 'تحليل الأداء',
        description: 'تقارير مفصلة عن أدائك وكيفية تحسينه',
        icon: Icons.trending_up_rounded,
        isPremium: true,
      ),
    ],
  );

  static const cupsChallenge = SubscriptionPlan(
    id: 'cups_challenge',
    title: 'باقة تحدي الكؤوس الممتاز',
    subtitle: 'إشعارات فورية، ومضاعف نقاط إضافي، وتصنيف خاص في التحديات.',
    price: '40',
    duration: 'شهرياً',
    accentColor: Color(0xFF10B981),
    icon: Icons.emoji_events_rounded,
    description: 'تفوق على منافسيك في تحديات الكؤوس مع مضاعف نقاط حصري وتصنيف VIP يظهر تميزك أمام الجميع.',
    highlights: [
      'مضاعف نقاط x2 في جميع التحديات',
      'تصنيف VIP مميز في قائمة المتصدرين',
      'إشعارات فورية لبداية التحديات',
      'دخول مجاني لتحديات خاصة',
    ],
    features: [
      SubscriptionFeature(
        title: 'مضاعف النقاط x2',
        description: 'احصل على ضعف النقاط في جميع التحديات والمسابقات',
        icon: Icons.stars_rounded,
        isPremium: true,
      ),
      SubscriptionFeature(
        title: 'تصنيف VIP',
        description: 'شارة ذهبية مميزة تظهر بجانب اسمك في جميع التصنيفات',
        icon: Icons.workspace_premium_rounded,
        isPremium: true,
      ),
      SubscriptionFeature(
        title: 'إشعارات فورية',
        description: 'كن أول من يعلم ببداية التحديات الجديدة',
        icon: Icons.notifications_active_rounded,
      ),
      SubscriptionFeature(
        title: 'تحديات خاصة',
        description: 'دخول حصري لتحديات VIP بجوائز أكبر',
        icon: Icons.lock_open_rounded,
        isPremium: true,
      ),
      SubscriptionFeature(
        title: 'سجل الإنجازات',
        description: 'عرض مفصل لجميع إنجازاتك وكؤوسك',
        icon: Icons.military_tech_rounded,
      ),
      SubscriptionFeature(
        title: 'أولوية الدعم',
        description: 'دعم فني بأولوية قصوى لحل مشاكلك فوراً',
        icon: Icons.priority_high_rounded,
      ),
    ],
  );

  static const appleGame = SubscriptionPlan(
    id: 'apple_game',
    title: 'باقة التفاحة VIP',
    subtitle: 'نسب ربح محسّنة قليلاً، وميزة إعادة اللعب في الجولات الخاسرة.',
    price: '60',
    duration: 'شهرياً',
    accentColor: Color(0xFFEF4444),
    icon: Icons.apple_rounded,
    description: 'استمتع بتجربة لعب محسّنة مع نسب ربح أفضل وفرصة إعادة اللعب في الجولات الخاسرة لتعويض خسائرك.',
    highlights: [
      'نسب ربح محسّنة بنسبة 5%',
      'إعادة لعب مجانية في الجولات الخاسرة',
      'تلميحات ذكية أثناء اللعب',
      'مكافآت يومية مضاعفة',
    ],
    features: [
      SubscriptionFeature(
        title: 'نسب ربح محسّنة',
        description: 'احصل على نسبة ربح أعلى بمعدل 5% في جميع الجولات',
        icon: Icons.trending_up_rounded,
        isPremium: true,
      ),
      SubscriptionFeature(
        title: 'إعادة اللعب',
        description: 'فرصة واحدة يومياً لإعادة لعب جولة خاسرة مجاناً',
        icon: Icons.replay_rounded,
        isPremium: true,
      ),
      SubscriptionFeature(
        title: 'تلميحات ذكية',
        description: 'نظام تلميحات يساعدك على اتخاذ القرارات الصحيحة',
        icon: Icons.tips_and_updates_rounded,
      ),
      SubscriptionFeature(
        title: 'مكافآت مضاعفة',
        description: 'احصل على ضعف المكافآت اليومية والأسبوعية',
        icon: Icons.card_giftcard_rounded,
        isPremium: true,
      ),
      SubscriptionFeature(
        title: 'حماية الرصيد',
        description: 'نظام حماية يمنعك من خسارة أكثر من حد معين يومياً',
        icon: Icons.shield_rounded,
      ),
      SubscriptionFeature(
        title: 'إحصائيات متقدمة',
        description: 'تقارير مفصلة عن أدائك ونصائح للتحسين',
        icon: Icons.insights_rounded,
      ),
    ],
  );

  static List<SubscriptionPlan> get allPlans => [
        matchPrediction,
        crashGame,
        cupsChallenge,
        appleGame,
      ];
}
