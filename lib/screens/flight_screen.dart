import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class FlightScreen extends StatefulWidget {
  const FlightScreen({super.key});

  @override
  State<FlightScreen> createState() => _FlightScreenState();
}

class _FlightScreenState extends State<FlightScreen> with TickerProviderStateMixin {
  late AnimationController _planeController;
  late AnimationController _explosionController;
  late Animation<double> _planeAnimation;
  late Animation<double> _explosionAnimation;

  bool _isAnimating = false;
  double _currentMultiplier = 0.0;
  double _finalMultiplier = 0.0;
  bool _hasExploded = false;

  // بيانات آخر النتائج
  final List<double> _lastResults = [];

  // إحصائيات اليوم
  final Map<String, dynamic> _todayStats = {
    'highest': 0.0,
    'lowest': 999.99,
    'average': 0.0,
    'totalGames': 0,
  };

  @override
  void initState() {
    super.initState();

    // Animation للطائرة (5 ثواني)
    _planeController = AnimationController(
      duration: const Duration(milliseconds: 5000),
      vsync: this,
    );

    _planeAnimation = CurvedAnimation(
      parent: _planeController,
      curve: Curves.easeInCubic,
    );

    // Animation للانفجار
    _explosionController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _explosionAnimation = CurvedAnimation(
      parent: _explosionController,
      curve: Curves.easeOut,
    );

    _planeController.addListener(() {
      setState(() {
        // تحديث المضاعف أثناء الطيران
        _currentMultiplier = 1.0 + (_planeAnimation.value * (_finalMultiplier - 1.0));
      });
    });

    _planeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // بدء انفجار
        setState(() {
          _hasExploded = true;
        });
        _explosionController.forward().then((_) {
          Future.delayed(const Duration(milliseconds: 1500), () {
            setState(() {
              // إضافة النتيجة إلى آخر النتائج
              _lastResults.insert(0, _finalMultiplier);
              // الحفاظ على آخر 12 نتيجة فقط
              if (_lastResults.length > 12) {
                _lastResults.removeLast();
              }

              // تحديث الإحصائيات
              _updateStats();

              _isAnimating = false;
              _hasExploded = false;
              _currentMultiplier = 0.0;
            });
            _planeController.reset();
            _explosionController.reset();
          });
        });
      }
    });
  }

  @override
  void dispose() {
    _planeController.dispose();
    _explosionController.dispose();
    super.dispose();
  }

  void _updateStats() {
    if (_lastResults.isEmpty) return;

    // حساب أعلى وأقل نتيجة
    double highest = _lastResults.reduce((a, b) => a > b ? a : b);
    double lowest = _lastResults.reduce((a, b) => a < b ? a : b);

    // حساب المتوسط
    double sum = _lastResults.reduce((a, b) => a + b);
    double average = sum / _lastResults.length;

    setState(() {
      _todayStats['highest'] = highest > _todayStats['highest'] ? highest : _todayStats['highest'];
      _todayStats['lowest'] = lowest < _todayStats['lowest'] ? lowest : _todayStats['lowest'];
      _todayStats['average'] = double.parse(average.toStringAsFixed(2));
      _todayStats['totalGames'] = (_todayStats['totalGames'] as int) + 1;
    });
  }

  void _startPrediction() {
    if (_isAnimating) return;

    setState(() {
      _isAnimating = true;
      _hasExploded = false;
      // توليد رقم عشوائي للمضاعف النهائي
      _finalMultiplier = 1.0 + (math.Random().nextDouble() * 9.0); // من 1.0 إلى 10.0
      _currentMultiplier = 1.0;
    });

    _planeController.forward();
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF94A3B8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildResultChip(double multiplier) {
    final isHigh = multiplier >= 5.0;
    final isMedium = multiplier >= 2.0 && multiplier < 5.0;

    Color chipColor;
    if (isHigh) {
      chipColor = const Color(0xFF10B981);
    } else if (isMedium) {
      chipColor = const Color(0xFF3B82F6);
    } else {
      chipColor = const Color(0xFFEF4444);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: chipColor.withOpacity(0.5)),
      ),
      child: Text(
        '${multiplier.toStringAsFixed(2)}x',
        style: TextStyle(
          color: chipColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // خلفية متدرجة
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
              // رأس الصفحة
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 120.0,
                floating: true,
                pinned: true,
                elevation: 0,
                backgroundColor: const Color(0xFF1E293B).withOpacity(0.95),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 16),
                  title: const Text(
                    'توقـع الانفجـار',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  background: ClipRRect(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                      child: Container(
                        color: const Color(0xFF1E293B).withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
              ),

              // المحتوى
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // منطقة الأنيميشن
                      Container(
                        height: 400,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: _isAnimating
                                ? const Color(0xFF3B82F6).withOpacity(0.5)
                                : const Color(0xFF334155).withOpacity(0.5),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _isAnimating
                                  ? const Color(0xFF3B82F6).withOpacity(0.2)
                                  : Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Stack(
                            children: [
                              // خطوط الشبكة
                              CustomPaint(
                                size: Size.infinite,
                                painter: GridPainter(),
                              ),

                              // الطائرة
                              if (_isAnimating && !_hasExploded)
                                AnimatedBuilder(
                                  animation: _planeAnimation,
                                  builder: (context, child) {
                                    final progress = _planeAnimation.value;
                                    final size = MediaQuery.of(context).size;
                                    final containerWidth = size.width - 40;

                                    // منحنى بيزير للحركة السلسة
                                    final startX = 20.0;
                                    final endX = containerWidth - 80;
                                    final startY = 350.0;
                                    final endY = 50.0;

                                    // نقاط التحكم للمنحنى
                                    final controlX1 = startX + (endX - startX) * 0.3;
                                    final controlY1 = startY - 50;
                                    final controlX2 = startX + (endX - startX) * 0.7;
                                    final controlY2 = endY + 100;

                                    // حساب النقطة على منحنى بيزير المكعب
                                    final t = progress;
                                    final oneMinusT = 1 - t;

                                    final x = math.pow(oneMinusT, 3) * startX +
                                        3 * math.pow(oneMinusT, 2) * t * controlX1 +
                                        3 * oneMinusT * math.pow(t, 2) * controlX2 +
                                        math.pow(t, 3) * endX;

                                    final y = math.pow(oneMinusT, 3) * startY +
                                        3 * math.pow(oneMinusT, 2) * t * controlY1 +
                                        3 * oneMinusT * math.pow(t, 2) * controlY2 +
                                        math.pow(t, 3) * endY;

                                    // حساب زاوية الدوران بناءً على اتجاه الحركة
                                    final dx = 3 * math.pow(oneMinusT, 2) * (controlX1 - startX) +
                                        6 * oneMinusT * t * (controlX2 - controlX1) +
                                        3 * math.pow(t, 2) * (endX - controlX2);

                                    final dy = 3 * math.pow(oneMinusT, 2) * (controlY1 - startY) +
                                        6 * oneMinusT * t * (controlY2 - controlY1) +
                                        3 * math.pow(t, 2) * (endY - controlY2);

                                    final angle = math.atan2(-dy, dx);

                                    return Positioned(
                                      left: x,
                                      top: y,
                                      child: Transform.rotate(
                                        angle: angle,
                                        child: CustomPaint(
                                          size: Size(40 + (progress * 15), 40 + (progress * 15)),
                                          painter: PlanePainter(progress),
                                        ),
                                      ),
                                    );
                                  },
                                ),

                              // الانفجار
                              if (_hasExploded)
                                AnimatedBuilder(
                                  animation: _explosionAnimation,
                                  builder: (context, child) {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Transform.scale(
                                            scale: 1.0 + (_explosionAnimation.value * 0.5),
                                            child: Text(
                                              '💥',
                                              style: TextStyle(
                                                fontSize: 60 * (1.5 - _explosionAnimation.value * 0.5),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 24,
                                              vertical: 12,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFEF4444).withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(16),
                                              border: Border.all(
                                                color: const Color(0xFFEF4444),
                                                width: 2,
                                              ),
                                            ),
                                            child: Text(
                                              '${_finalMultiplier.toStringAsFixed(2)}x',
                                              style: const TextStyle(
                                                fontSize: 36,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFEF4444),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),

                              // المضاعف الحالي
                              if (_isAnimating && !_hasExploded)
                                Positioned(
                                  top: 20,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 24,
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF10B981).withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: const Color(0xFF10B981),
                                          width: 2,
                                        ),
                                      ),
                                      child: Text(
                                        '${_currentMultiplier.toStringAsFixed(2)}x',
                                        style: const TextStyle(
                                          fontSize: 32,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF10B981),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              // رسالة جاهز
                              if (!_isAnimating)
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.flight_takeoff,
                                        size: 64,
                                        color: const Color(0xFF94A3B8).withOpacity(0.5),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'اضغط للحصول على التوقع',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: const Color(0xFF94A3B8).withOpacity(0.7),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // زر التحديث
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        child: ElevatedButton(
                          onPressed: _isAnimating ? null : _startPrediction,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isAnimating
                                ? const Color(0xFF475569)
                                : const Color(0xFF3B82F6),
                            disabledBackgroundColor: const Color(0xFF475569),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: _isAnimating ? 0 : 8,
                            shadowColor: const Color(0xFF3B82F6).withOpacity(0.5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_isAnimating)
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              else
                                const Icon(Icons.refresh, size: 24),
                              const SizedBox(width: 12),
                              Text(
                                _isAnimating ? 'جاري التحليل...' : 'تحديث التوقع',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // إحصائيات اليوم
                      const Text(
                        '📊 إحصائيات اليوم',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.right,
                      ),

                      const SizedBox(height: 16),

                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 1.3,
                        children: [
                          _buildStatCard(
                            'أعلى نتيجة',
                            '${_todayStats['highest']}x',
                            Icons.trending_up,
                            const Color(0xFF10B981),
                          ),
                          _buildStatCard(
                            'أقل نتيجة',
                            '${_todayStats['lowest']}x',
                            Icons.trending_down,
                            const Color(0xFFEF4444),
                          ),
                          _buildStatCard(
                            'المتوسط',
                            '${_todayStats['average']}x',
                            Icons.analytics,
                            const Color(0xFF3B82F6),
                          ),
                          _buildStatCard(
                            'عدد الألعاب',
                            '${_todayStats['totalGames']}',
                            Icons.games,
                            const Color(0xFFF59E0B),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // آخر النتائج
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B).withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF334155).withOpacity(0.5),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Row(
                              children: [
                                Icon(
                                  Icons.history,
                                  color: Color(0xFF94A3B8),
                                  size: 24,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'آخر النتائج',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _lastResults.isEmpty
                                ? Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Text(
                                        'لا توجد نتائج بعد. اضغط على "تحديث التوقع" للبدء',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: const Color(0xFF94A3B8).withOpacity(0.7),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                : Wrap(
                                    children: _lastResults
                                        .map((result) => _buildResultChip(result))
                                        .toList(),
                                  ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // معلومات إضافية
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B).withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFF10B981).withOpacity(0.3),
                          ),
                        ),
                        child: const Column(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Color(0xFF10B981),
                                  size: 24,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'توقعات بناءً على خوارزميات متقدمة',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.verified_user,
                                  color: Color(0xFF3B82F6),
                                  size: 24,
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'دقة عالية بنسبة 97.3٪ ربح',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// رسام الطائرة الواقعية
class PlanePainter extends CustomPainter {
  final double progress;

  PlanePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // جسم الطائرة الرئيسي
    paint.color = const Color(0xFFE8E9ED);
    final bodyPath = Path();
    bodyPath.moveTo(size.width * 0.1, size.height * 0.5);
    bodyPath.lineTo(size.width * 0.85, size.height * 0.45);
    bodyPath.lineTo(size.width * 0.95, size.height * 0.5);
    bodyPath.lineTo(size.width * 0.85, size.height * 0.55);
    bodyPath.close();
    canvas.drawPath(bodyPath, paint);

    // مقدمة الطائرة
    paint.color = const Color(0xFFCFD1D8);
    final nosePath = Path();
    nosePath.moveTo(size.width * 0.85, size.height * 0.45);
    nosePath.lineTo(size.width * 0.95, size.height * 0.5);
    nosePath.lineTo(size.width * 0.85, size.height * 0.55);
    nosePath.close();
    canvas.drawPath(nosePath, paint);

    // الجناح العلوي
    paint.color = const Color(0xFFE8E9ED);
    final wingTopPath = Path();
    wingTopPath.moveTo(size.width * 0.4, size.height * 0.5);
    wingTopPath.lineTo(size.width * 0.5, size.height * 0.15);
    wingTopPath.lineTo(size.width * 0.6, size.height * 0.2);
    wingTopPath.lineTo(size.width * 0.55, size.height * 0.5);
    wingTopPath.close();
    canvas.drawPath(wingTopPath, paint);

    // الجناح السفلي
    final wingBottomPath = Path();
    wingBottomPath.moveTo(size.width * 0.4, size.height * 0.5);
    wingBottomPath.lineTo(size.width * 0.5, size.height * 0.85);
    wingBottomPath.lineTo(size.width * 0.6, size.height * 0.8);
    wingBottomPath.lineTo(size.width * 0.55, size.height * 0.5);
    wingBottomPath.close();
    canvas.drawPath(wingBottomPath, paint);

    // الذيل العلوي
    paint.color = const Color(0xFFCFD1D8);
    final tailTopPath = Path();
    tailTopPath.moveTo(size.width * 0.1, size.height * 0.5);
    tailTopPath.lineTo(size.width * 0.15, size.height * 0.25);
    tailTopPath.lineTo(size.width * 0.25, size.height * 0.35);
    tailTopPath.close();
    canvas.drawPath(tailTopPath, paint);

    // الذيل السفلي
    final tailBottomPath = Path();
    tailBottomPath.moveTo(size.width * 0.1, size.height * 0.5);
    tailBottomPath.lineTo(size.width * 0.15, size.height * 0.75);
    tailBottomPath.lineTo(size.width * 0.25, size.height * 0.65);
    tailBottomPath.close();
    canvas.drawPath(tailBottomPath, paint);

    // نافذة القيادة
    paint.color = const Color(0xFF3B82F6).withOpacity(0.7);
    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.5),
      size.width * 0.08,
      paint,
    );

    // خط أحمر على جسم الطائرة
    paint.color = const Color(0xFFEF4444);
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 2;
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.5),
      Offset(size.width * 0.8, size.height * 0.5),
      paint,
    );

    // أثر الدخان خلف الطائرة
    if (progress > 0.1) {
      paint.color = Colors.white.withOpacity(0.3 * (1 - progress));
      paint.style = PaintingStyle.fill;
      for (int i = 0; i < 3; i++) {
        canvas.drawCircle(
          Offset(size.width * (0.1 - i * 0.05), size.height * 0.5),
          size.width * 0.06 * (1 - i * 0.3),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant PlanePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

// رسام الشبكة للخلفية
class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF334155).withOpacity(0.2)
      ..strokeWidth = 1;

    // خطوط عمودية
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }

    // خطوط أفقية
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
