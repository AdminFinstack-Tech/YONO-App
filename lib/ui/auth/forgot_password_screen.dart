import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModels/AuthViewModel.dart';
import '../../utils/colors.dart';
import '../../utils/app_theme.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/loading_overlay.dart';
import '../../l10n/app_localizations.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  int _selectedOption = 0; // 0 for email, 1 for username

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void _toggleOption(int value) {
    setState(() {
      _selectedOption = value;
    });
  }

  Future<void> _handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final authViewModel = context.read<AuthViewModel>();
    
    final requestId = await authViewModel.forgotPassword(
      username: _usernameController.text.trim(),
      mobile: _emailController.text.trim(), // Using email field for mobile
    );

    if (!mounted) return;

    if (requestId != null) {
      Navigator.of(context).pushNamed(
        '/otpVerification',
        arguments: {
          'mobile': _emailController.text.trim(),
          'requestId': requestId,
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authViewModel.errorMessage ?? 'Failed to send reset code'),
          backgroundColor: AppColor.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.forgotPassword),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColor.textColorGrayDark,
      ),
      body: Consumer<AuthViewModel>(
        builder: (context, authViewModel, child) {
          return LoadingOverlay(
            isLoading: authViewModel.isLoading,
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.spacingLarge),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: AppTheme.spacingLarge),
                      
                      // Icon
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColor.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                          ),
                          child: Icon(
                            Icons.lock_reset_outlined,
                            size: 40,
                            color: AppColor.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingLarge),
                      
                      // Title
                      Text(
                        l10n.forgotPassword,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTheme.spacingSmall),
                      
                      // Subtitle
                      Text(
                        'Enter your registered email or username to receive a password reset code',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColor.textColorGray,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTheme.spacingXLarge),
                      
                      // Option selector
                      Container(
                        decoration: BoxDecoration(
                          color: AppColor.cardBackground,
                          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                          border: Border.all(color: AppColor.borderColor),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _toggleOption(0),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppTheme.spacingMedium,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _selectedOption == 0 
                                        ? AppColor.primaryColor 
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                                  ),
                                  child: Text(
                                    'Email',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _selectedOption == 0 
                                          ? AppColor.whiteColor 
                                          : AppColor.textColorGray,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _toggleOption(1),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: AppTheme.spacingMedium,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _selectedOption == 1 
                                        ? AppColor.primaryColor 
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                                  ),
                                  child: Text(
                                    'Username',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _selectedOption == 1 
                                          ? AppColor.whiteColor 
                                          : AppColor.textColorGray,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingLarge),
                      
                      // Input Field
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _selectedOption == 0
                            ? CustomTextField(
                                key: const ValueKey('email'),
                                controller: _emailController,
                                labelText: 'Email Address',
                                hintText: 'Enter your email address',
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: Validators.email,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _handleForgotPassword(),
                              )
                            : CustomTextField(
                                key: const ValueKey('username'),
                                controller: _usernameController,
                                labelText: 'Username',
                                hintText: 'Enter your username',
                                prefixIcon: Icons.person_outline,
                                validator: Validators.required,
                                textInputAction: TextInputAction.done,
                                onFieldSubmitted: (_) => _handleForgotPassword(),
                              ),
                      ),
                      const SizedBox(height: AppTheme.spacingXLarge),
                      
                      // Send Code Button
                      ElevatedButton(
                        onPressed: authViewModel.isLoading ? null : _handleForgotPassword,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Send Reset Code',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingLarge),
                      
                      // Back to Login
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Remember your password?',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(l10n.login),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}