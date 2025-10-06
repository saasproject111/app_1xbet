import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'welcome_screen.dart';

class AppleScreen extends StatefulWidget {
  const AppleScreen({super.key});

  @override
  State<AppleScreen> createState() => _AppleScreenState();
}

class _AppleScreenState extends State<AppleScreen> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;
  bool _isLoading = true;
  Map<String, dynamic>? _userData;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _loadUserData();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    try {
      _user = _auth.currentUser;

      if (_user != null) {
        final doc = await _firestore.collection('users').doc(_user!.uid).get();

        if (doc.exists) {
          _userData = doc.data();
        }
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signOut() async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(
              color: const Color(0xFF334155).withOpacity(0.5),
              width: 1,
            ),
          ),
          title: const Text(
            'تسجيل الخروج',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.right,
          ),
          content: const Text(
            'هل أنت متأكد من تسجيل الخروج من حسابك؟',
            style: TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 16,
            ),
            textAlign: TextAlign.right,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'إلغاء',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444).withOpacity(0.15),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'تسجيل الخروج',
                style: TextStyle(
                  color: Color(0xFFEF4444),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (shouldSignOut == true) {
      try {
        await _googleSignIn.signOut();
        await _auth.signOut();

        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const WelcomeScreen()),
            (route) => false,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.white),
                  SizedBox(width: 12),
                  Text(
                    'تم تسجيل الخروج بنجاح',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'خطأ في تسجيل الخروج: $e',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFFEF4444),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      }
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
          Positioned(
            top: -100,
            right: -100,
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
          ),
          Positioned(
            bottom: -150,
            left: -150,
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
          ),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
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
                  title: const Text(
                    'الملف الشخصي',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  background: ClipRRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF1E293B).withOpacity(0.95),
                              const Color(0xFF0F172A).withOpacity(0.95),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _isLoading
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.all(80.0),
                          child: Column(
                            children: [
                              SizedBox(
                                width: 50,
                                height: 50,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF10B981),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'جاري التحميل...',
                                style: TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : _user == null
                        ? _buildNotLoggedIn()
                        : _buildProfileContent(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotLoggedIn() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 60),
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF1E293B).withOpacity(0.8),
                      const Color(0xFF0F172A).withOpacity(0.8),
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
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF334155).withOpacity(0.4),
                            const Color(0xFF1E293B).withOpacity(0.4),
                          ],
                        ),
                        border: Border.all(
                          color: const Color(0xFF475569).withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        size: 60,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'لم تقم بتسجيل الدخول',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'يرجى تسجيل الدخول للوصول إلى ملفك الشخصي\nوالاستفادة من جميع الميزات',
                      style: TextStyle(
                        color: const Color(0xFF94A3B8).withOpacity(0.9),
                        fontSize: 16,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent() {
    final name = _userData?['name'] ?? 'مستخدم';
    final email = _userData?['email'] ?? 'لا يوجد بريد إلكتروني';
    final photoUrl = _userData?['photoUrl'];
    final accountType = _userData?['accountType'] ?? 'free';
    final createdAt = _userData?['createdAt'];

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: accountType == 'premium'
                            ? [
                                const Color(0xFFEAB308).withOpacity(0.3),
                                const Color(0xFFEAB308).withOpacity(0.0),
                              ]
                            : [
                                const Color(0xFF10B981).withOpacity(0.3),
                                const Color(0xFF10B981).withOpacity(0.0),
                              ],
                      ),
                    ),
                  ),
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: accountType == 'premium'
                            ? const Color(0xFFEAB308)
                            : const Color(0xFF10B981),
                        width: 4,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: accountType == 'premium'
                              ? const Color(0xFFEAB308).withOpacity(0.4)
                              : const Color(0xFF10B981).withOpacity(0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: photoUrl != null && photoUrl.isNotEmpty
                          ? Image.network(
                              photoUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => _buildDefaultAvatar(accountType),
                            )
                          : _buildDefaultAvatar(accountType),
                    ),
                  ),
                  if (accountType == 'premium')
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAB308),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF0F172A),
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFEAB308).withOpacity(0.5),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.workspace_premium,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 25),
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B).withOpacity(0.6),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF334155).withOpacity(0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      color: Color(0xFF10B981),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      email,
                      style: const TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),
              _buildSubscriptionCard(accountType),
              const SizedBox(height: 25),
              _buildInfoCard(
                icon: Icons.verified_user_rounded,
                title: 'معرف المستخدم',
                value: '${_user!.uid.substring(0, 12)}...',
                color: const Color(0xFF3B82F6),
              ),
              const SizedBox(height: 15),
              if (createdAt != null)
                _buildInfoCard(
                  icon: Icons.calendar_today_rounded,
                  title: 'تاريخ الإنشاء',
                  value: _formatDate(createdAt),
                  color: const Color(0xFF10B981),
                ),
              const SizedBox(height: 15),
              _buildInfoCard(
                icon: Icons.shield_outlined,
                title: 'حالة الحساب',
                value: 'نشط ومؤمن',
                color: const Color(0xFF10B981),
              ),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                height: 65,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEF4444).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _signOut,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded, size: 26),
                      SizedBox(width: 12),
                      Text(
                        'تسجيل الخروج',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubscriptionCard(String accountType) {
    final isPremium = accountType == 'premium';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isPremium
              ? [
                  const Color(0xFFEAB308).withOpacity(0.25),
                  const Color(0xFFF59E0B).withOpacity(0.25),
                ]
              : [
                  const Color(0xFF1E293B).withOpacity(0.8),
                  const Color(0xFF0F172A).withOpacity(0.8),
                ],
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isPremium
              ? const Color(0xFFEAB308).withOpacity(0.6)
              : const Color(0xFF334155).withOpacity(0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isPremium
                ? const Color(0xFFEAB308).withOpacity(0.2)
                : Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: isPremium
                    ? [
                        const Color(0xFFEAB308).withOpacity(0.3),
                        const Color(0xFFEAB308).withOpacity(0.0),
                      ]
                    : [
                        const Color(0xFF334155).withOpacity(0.3),
                        const Color(0xFF334155).withOpacity(0.0),
                      ],
              ),
            ),
            child: Icon(
              isPremium ? Icons.workspace_premium : Icons.account_circle_outlined,
              color: isPremium ? const Color(0xFFEAB308) : const Color(0xFF94A3B8),
              size: 42,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            isPremium ? 'حساب بريميوم' : 'حساب عادي',
            style: TextStyle(
              color: isPremium ? const Color(0xFFEAB308) : Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            isPremium
                ? 'استمتع بجميع الميزات المتقدمة'
                : 'ترقية للوصول إلى الميزات المتقدمة',
            style: TextStyle(
              color: isPremium
                  ? const Color(0xFFEAB308).withOpacity(0.8)
                  : const Color(0xFF94A3B8),
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF1E293B).withOpacity(0.8),
            const Color(0xFF0F172A).withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF334155).withOpacity(0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(String accountType) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: accountType == 'premium'
              ? [
                  const Color(0xFFEAB308),
                  const Color(0xFFF59E0B),
                ]
              : [
                  const Color(0xFF3B82F6),
                  const Color(0xFF1E40AF),
                ],
        ),
      ),
      child: const Center(
        child: Icon(Icons.person_rounded, size: 75, color: Colors.white),
      ),
    );
  }

  String _formatDate(dynamic timestamp) {
    try {
      if (timestamp == null) return 'غير متاح';

      DateTime date;
      if (timestamp is Timestamp) {
        date = timestamp.toDate();
      } else if (timestamp is String) {
        date = DateTime.parse(timestamp);
      } else {
        return 'غير متاح';
      }

      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'غير متاح';
    }
  }
}
