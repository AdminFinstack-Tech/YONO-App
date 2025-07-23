import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewModels/AuthViewModel.dart';
import '../../utils/colors.dart';
import '../../utils/app_theme.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/loading_overlay.dart';
import '../../l10n/app_localizations.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String _identifier = '';
  String _otp = '';
  bool _isEmail = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      _identifier = arguments['identifier'] ?? '';
      _otp = arguments['otp'] ?? '';
      _isEmail = arguments['isEmail'] ?? true;
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _handleResetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final authViewModel = context.read<AuthViewModel>();
    
    final success = await authViewModel.resetPassword(
      requestId: _otp, // Using OTP as requestId - may need proper requestId
      newPassword: _passwordController.text,
      confirmPassword: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushNamed('/passwordSuccess');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authViewModel.errorMessage ?? 'Failed to reset password'),
          backgroundColor: AppColor.errorColor,
        ),
      );
    }
  }

  Widget _buildPasswordStrengthIndicator() {
    final password = _passwordController.text;
    int strength = 0;
    
    if (password.length >= 8) strength++;
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;

    Color strengthColor;
    String strengthText;
    
    switch (strength) {
      case 0:
      case 1:
        strengthColor = AppColor.errorColor;
        strengthText = 'Weak';
        break;
      case 2:
      case 3:
        strengthColor = AppColor.warningColor;
        strengthText = 'Medium';
        break;
      case 4:
      case 5:
        strengthColor = AppColor.successColor;
        strengthText = 'Strong';
        break;
      default:
        strengthColor = AppColor.textColorGray;
        strengthText = '';
    }

    return password.isNotEmpty
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppTheme.spacingSmall),
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: strength / 5,
                      backgroundColor: AppColor.borderColor,
                      valueColor: AlwaysStoppedAnimation<Color>(strengthColor),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingSmall),
                  Text(
                    strengthText,
                    style: TextStyle(
                      color: strengthColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          )
        : const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: AppColor.textColorBlack,
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
                        'Create New Password',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTheme.spacingSmall),
                      
                      // Subtitle
                      Text(
                        'Your new password must be different from previously used passwords',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColor.textColorGray,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTheme.spacingXLarge),
                      
                      // New Password Field
                      CustomTextField(
                        controller: _passwordController,
                        labelText: 'New Password',
                        hintText: 'Enter your new password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: !_isPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                        validator: Validators.password,
                        textInputAction: TextInputAction.next,
                        onChanged: (_) => setState(() {}), // Trigger rebuild for strength indicator
                      ),
                      
                      // Password Strength Indicator
                      _buildPasswordStrengthIndicator(),
                      
                      const SizedBox(height: AppTheme.spacingMedium),
                      
                      // Confirm Password Field
                      CustomTextField(
                        controller: _confirmPasswordController,
                        labelText: 'Confirm Password',
                        hintText: 'Confirm your new password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: !_isConfirmPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: _toggleConfirmPasswordVisibility,
                        ),
                        validator: _validateConfirmPassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_) => _handleResetPassword(),
                      ),
                      const SizedBox(height: AppTheme.spacingMedium),
                      
                      // Password Requirements
                      Container(
                        padding: const EdgeInsets.all(AppTheme.spacingMedium),
                        decoration: BoxDecoration(
                          color: AppColor.cardBackground,
                          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                          border: Border.all(color: AppColor.borderColor),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Password must contain:',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColor.textColorGray,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingSmall),
                            _buildRequirementItem('At least 8 characters'),
                            _buildRequirementItem('One uppercase letter (A-Z)'),
                            _buildRequirementItem('One lowercase letter (a-z)'),
                            _buildRequirementItem('One number (0-9)'),
                            _buildRequirementItem('One special character'),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingXLarge),
                      
                      // Reset Password Button
                      ElevatedButton(
                        onPressed: authViewModel.isLoading ? null : _handleResetPassword,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Reset Password',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
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

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 16,
            color: AppColor.textColorGray,
          ),
          const SizedBox(width: AppTheme.spacingSmall),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColor.textColorGray,
            ),
          ),
        ],
      ),
    );
  }
}