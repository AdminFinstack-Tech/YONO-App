class Validators {
  // Required field validator
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  // Email validator
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    
    return null;
  }

  // Mobile number validator
  static String? mobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Mobile number is required';
    }
    
    // Remove any non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    
    if (digitsOnly.length != 10) {
      return 'Please enter a valid 10-digit mobile number';
    }
    
    return null;
  }

  // Password validator
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    
    if (value.length > 20) {
      return 'Password must not exceed 20 characters';
    }
    
    // Check for at least one uppercase letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }
    
    // Check for at least one lowercase letter
    if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain at least one lowercase letter';
    }
    
    // Check for at least one digit
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    
    // Check for at least one special character
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character';
    }
    
    return null;
  }

  // Confirm password validator
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }

  // PIN validator
  static String? pin(String? value) {
    if (value == null || value.isEmpty) {
      return 'PIN is required';
    }
    
    if (value.length != 6) {
      return 'PIN must be 6 digits';
    }
    
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'PIN must contain only numbers';
    }
    
    return null;
  }

  // OTP validator
  static String? otp(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    
    if (value.length != 6) {
      return 'OTP must be 6 digits';
    }
    
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'OTP must contain only numbers';
    }
    
    return null;
  }

  // Amount validator
  static String? amount(String? value, {double? min, double? max}) {
    if (value == null || value.trim().isEmpty) {
      return 'Amount is required';
    }
    
    final amount = double.tryParse(value.replaceAll(',', ''));
    if (amount == null) {
      return 'Please enter a valid amount';
    }
    
    if (amount <= 0) {
      return 'Amount must be greater than 0';
    }
    
    if (min != null && amount < min) {
      return 'Minimum amount is $min';
    }
    
    if (max != null && amount > max) {
      return 'Maximum amount is $max';
    }
    
    return null;
  }

  // Account number validator
  static String? accountNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Account number is required';
    }
    
    // Remove any spaces or special characters
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    
    if (digitsOnly.length < 9 || digitsOnly.length > 18) {
      return 'Please enter a valid account number';
    }
    
    return null;
  }

  // IFSC code validator
  static String? ifscCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'IFSC code is required';
    }
    
    // IFSC code format: First 4 characters are alphabets, 5th is 0, last 6 are alphanumeric
    final ifscRegex = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');
    
    if (!ifscRegex.hasMatch(value.toUpperCase())) {
      return 'Please enter a valid IFSC code';
    }
    
    return null;
  }

  // Username validator
  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }
    
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    
    if (value.length > 20) {
      return 'Username must not exceed 20 characters';
    }
    
    // Only allow alphanumeric characters and underscores
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    
    return null;
  }

  // Generic length validator
  static String? Function(String?) length({
    int? min,
    int? max,
    String? fieldName = 'Field',
  }) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return '$fieldName is required';
      }
      
      if (min != null && value.length < min) {
        return '$fieldName must be at least $min characters';
      }
      
      if (max != null && value.length > max) {
        return '$fieldName must not exceed $max characters';
      }
      
      return null;
    };
  }

  // Regex validator
  static String? Function(String?) regex({
    required RegExp pattern,
    required String errorMessage,
  }) {
    return (String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'This field is required';
      }
      
      if (!pattern.hasMatch(value)) {
        return errorMessage;
      }
      
      return null;
    };
  }
}