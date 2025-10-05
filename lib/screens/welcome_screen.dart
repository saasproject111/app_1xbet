import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../main.dart'; // LayoutScreen

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? _errorMessage;
  late AnimationController _fadeController;
  late AnimationController _pulseController;
  late AnimationController _floatController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
    _setupAnimations();
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeOutCubic,
      ),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  void _checkAuthState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_auth.currentUser != null) {
        _navigateToHome();
      }
    });
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LayoutScreen()),
    );
  }

  Future<void> _signInWithGoogle() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      _navigateToHome();
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = "فشل تسجيل الدخول: ${e.message}";
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = "حدث خطأ غير متوقع: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: Stack(
          children: [
            // Background decorative elements
            Positioned(
              top: -100,
              right: -100,
              child: AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      _floatController.value * 30,
                      _floatController.value * 30,
                    ),
                    child: Container(
                      width: 300,
                      height: 300,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF10B981).withOpacity(0.15),
                            const Color(0xFF10B981).withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: -150,
              left: -150,
              child: AnimatedBuilder(
                animation: _floatController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                      -_floatController.value * 20,
                      -_floatController.value * 20,
                    ),
                    child: Container(
                      width: 400,
                      height: 400,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            const Color(0xFF3B82F6).withOpacity(0.1),
                            const Color(0xFF3B82F6).withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Main Content
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          SizedBox(height: size.height * 0.08),

                          // Logo with animated glow
                          AnimatedBuilder(
                            animation: _pulseController,
                            builder: (context, child) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 140 + (_pulseController.value * 20),
                                    height: 140 + (_pulseController.value * 20),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          const Color(0xFF10B981).withOpacity(
                                            0.3 * (1 - _pulseController.value),
                                          ),
                                          const Color(0xFF10B981).withOpacity(0),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 130,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          const Color(0xFF1E293B).withOpacity(0.9),
                                          const Color(0xFF0F172A).withOpacity(0.9),
                                        ],
                                      ),
                                      border: Border.all(
                                        color: const Color(0xFF334155).withOpacity(0.6),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.4),
                                          blurRadius: 30,
                                          offset: const Offset(0, 15),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.security_rounded,
                                      size: 65,
                                      color: Color(0xFF10B981),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 50),

                          // Welcome Text
                          const Text(
                            "مرحباً بك",
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.5,
                              shadows: [
                                Shadow(
                                  color: Color(0xFF10B981),
                                  offset: Offset(0, 0),
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          Text(
                            "سجل دخولك للوصول إلى جميع الخدمات",
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color(0xFFCBD5E1).withOpacity(0.9),
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          SizedBox(height: size.height * 0.08),

                          // Card Container
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(30),
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
                              children: [
                                const Text(
                                  "تسجيل الدخول",
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),

                                const SizedBox(height: 10),

                                Text(
                                  "استخدم حسابك في Google للمتابعة",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: const Color(0xFFCBD5E1).withOpacity(0.8),
                                  ),
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(height: 35),

                                // Error Message
                                if (_errorMessage != null) ...[
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFFEF4444).withOpacity(0.15),
                                          const Color(0xFFDC2626).withOpacity(0.15),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: const Color(0xFFEF4444).withOpacity(0.4),
                                        width: 1,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.error_outline_rounded,
                                          color: Color(0xFFEF4444),
                                          size: 22,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                            _errorMessage!,
                                            style: const TextStyle(
                                              color: Color(0xFFEF4444),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 28),
                                ],

                                // Google Sign In Button
                                InkWell(
                                  onTap: _isLoading ? null : _signInWithGoogle,
                                  borderRadius: BorderRadius.circular(18),
                                  child: Container(
                                    width: double.infinity,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      gradient: _isLoading
                                          ? null
                                          : const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(0xFF10B981),
                                                Color(0xFF059669),
                                              ],
                                            ),
                                      color: _isLoading
                                          ? const Color(0xFF334155)
                                          : null,
                                      borderRadius: BorderRadius.circular(18),
                                      boxShadow: _isLoading
                                          ? []
                                          : [
                                              BoxShadow(
                                                color: const Color(0xFF10B981)
                                                    .withOpacity(0.4),
                                                blurRadius: 20,
                                                offset: const Offset(0, 10),
                                              ),
                                            ],
                                    ),
                                    child: _isLoading
                                        ? const Center(
                                            child: SizedBox(
                                              height: 26,
                                              width: 26,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 3,
                                                valueColor:
                                                    AlwaysStoppedAnimation<Color>(
                                                  Color(0xFF10B981),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: 28,
                                                height: 28,
                                                padding: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                child: Image.network(
                                                  'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                                                  width: 20,
                                                  height: 20,
                                                ),
                                              ),
                                              const SizedBox(width: 14),
                                              const Text(
                                                "تسجيل الدخول بواسطة Google",
                                                style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 45),

                          // Security Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFF1E293B).withOpacity(0.6),
                                  const Color(0xFF0F172A).withOpacity(0.6),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF334155).withOpacity(0.4),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.verified_user_rounded,
                                  color: Color(0xFF10B981),
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "تسجيل دخول آمن ومشفر بالكامل",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: const Color(0xFFCBD5E1).withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          // Footer Text
                          Text(
                            "بالمتابعة، أنت توافق على شروط الخدمة وسياسة الخصوصية",
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xFFCBD5E1).withOpacity(0.6),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
