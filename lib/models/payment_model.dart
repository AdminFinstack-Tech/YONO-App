import 'package:json_annotation/json_annotation.dart';

part 'payment_model.g.dart';

@JsonSerializable()
class PaymentModel {
  @JsonKey(name: 'payment_id')
  final String paymentId;
  
  @JsonKey(name: 'transaction_id')
  final String transactionId;
  
  @JsonKey(name: 'from_account_id')
  final String fromAccountId;
  
  @JsonKey(name: 'from_account_number')
  final String? fromAccountNumber;
  
  @JsonKey(name: 'to_account')
  final String toAccount;
  
  @JsonKey(name: 'beneficiary_name')
  final String? beneficiaryName;
  
  @JsonKey(name: 'beneficiary_id')
  final String? beneficiaryId;
  
  final double amount;
  
  final String currency;
  
  @JsonKey(name: 'payment_mode')
  final String paymentMode;
  
  final String status;
  
  final String? remarks;
  
  @JsonKey(name: 'payment_date')
  final DateTime paymentDate;
  
  @JsonKey(name: 'value_date')
  final DateTime? valueDate;
  
  @JsonKey(name: 'reference_number')
  final String? referenceNumber;
  
  @JsonKey(name: 'bank_reference')
  final String? bankReference;
  
  @JsonKey(name: 'charges')
  final double? charges;
  
  @JsonKey(name: 'tax')
  final double? tax;
  
  @JsonKey(name: 'initiated_by')
  final String? initiatedBy;
  
  @JsonKey(name: 'approved_by')
  final String? approvedBy;
  
  @JsonKey(name: 'approval_date')
  final DateTime? approvalDate;
  
  @JsonKey(name: 'rejection_reason')
  final String? rejectionReason;
  
  @JsonKey(name: 'retry_count')
  final int? retryCount;
  
  @JsonKey(name: 'scheduled_date')
  final DateTime? scheduledDate;
  
  @JsonKey(name: 'is_recurring')
  final bool isRecurring;

  PaymentModel({
    required this.paymentId,
    required this.transactionId,
    required this.fromAccountId,
    this.fromAccountNumber,
    required this.toAccount,
    this.beneficiaryName,
    this.beneficiaryId,
    required this.amount,
    required this.currency,
    required this.paymentMode,
    required this.status,
    this.remarks,
    required this.paymentDate,
    this.valueDate,
    this.referenceNumber,
    this.bankReference,
    this.charges,
    this.tax,
    this.initiatedBy,
    this.approvedBy,
    this.approvalDate,
    this.rejectionReason,
    this.retryCount,
    this.scheduledDate,
    this.isRecurring = false,
  });

  double get totalAmount => amount + (charges ?? 0) + (tax ?? 0);
  
  bool get isPending => status.toUpperCase() == 'PENDING';
  bool get isCompleted => status.toUpperCase() == 'COMPLETED' || status.toUpperCase() == 'SUCCESS';
  bool get isFailed => status.toUpperCase() == 'FAILED';
  bool get isScheduled => scheduledDate != null && scheduledDate!.isAfter(DateTime.now());

  factory PaymentModel.fromJson(Map<String, dynamic> json) => _$PaymentModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentModelToJson(this);
}