import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:theme_provider/theme_provider.dart';

// ViewModels
import 'viewModels/UserViewModel.dart';
import 'viewModels/ProfileViewModel.dart';
import 'viewModels/DashboardViewModel.dart';
import 'viewModels/AccountViewModel.dart';
import 'viewModels/PaymentViewModel.dart';
import 'viewModels/TransactionViewModel.dart';
import 'viewModels/NotificationViewModel.dart';
import 'viewModels/PreferenceViewModel.dart';
import 'viewModels/AuthViewModel.dart';
import 'viewModels/OnboardingViewModel.dart';

// Providers
import 'providers/theme_provider.dart' as app_theme_provider;
import 'providers/connectivity_provider.dart';
import 'providers/language_provider.dart';

// UI Screens
import 'ui/onboard/onboard_screen.dart';
import 'ui/auth/login_screen.dart';
import 'ui/auth/forgot_password_screen.dart';
import 'ui/auth/otp_verification_screen.dart';
import 'ui/auth/reset_password_screen.dart';
import 'ui/auth/password_success_screen.dart';
import 'ui/dashboard/dashboard_screen.dart';
import 'ui/bottom_navigation.dart';
import 'ui/accounts/accounts_screen.dart';
import 'ui/payments/payments_screen.dart';
import 'ui/transactions/transactions_screen.dart';
import 'ui/profile/profile_screen.dart';
import 'ui/splash_screen.dart';

// Services & Utils
import 'services/notification_service.dart';
import 'networking/app_shared_preferences.dart';
import 'utils/navigation_service.dart';
import 'utils/app_theme.dart' as custom_theme;
import 'utils/colors.dart';
import 'l10n/app_localizations.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp();
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  runApp(const YONOBusinessApp());
}

class YONOBusinessApp extends StatelessWidget {
  const YONOBusinessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Theme Provider
        ChangeNotifierProvider(create: (_) => app_theme_provider.ThemeProvider()),
        
        // Core Providers
        ChangeNotifierProvider(create: (_) => UserViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => PreferenceViewModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => OnboardingViewModel()),
        
        // Feature Providers
        ChangeNotifierProvider(create: (_) => DashboardViewModel()),
        ChangeNotifierProvider(create: (_) => AccountViewModel()),
        ChangeNotifierProvider(create: (_) => PaymentViewModel()),
        ChangeNotifierProvider(create: (_) => TransactionViewModel()),
        ChangeNotifierProvider(create: (_) => NotificationViewModel()),
        
        // Utility Providers
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
      ],
      child: ThemeProvider(
        defaultThemeId: "yono_business_theme",
        themes: [
          AppTheme(
            id: "yono_business_theme",
            description: "YONO Business Theme",
            data: custom_theme.AppTheme.lightTheme,
          ),
          AppTheme(
            id: "yono_business_dark_theme",
            description: "YONO Business Dark Theme",
            data: custom_theme.AppTheme.darkTheme,
          ),
        ],
        child: Consumer<PreferenceViewModel>(
          builder: (context, model, _) {
            return ThemeConsumer(
              child: Builder(
                builder: (themeContext) => MaterialApp(
                  navigatorKey: NavigationService.navigatorKey,
                  title: 'YONO Business',
                  locale: Locale(model.langCode?.toLowerCase().trim() ?? "en"),
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                    CountryLocalizations.delegate,
                  ],
                  supportedLocales: const [
                    Locale('en'),
                    Locale('hi'),
                    Locale('ta'),
                    Locale('te'),
                    Locale('kn'),
                    Locale('ml'),
                  ],
                  initialRoute: "/",
                  routes: {
                    '/': (context) => const SplashScreen(),
                    '/onboarding': (context) => const OnboardScreen(),
                    '/login': (context) => const LoginScreen(),
                    '/forgotPassword': (context) => const ForgotPasswordScreen(),
                    '/otpVerification': (context) => const OTPVerificationScreen(),
                    '/resetPassword': (context) => const ResetPasswordScreen(),
                    '/passwordSuccess': (context) => const PasswordSuccessScreen(),
                    '/dashboard': (context) => const BottomNavigation(),
                    '/accounts': (context) => const AccountsScreen(),
                    '/payments': (context) => const PaymentsScreen(),
                    '/transactions': (context) => const TransactionsScreen(),
                    '/profile': (context) => const ProfileScreen(),
                  },
                  debugShowCheckedModeBanner: false,
                  theme: ThemeProvider.themeOf(themeContext).data,
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        textScaler: const TextScaler.linear(1.0),
                      ),
                      child: child!,
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}