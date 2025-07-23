import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import '../networking/app_shared_preferences.dart';
import '../viewModels/UserViewModel.dart';
import '../utils/colors.dart';
import '../utils/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeApp();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    // Initialize shared preferences
    await AppSharedPreferences.init();
    
    // Wait for animation to complete
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // Check if it's first time
    final isFirstTime = AppSharedPreferences.isFirstTime();
    
    // Check if user is logged in
    final isLoggedIn = AppSharedPreferences.isLoggedIn();
    
    // Navigate to appropriate screen
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      if (isFirstTime) {
        Navigator.of(context).pushReplacementNamed('/onboarding');
      } else if (isLoggedIn) {
        // Load user data before navigating to dashboard
        context.read<UserViewModel>().loadUserData();
        Navigator.of(context).pushReplacementNamed('/dashboard');
      } else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColor.primaryGradient,
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor,
                          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                          boxShadow: [
                            BoxShadow(
                              color: AppColor.shadowColorDark.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'YB',
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: AppColor.primaryColor,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingLarge),
                      
                      // App Name
                      Text(
                        'YONO Business',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: AppColor.whiteColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingSmall),
                      
                      // Tagline
                      Text(
                        'Banking made simple for businesses',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColor.whiteColor.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingXLarge * 2),
                      
                      // Loading indicator
                      if (_fadeAnimation.value > 0.5)
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColor.whiteColor.withOpacity(0.8),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}