import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../viewModels/AuthViewModel.dart';
import '../../utils/colors.dart';
import '../../utils/app_theme.dart';
import '../../widgets/loading_overlay.dart';
import '../../l10n/app_localizations.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());
  Timer? _resendTimer;
  int _resendCountdown = 60;
  String _identifier = '';
  bool _isEmail = true;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (arguments != null) {
      _identifier = arguments['identifier'] ?? '';
      _isEmail = arguments['isEmail'] ?? true;
    }
  }

  @override
  void dispose() {
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendCountdown = 60;
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _onOTPChanged(String value, int index) {
    if (value.length == 1) {
      if (index < 5) {
        _otpFocusNodes[index + 1].requestFocus();
      } else {
        _otpFocusNodes[index].unfocus();
        _verifyOTP();
      }
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
  }

  String _getOTPValue() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  void _clearOTP() {
    for (final controller in _otpControllers) {
      controller.clear();
    }
    _otpFocusNodes[0].requestFocus();
  }

  Future<void> _verifyOTP() async {
    final otp = _getOTPValue();
    if (otp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter complete OTP'),
          backgroundColor: AppColor.errorColor,
        ),
      );
      return;
    }

    final authViewModel = context.read<AuthViewModel>();
    
    final success = await authViewModel.verifyOTP(
      mobile: _identifier,
      otp: otp,
      requestId: '', // You may need to pass the actual requestId
    );

    if (!mounted) return;

    if (success) {
      Navigator.of(context).pushNamed(
        '/resetPassword',
        arguments: {
          'identifier': _identifier,
          'otp': otp,
          'isEmail': _isEmail,
        },
      );
    } else {
      _clearOTP();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authViewModel.errorMessage ?? 'Invalid OTP. Please try again.'),
          backgroundColor: AppColor.errorColor,
        ),
      );
    }
  }

  Future<void> _resendOTP() async {
    final authViewModel = context.read<AuthViewModel>();
    
    final requestId = await authViewModel.forgotPassword(
      username: _identifier, 
      mobile: _identifier,
    );

    if (!mounted) return;

    if (requestId != null) {
      _startResendTimer();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('OTP sent successfully'),
          backgroundColor: AppColor.successColor,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authViewModel.errorMessage ?? 'Failed to resend OTP'),
          backgroundColor: AppColor.errorColor,
        ),
      );
    }
  }

  String _getMaskedIdentifier() {
    if (_isEmail) {
      final parts = _identifier.split('@');
      if (parts.length == 2) {
        final username = parts[0];
        final domain = parts[1];
        return '${username.substring(0, 2)}${'*' * (username.length - 2)}@$domain';
      }
    } else {
      if (_identifier.length > 4) {
        return '${_identifier.substring(0, 2)}${'*' * (_identifier.length - 4)}${_identifier.substring(_identifier.length - 2)}';
      }
    }
    return _identifier;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification'),
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
                          Icons.sms_outlined,
                          size: 40,
                          color: AppColor.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),
                    
                    // Title
                    Text(
                      'OTP Verification',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spacingSmall),
                    
                    // Subtitle
                    Text(
                      'Enter the 6-digit code sent to\n${_getMaskedIdentifier()}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColor.textColorGray,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spacingXLarge),
                    
                    // OTP Input Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 45,
                          height: 55,
                          child: TextFormField(
                            controller: _otpControllers[index],
                            focusNode: _otpFocusNodes[index],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                                borderSide: const BorderSide(color: AppColor.borderColor),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                                borderSide: const BorderSide(
                                  color: AppColor.primaryColor,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                                borderSide: const BorderSide(color: AppColor.borderColor),
                              ),
                              filled: true,
                              fillColor: AppColor.cardBackground,
                            ),
                            onChanged: (value) => _onOTPChanged(value, index),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: AppTheme.spacingXLarge),
                    
                    // Verify Button
                    ElevatedButton(
                      onPressed: authViewModel.isLoading ? null : _verifyOTP,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Verify OTP',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),
                    
                    // Resend OTP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive code?",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(width: AppTheme.spacingSmall),
                        if (_resendCountdown > 0)
                          Text(
                            'Resend in ${_resendCountdown}s',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColor.textColorGray,
                            ),
                          )
                        else
                          TextButton(
                            onPressed: authViewModel.isLoading ? null : _resendOTP,
                            child: const Text('Resend OTP'),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingLarge),
                    
                    // Back Button
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Back'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}