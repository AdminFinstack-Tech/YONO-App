import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../utils/colors.dart';
import '../utils/app_theme.dart';
import '../utils/currency_formatter.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;

  const TransactionListItem({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: _getStatusColor(transaction).withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: Icon(
          _getTransactionIcon(),
          color: _getStatusColor(transaction),
          size: 24,
        ),
      ),
      title: Text(
        transaction.beneficiaryName ?? transaction.description ?? 'Transaction',
        style: Theme.of(context).textTheme.bodyLarge,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 2),
          Text(
            _getTransactionSubtitle(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColor.textColorGray,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(transaction).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Text(
                  transaction.status.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: _getStatusColor(transaction),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                DateFormat('dd MMM, hh:mm a').format(transaction.transactionDate),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColor.textColorGrayLight,
                ),
              ),
            ],
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${transaction.isCredit ? '+' : '-'} ${CurrencyFormatter.format(
              transaction.amount,
              currency: transaction.currency,
            )}',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: transaction.isCredit ? AppColor.creditColor : AppColor.debitColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (transaction.runningBalance != null)
            Text(
              'Bal: ${CurrencyFormatter.format(
                transaction.runningBalance!,
                currency: transaction.currency,
              )}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColor.textColorGrayLight,
              ),
            ),
        ],
      ),
    );
  }

  IconData _getTransactionIcon() {
    if (transaction.transactionMode != null) {
      switch (transaction.transactionMode!.toUpperCase()) {
        case 'UPI':
          return Icons.phone_android;
        case 'IMPS':
        case 'NEFT':
        case 'RTGS':
          return Icons.swap_horiz;
        case 'CARD':
          return Icons.credit_card;
        case 'CHEQUE':
          return Icons.receipt;
        default:
          return transaction.isCredit ? Icons.arrow_downward : Icons.arrow_upward;
      }
    }
    return transaction.isCredit ? Icons.arrow_downward : Icons.arrow_upward;
  }

  String _getTransactionSubtitle() {
    if (transaction.referenceNumber.isNotEmpty) {
      return 'Ref: ${transaction.referenceNumber}';
    }
    if (transaction.remarks != null && transaction.remarks!.isNotEmpty) {
      return transaction.remarks!;
    }
    if (transaction.transactionMode != null) {
      return transaction.transactionMode!;
    }
    return transaction.transactionType;
  }

  Color _getStatusColor(TransactionModel transaction) {
    if (transaction.isPending) return AppColor.pendingColor;
    if (transaction.isCompleted) return AppColor.successColor;
    if (transaction.isFailed || transaction.isRejected) return AppColor.errorColor;
    return AppColor.textColorGray;
  }
}