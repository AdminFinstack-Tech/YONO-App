import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel {
  @JsonKey(name: 'transaction_id')
  final String transactionId;
  
  @JsonKey(name: 'reference_number')
  final String referenceNumber;
  
  @JsonKey(name: 'transaction_type')
  final String transactionType;
  
  @JsonKey(name: 'transaction_mode')
  final String? transactionMode;
  
  final double amount;
  
  final String currency;
  
  @JsonKey(name: 'transaction_date')
  final DateTime transactionDate;
  
  @JsonKey(name: 'value_date')
  final DateTime? valueDate;
  
  final String status;
  
  final String? description;
  
  final String? remarks;
  
  @JsonKey(name: 'from_account')
  final AccountInfo? fromAccount;
  
  @JsonKey(name: 'to_account')
  final AccountInfo? toAccount;
  
  @JsonKey(name: 'beneficiary_name')
  final String? beneficiaryName;
  
  @JsonKey(name: 'beneficiary_account')
  final String? beneficiaryAccount;
  
  @JsonKey(name: 'beneficiary_bank')
  final String? beneficiaryBank;
  
  @JsonKey(name: 'beneficiary_ifsc')
  final String? beneficiaryIfsc;
  
  @JsonKey(name: 'running_balance')
  final double? runningBalance;
  
  @JsonKey(name: 'charges')
  final double? charges;
  
  @JsonKey(name: 'tax')
  final double? tax;
  
  @JsonKey(name: 'exchange_rate')
  final double? exchangeRate;
  
  @JsonKey(name: 'initiated_by')
  final String? initiatedBy;
  
  @JsonKey(name: 'approved_by')
  final String? approvedBy;
  
  @JsonKey(name: 'approval_date')
  final DateTime? approvalDate;
  
  @JsonKey(name: 'rejection_reason')
  final String? rejectionReason;

  TransactionModel({
    required this.transactionId,
    required this.referenceNumber,
    required this.transactionType,
    this.transactionMode,
    required this.amount,
    required this.currency,
    required this.transactionDate,
    this.valueDate,
    required this.status,
    this.description,
    this.remarks,
    this.fromAccount,
    this.toAccount,
    this.beneficiaryName,
    this.beneficiaryAccount,
    this.beneficiaryBank,
    this.beneficiaryIfsc,
    this.runningBalance,
    this.charges,
    this.tax,
    this.exchangeRate,
    this.initiatedBy,
    this.approvedBy,
    this.approvalDate,
    this.rejectionReason,
  });

  bool get isCredit => transactionType.toUpperCase() == 'CREDIT';
  bool get isDebit => transactionType.toUpperCase() == 'DEBIT';
  bool get isPending => status.toUpperCase() == 'PENDING';
  bool get isCompleted => status.toUpperCase() == 'COMPLETED' || status.toUpperCase() == 'SUCCESS';
  bool get isFailed => status.toUpperCase() == 'FAILED';
  bool get isRejected => status.toUpperCase() == 'REJECTED';

  double get totalAmount => amount + (charges ?? 0) + (tax ?? 0);

  factory TransactionModel.fromJson(Map<String, dynamic> json) => _$TransactionModelFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);
}

@JsonSerializable()
class AccountInfo {
  @JsonKey(name: 'account_number')
  final String accountNumber;
  
  @JsonKey(name: 'account_name')
  final String? accountName;
  
  @JsonKey(name: 'bank_name')
  final String? bankName;
  
  @JsonKey(name: 'ifsc_code')
  final String? ifscCode;

  AccountInfo({
    required this.accountNumber,
    this.accountName,
    this.bankName,
    this.ifscCode,
  });

  factory AccountInfo.fromJson(Map<String, dynamic> json) => _$AccountInfoFromJson(json);
  Map<String, dynamic> toJson() => _$AccountInfoToJson(this);
}