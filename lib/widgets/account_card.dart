import 'package:flutter/material.dart';
import '../models/account_model.dart';
import '../utils/colors.dart';
import '../utils/app_theme.dart';
import '../utils/currency_formatter.dart';

class AccountCard extends StatelessWidget {
  final AccountModel account;
  final VoidCallback? onTap;

  const AccountCard({
    super.key,
    required this.account,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        padding: const EdgeInsets.all(AppTheme.spacingMedium),
        decoration: BoxDecoration(
          gradient: _getCardGradient(account.accountType),
          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadowColor.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      account.accountTypeDisplay,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColor.whiteColor.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      account.accountName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColor.whiteColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColor.whiteColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  ),
                  child: Icon(
                    _getAccountIcon(account.accountType),
                    color: AppColor.whiteColor,
                    size: 20,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  account.maskedAccountNumber,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColor.whiteColor.withOpacity(0.8),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Available Balance',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColor.whiteColor.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          CurrencyFormatter.format(
                            account.availableBalance,
                            currency: account.currency,
                          ),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColor.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (account.isPrimary)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColor.whiteColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                        ),
                        child: Text(
                          'PRIMARY',
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColor.whiteColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LinearGradient _getCardGradient(String accountType) {
    switch (accountType.toUpperCase()) {
      case 'CURRENT':
        return AppColor.primaryGradient;
      case 'OVERDRAFT':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColor.warningColor, AppColor.warningColor.withOpacity(0.7)],
        );
      case 'CASH_CREDIT':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColor.infoColor, AppColor.infoColor.withOpacity(0.7)],
        );
      case 'LOAN':
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColor.errorColor, AppColor.errorColor.withOpacity(0.7)],
        );
      default:
        return AppColor.secondaryGradient;
    }
  }

  IconData _getAccountIcon(String accountType) {
    switch (accountType.toUpperCase()) {
      case 'CURRENT':
        return Icons.account_balance_wallet;
      case 'OVERDRAFT':
        return Icons.credit_card;
      case 'CASH_CREDIT':
        return Icons.attach_money;
      case 'LOAN':
        return Icons.trending_up;
      case 'DEPOSIT':
        return Icons.savings;
      default:
        return Icons.account_balance;
    }
  }
}