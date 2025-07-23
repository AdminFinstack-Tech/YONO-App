import 'package:intl/intl.dart';

class CurrencyFormatter {
  static String format(
    double amount, {
    String currency = 'INR',
    String locale = 'en_IN',
    bool showSymbol = true,
    int decimalDigits = 2,
  }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: showSymbol ? _getCurrencySymbol(currency) : '',
      decimalDigits: decimalDigits,
    );
    
    return formatter.format(amount);
  }

  static String formatCompact(
    double amount, {
    String currency = 'INR',
    String locale = 'en_IN',
  }) {
    if (amount >= 10000000) { // 1 Crore
      return '${_getCurrencySymbol(currency)}${(amount / 10000000).toStringAsFixed(2)}Cr';
    } else if (amount >= 100000) { // 1 Lakh
      return '${_getCurrencySymbol(currency)}${(amount / 100000).toStringAsFixed(2)}L';
    } else if (amount >= 1000) { // 1 Thousand
      return '${_getCurrencySymbol(currency)}${(amount / 1000).toStringAsFixed(2)}K';
    }
    
    return format(amount, currency: currency, locale: locale);
  }

  static String _getCurrencySymbol(String currency) {
    switch (currency.toUpperCase()) {
      case 'INR':
        return '₹';
      case 'USD':
        return '\$';
      case 'EUR':
        return '€';
      case 'GBP':
        return '£';
      case 'JPY':
        return '¥';
      default:
        return currency;
    }
  }

  static double? parse(String value, {String locale = 'en_IN'}) {
    try {
      // Remove currency symbols and spaces
      final cleanValue = value.replaceAll(RegExp(r'[₹\$€£¥,\s]'), '');
      return double.tryParse(cleanValue);
    } catch (e) {
      return null;
    }
  }

  static String formatWithoutSymbol(
    double amount, {
    String locale = 'en_IN',
    int decimalDigits = 2,
  }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: '',
      decimalDigits: decimalDigits,
    );
    
    return formatter.format(amount).trim();
  }
}