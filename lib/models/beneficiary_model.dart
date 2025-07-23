import 'package:json_annotation/json_annotation.dart';

part 'beneficiary_model.g.dart';

@JsonSerializable()
class BeneficiaryModel {
  @JsonKey(name: 'beneficiary_id')
  final String beneficiaryId;
  
  @JsonKey(name: 'beneficiary_name')
  final String beneficiaryName;
  
  @JsonKey(name: 'account_number')
  final String accountNumber;
  
  @JsonKey(name: 'ifsc_code')
  final String ifscCode;
  
  @JsonKey(name: 'bank_name')
  final String? bankName;
  
  @JsonKey(name: 'branch_name')
  final String? branchName;
  
  @JsonKey(name: 'email')
  final String? email;
  
  @JsonKey(name: 'mobile_number')
  final String? mobileNumber;
  
  @JsonKey(name: 'beneficiary_type')
  final String? beneficiaryType;
  
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  
  @JsonKey(name: 'is_active')
  final bool isActive;
  
  @JsonKey(name: 'added_date')
  final DateTime addedDate;
  
  @JsonKey(name: 'verified_date')
  final DateTime? verifiedDate;
  
  @JsonKey(name: 'last_transaction_date')
  final DateTime? lastTransactionDate;
  
  @JsonKey(name: 'transaction_count')
  final int? transactionCount;
  
  @JsonKey(name: 'total_amount')
  final double? totalAmount;
  
  @JsonKey(name: 'nick_name')
  final String? nickName;
  
  @JsonKey(name: 'limit_per_transaction')
  final double? limitPerTransaction;
  
  @JsonKey(name: 'daily_limit')
  final double? dailyLimit;
  
  @JsonKey(name: 'monthly_limit')
  final double? monthlyLimit;

  BeneficiaryModel({
    required this.beneficiaryId,
    required this.beneficiaryName,
    required this.accountNumber,
    required this.ifscCode,
    this.bankName,
    this.branchName,
    this.email,
    this.mobileNumber,
    this.beneficiaryType,
    this.isVerified = false,
    this.isActive = true,
    required this.addedDate,
    this.verifiedDate,
    this.lastTransactionDate,
    this.transactionCount,
    this.totalAmount,
    this.nickName,
    this.limitPerTransaction,
    this.dailyLimit,
    this.monthlyLimit,
  });

  String get displayName => nickName ?? beneficiaryName;
  
  String get maskedAccountNumber {
    if (accountNumber.length > 4) {
      return '*' * (accountNumber.length - 4) + accountNumber.substring(accountNumber.length - 4);
    }
    return accountNumber;
  }

  factory BeneficiaryModel.fromJson(Map<String, dynamic> json) => _$BeneficiaryModelFromJson(json);
  Map<String, dynamic> toJson() => _$BeneficiaryModelToJson(this);
}