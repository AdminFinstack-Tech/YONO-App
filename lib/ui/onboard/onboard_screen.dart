import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModels/OnboardingViewModel.dart';
import '../../viewModels/PreferenceViewModel.dart';
import '../../utils/colors.dart';
import '../../utils/app_theme.dart';
import '../../l10n/app_localizations.dart';

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color backgroundColor;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.backgroundColor,
  });
}

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Welcome to YONO Business',
      description: 'Manage your business banking with ease. Access all your financial tools in one secure platform.',
      icon: Icons.business_center_outlined,
      backgroundColor: AppColor.primaryColor,
    ),
    OnboardingPage(
      title: 'Secure & Fast Transactions',
      description: 'Make payments, transfer funds, and manage transactions with enterprise-grade security.',
      icon: Icons.security_outlined,
      backgroundColor: AppColor.secondaryColor,
    ),
    OnboardingPage(
      title: 'Real-time Analytics',
      description: 'Track your business performance with detailed analytics and financial insights.',
      icon: Icons.analytics_outlined,
      backgroundColor: AppColor.secondaryColor,
    ),
    OnboardingPage(
      title: 'Multi-level Authorization',
      description: 'Set up approval workflows and manage team access with granular permissions.',
      icon: Icons.supervised_user_circle_outlined,
      backgroundColor: AppColor.successColor,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
    
    // Restart animation for new page
    _animationController.reset();
    _animationController.forward();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  void _completeOnboarding() {
    // Mark onboarding as completed
    context.read<OnboardingViewModel>().completeOnboarding();
    context.read<PreferenceViewModel>().setFirstTimeComplete();
    
    // Navigate to login
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _pages[_currentPage].backgroundColor,
              _pages[_currentPage].backgroundColor.withOpacity(0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacingLarge),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: AppColor.whiteColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              
              // Page view
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    
                    return AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: Padding(
                            padding: const EdgeInsets.all(AppTheme.spacingLarge),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Icon
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: AppColor.whiteColor.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColor.whiteColor.withOpacity(0.3),
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    page.icon,
                                    size: 60,
                                    color: AppColor.whiteColor,
                                  ),
                                ),
                                const SizedBox(height: AppTheme.spacingXLarge * 2),
                                
                                // Title
                                Text(
                                  page.title,
                                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                    color: AppColor.whiteColor,
                                    fontWeight: FontWeight.w800,
                                    height: 1.2,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: AppTheme.spacingLarge),
                                
                                // Description
                                Text(
                                  page.description,
                                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppColor.whiteColor.withOpacity(0.9),
                                    height: 1.6,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: AppTheme.spacingXLarge * 2),
                                
                                // Feature highlights (show only for specific pages)
                                if (index == 1) _buildSecurityFeatures(),
                                if (index == 2) _buildAnalyticsFeatures(),
                                if (index == 3) _buildAuthorizationFeatures(),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              
              // Bottom section
              Padding(
                padding: const EdgeInsets.all(AppTheme.spacingLarge),
                child: Column(
                  children: [
                    // Page indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? AppColor.whiteColor
                                : AppColor.whiteColor.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXLarge),
                    
                    // Navigation buttons
                    Row(
                      children: [
                        // Previous button
                        if (_currentPage > 0)
                          Expanded(
                            flex: 1,
                            child: OutlinedButton(
                              onPressed: _previousPage,
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: AppColor.whiteColor.withOpacity(0.8)),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                                ),
                              ),
                              child: Text(
                                'Previous',
                                style: TextStyle(
                                  color: AppColor.whiteColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        
                        if (_currentPage > 0) const SizedBox(width: AppTheme.spacingMedium),
                        
                        // Next/Get Started button
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColor.whiteColor,
                              foregroundColor: _pages[_currentPage].backgroundColor,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 8,
                              shadowColor: AppColor.shadowColorDark.withOpacity(0.3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                              ),
                            ),
                            child: Text(
                              _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildSecurityFeatures() {
    return Column(
      children: [
        _buildFeatureItem(Icons.shield_outlined, 'Multi-factor Authentication'),
        _buildFeatureItem(Icons.fingerprint_outlined, 'Biometric Login'),
        _buildFeatureItem(Icons.lock_outlined, 'End-to-end Encryption'),
      ],
    );
  }

  Widget _buildAnalyticsFeatures() {
    return Column(
      children: [
        _buildFeatureItem(Icons.trending_up_outlined, 'Revenue Tracking'),
        _buildFeatureItem(Icons.pie_chart_outline, 'Expense Analysis'),
        _buildFeatureItem(Icons.timeline_outlined, 'Cash Flow Insights'),
      ],
    );
  }

  Widget _buildAuthorizationFeatures() {
    return Column(
      children: [
        _buildFeatureItem(Icons.group_outlined, 'Team Management'),
        _buildFeatureItem(Icons.approval_outlined, 'Approval Workflows'),
        _buildFeatureItem(Icons.admin_panel_settings_outlined, 'Role-based Access'),
      ],
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: AppColor.whiteColor.withOpacity(0.8),
            size: 20,
          ),
          const SizedBox(width: AppTheme.spacingSmall),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColor.whiteColor.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}