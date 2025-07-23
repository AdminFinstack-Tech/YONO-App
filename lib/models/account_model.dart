import 'package:json_annotation/json_annotation.dart';

part 'account_model.g.dart';

@JsonSerializable()
class AccountModel {
  @JsonKey(name: 'account_id')
  final String accountId;
  
  @JsonKey(name: 'account_number')
  final String accountNumber;
  
  @JsonKey(name: 'account_name')
  final String accountName;
  
  @JsonKey(name: 'account_type')
  final String accountType;
  
  final String currency;
  
  @JsonKey(name: 'current_balance')
  final double currentBalance;
  
  @JsonKey(name: 'available_balance')
  final double availableBalance;
  
  @JsonKey(name: 'blocked_amount')
  final double blockedAmount;
  
  @JsonKey(name: 'overdraft_limit')
  final double? overdraftLimit;
  
  @JsonKey(name: 'interest_rate')
  final double? interestRate;
  
  @JsonKey(name: 'branch_code')
  final String? branchCode;
  
  @JsonKey(name: 'branch_name')
  final String? branchName;
  
  @JsonKey(name: 'ifsc_code')
  final String? ifscCode;
  
  @JsonKey(name: 'is_primary')
  final bool isPrimary;
  
  @JsonKey(name: 'is_active')
  final bool isActive;
  
  @JsonKey(name: 'opened_date')
  final DateTime? openedDate;
  
  @JsonKey(name: 'last_transaction_date')
  final DateTime? lastTransactionDate;

  AccountModel({
    required this.accountId,
    required this.accountNumber,
    required this.accountName,
    required this.accountType,
    required this.currency,
    required this.currentBalance,
    required this.availableBalance,
    this.blockedAmount = 0.0,
    this.overdraftLimit,
    this.interestRate,
    this.branchCode,
    this.branchName,
    this.ifscCode,
    this.isPrimary = false,
    this.isActive = true,
    this.openedDate,
    this.lastTransactionDate,
  });

  String get maskedAccountNumber {
    if (accountNumber.length > 4) {
      return '*' * (accountNumber.length - 4) + accountNumber.substring(accountNumber.length - 4);
    }
    return accountNumber;
  }

  String get accountTypeDisplay {
    switch (accountType.toUpperCase()) {
      case 'CURRENT':
        return 'Current Account';
      case 'OVERDRAFT':
        return 'Overdraft Account';
      case 'CASH_CREDIT':
        return 'Cash Credit';
      case 'LOAN':
        return 'Loan Account';
      case 'DEPOSIT':
        return 'Fixed Deposit';
      default:
        return accountType;
    }
  }

  factory AccountModel.fromJson(Map<String, dynamic> json) => _$AccountModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}