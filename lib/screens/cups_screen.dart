import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;

class CupsScreen extends StatefulWidget {
  const CupsScreen({super.key});

  @override
  State<CupsScreen> createState() => _CupsScreenState();
}

class _CupsScreenState extends State<CupsScreen> with TickerProviderStateMixin {
  PredictionMode _predictionMode = PredictionMode.oneBall;
  PredictionState _predictionState = PredictionState.idle;

  List<int> _predictedPositions = [];
  double _progress = 0.0;

  late AnimationController _loadingController;
  late AnimationController _glowController;
  late AnimationController _revealController;

  @override
  void initState() {
    super.initState();

    _loadingController = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..addListener(() {
        setState(() {
          _progress = _loadingController.value;
        });
      });

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _revealController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _glowController.dispose();
    _revealController.dispose();
    super.dispose();
  }

  void _startPrediction() async {
    setState(() {
      _predictionState = PredictionState.loading;
      _predictedPositions = [];
      _progress = 0.0;
    });

    await _loadingController.forward(from: 0);

    _generatePrediction();

    setState(() {
      _predictionState = PredictionState.result;
    });

    _revealController.forward(from: 0);
  }

  void _generatePrediction() {
    final random = math.Random();

    if (_predictionMode == PredictionMode.oneBall) {
      _predictedPositions = [random.nextInt(3)];
    } else {
      final first = random.nextInt(3);
      int second;
      do {
        second = random.nextInt(3);
      } while (second == first);
      _predictedPositions = [first, second];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0A1628),
                  Color(0xFF111827),
                  Color(0xFF0F172A),
                ],
              ),
            ),
          ),

          Positioned.fill(
            child: CustomPaint(
              painter: BackgroundPatternPainter(),
            ),
          ),

          CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 120.0,
                floating: true,
                pinned: true,
                elevation: 0,
                backgroundColor: const Color(0xFF1E293B).withOpacity(0.95),
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  titlePadding: const EdgeInsets.only(bottom: 20),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        '',
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'توقع مكان الكرة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  background: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(15),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                      child: Container(
                        color: const Color(0xFF1E293B).withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),

                      _buildInstructionCard(),

                      const SizedBox(height: 25),

                      _buildPredictionModeSelector(),

                      const SizedBox(height: 30),

                      _buildCupsArea(),

                      const SizedBox(height: 30),

                      if (_predictionState == PredictionState.loading)
                        _buildLoadingBar(),

                      const SizedBox(height: 20),

                      _buildPredictButton(),

                      const SizedBox(height: 20),

                      if (_predictionState == PredictionState.result)
                        _buildResultCard(),

                      const SizedBox(height: 30),

                      _buildStatsSection(),

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

  Widget _buildInstructionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E3A8A).withOpacity(0.3),
            const Color(0xFF1E293B).withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF3B82F6).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.info_outline,
              color: Color(0xFF60A5FA),
              size: 28,
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Text(
              'خمن مكان الكرة!\nاختر الوضع واضغط على زر التوقع للحصول على النتيجة',
              style: TextStyle(
                color: Color(0xFFE0E7FF),
                fontSize: 14,
                height: 1.5,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPredictionModeSelector() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.6),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: const Color(0xFF334155),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildModeButton(
              title: 'كرة واحدة',
              subtitle: 'كوبين فارغين',
              icon: '⚽',
              mode: PredictionMode.oneBall,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _buildModeButton(
              title: 'كرتين',
              subtitle: 'كوب واحد فارغ',
              icon: '⚽⚽',
              mode: PredictionMode.twoBalls,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeButton({
    required String title,
    required String subtitle,
    required String icon,
    required PredictionMode mode,
  }) {
    final isSelected = _predictionMode == mode;
    final isEnabled = _predictionState != PredictionState.loading;

    return GestureDetector(
      onTap: isEnabled
          ? () => setState(() => _predictionMode = mode)
          : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFEAB308), Color(0xFFF59E0B)],
                )
              : null,
          color: isSelected ? null : const Color(0xFF0F172A).withOpacity(0.5),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFFEAB308).withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF94A3B8),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: isSelected ? Colors.white70 : const Color(0xFF64748B),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCupsArea() {
    return Container(
      height: 380,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.2,
          colors: [
            const Color(0xFF1E293B).withOpacity(0.6),
            const Color(0xFF0F172A).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF334155).withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A).withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF3B82F6).withOpacity(0.3),
              ),
            ),
            child: const Text(
              'Guess where the ball is!',
              style: TextStyle(
                color: Color(0xFF93C5FD),
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),

          const Spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(3, (index) {
              return _buildCupWithBall(index);
            }),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildCupWithBall(int index) {
    final hasBall = _predictedPositions.contains(index);
    final showBall = _predictionState == PredictionState.result && hasBall;

    return AnimatedBuilder(
      animation: _glowController,
      builder: (context, child) {
        return SizedBox(
          width: 95,
          height: 220,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              if (showBall)
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 100,
                    height: 15,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFEAB308).withOpacity(
                            0.3 + (_glowController.value * 0.4),
                          ),
                          blurRadius: 25 + (_glowController.value * 20),
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ),

              AnimatedPositioned(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                bottom: showBall ? 15 : -50,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 400),
                  opacity: showBall ? 1.0 : 0.0,
                  child: _buildBall(),
                ),
              ),

              Positioned(
                bottom: 0,
                child: _buildRealisticCup(hasBall && _predictionState == PredictionState.result),
              ),

              Positioned(
                top: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF475569),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRealisticCup(bool isHighlighted) {
    return AnimatedBuilder(
      animation: _revealController,
      builder: (context, child) {
        return Container(
          width: 85,
          height: 130,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
            boxShadow: [
              BoxShadow(
                color: isHighlighted
                    ? const Color(0xFFEAB308).withOpacity(0.5)
                    : Colors.black.withOpacity(0.4),
                blurRadius: isHighlighted ? 20 : 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withOpacity(0.25),
                      Colors.white.withOpacity(0.12),
                      Colors.white.withOpacity(0.18),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  border: Border.all(
                    color: isHighlighted
                        ? const Color(0xFFEAB308).withOpacity(0.7)
                        : Colors.white.withOpacity(0.25),
                    width: isHighlighted ? 2.5 : 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.15),
                            Colors.white.withOpacity(0.08),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              CustomPaint(
                size: const Size(85, 130),
                painter: ThimblePatternPainter(),
              ),

              Positioned(
                left: 8,
                top: 15,
                child: Container(
                  width: 20,
                  height: 70,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.white.withOpacity(0.4),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBall() {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const RadialGradient(
          center: Alignment(-0.3, -0.3),
          colors: [
            Color(0xFFFF5555),
            Color(0xFFFF0000),
            Color(0xFFCC0000),
          ],
          stops: [0.0, 0.6, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF0000).withOpacity(0.6),
            blurRadius: 15,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            center: const Alignment(-0.4, -0.4),
            radius: 0.5,
            colors: [
              Colors.white.withOpacity(0.9),
              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingBar() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: const Color(0xFF334155),
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(23),
                child: LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFEAB308),
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Center(
                child: Text(
                  'جارٍ التحليل... %${(_progress * 100).toInt()}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLoadingDot(0),
            _buildLoadingDot(1),
            _buildLoadingDot(2),
          ],
        ),
      ],
    );
  }

  Widget _buildLoadingDot(int index) {
    return AnimatedBuilder(
      animation: _loadingController,
      builder: (context, child) {
        final delay = index * 0.2;
        final value = (_loadingController.value - delay).clamp(0.0, 1.0);
        final scale = math.sin(value * math.pi);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          width: 10,
          height: 10,
          transform: Matrix4.identity()..scale(0.5 + (scale * 0.8)),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFEAB308),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFEAB308).withOpacity(0.5),
                blurRadius: 10,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPredictButton() {
    final isLoading = _predictionState == PredictionState.loading;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      height: 65,
      child: ElevatedButton(
        onPressed: isLoading ? null : _startPrediction,
        style: ElevatedButton.styleFrom(
          backgroundColor: isLoading
              ? const Color(0xFF334155)
              : const Color(0xFFEAB308),
          foregroundColor: Colors.white,
          elevation: isLoading ? 0 : 12,
          shadowColor: const Color(0xFFEAB308).withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          disabledBackgroundColor: const Color(0xFF334155),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isLoading ? Icons.hourglass_empty : Icons.search,
              size: 26,
            ),
            const SizedBox(width: 12),
            Text(
              isLoading ? 'جارٍ التوقع...' : 'توقع مكان الكرة',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    final positionsText = _predictedPositions.length == 1
        ? 'الكوب رقم ${_predictedPositions[0] + 1}'
        : 'الكوبين رقم ${_predictedPositions[0] + 1} و ${_predictedPositions[1] + 1}';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF059669), Color(0xFF10B981)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF10B981).withOpacity(0.4),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🎯',
                style: TextStyle(fontSize: 40),
              ),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'نتيجة التوقع',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    positionsText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'تحقق من اللعبة الآن للتأكد من التوقع',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            'الإحصائيات',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.check_circle_outline,
                title: 'التوقعات الصحيحة',
                value: '24',
                color: const Color(0xFF10B981),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: _buildStatCard(
                icon: Icons.query_stats,
                title: 'إجمالي التوقعات',
                value: '35',
                color: const Color(0xFF3B82F6),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        _buildStatCard(
          icon: Icons.trending_up,
          title: 'نسبة الدقة',
          value: '90.5%',
          color: const Color(0xFFEAB308),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.6),
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
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum PredictionMode {
  oneBall,
  twoBalls,
}

enum PredictionState {
  idle,
  loading,
  result,
}

class BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.02)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var i = 0; i < 10; i++) {
      final y = (size.height / 10) * i;
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class ThimblePatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (var i = 0; i < 8; i++) {
      final y = 20.0 + (i * 15.0);
      canvas.drawLine(
        Offset(10, y),
        Offset(size.width - 10, y),
        paint,
      );
    }

    paint.style = PaintingStyle.fill;
    paint.color = Colors.white.withOpacity(0.1);

    for (var row = 0; row < 3; row++) {
      for (var col = 0; col < 4; col++) {
        final x = 15.0 + (col * 18.0);
        final y = 40.0 + (row * 30.0);
        canvas.drawCircle(Offset(x, y), 3, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
