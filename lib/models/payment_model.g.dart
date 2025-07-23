// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentModel _$PaymentModelFromJson(Map<String, dynamic> json) => PaymentModel(
      paymentId: json['payment_id'] as String,
      transactionId: json['transaction_id'] as String,
      fromAccountId: json['from_account_id'] as String,
      fromAccountNumber: json['from_account_number'] as String?,
      toAccount: json['to_account'] as String,
      beneficiaryName: json['beneficiary_name'] as String?,
      beneficiaryId: json['beneficiary_id'] as String?,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      paymentMode: json['payment_mode'] as String,
      status: json['status'] as String,
      remarks: json['remarks'] as String?,
      paymentDate: DateTime.parse(json['payment_date'] as String),
      valueDate: json['value_date'] == null
          ? null
          : DateTime.parse(json['value_date'] as String),
      referenceNumber: json['reference_number'] as String?,
      bankReference: json['bank_reference'] as String?,
      charges: (json['charges'] as num?)?.toDouble(),
      tax: (json['tax'] as num?)?.toDouble(),
      initiatedBy: json['initiated_by'] as String?,
      approvedBy: json['approved_by'] as String?,
      approvalDate: json['approval_date'] == null
          ? null
          : DateTime.parse(json['approval_date'] as String),
      rejectionReason: json['rejection_reason'] as String?,
      retryCount: (json['retry_count'] as num?)?.toInt(),
      scheduledDate: json['scheduled_date'] == null
          ? null
          : DateTime.parse(json['scheduled_date'] as String),
      isRecurring: json['is_recurring'] as bool? ?? false,
    );

Map<String, dynamic> _$PaymentModelToJson(PaymentModel instance) =>
    <String, dynamic>{
      'payment_id': instance.paymentId,
      'transaction_id': instance.transactionId,
      'from_account_id': instance.fromAccountId,
      'from_account_number': instance.fromAccountNumber,
      'to_account': instance.toAccount,
      'beneficiary_name': instance.beneficiaryName,
      'beneficiary_id': instance.beneficiaryId,
      'amount': instance.amount,
      'currency': instance.currency,
      'payment_mode': instance.paymentMode,
      'status': instance.status,
      'remarks': instance.remarks,
      'payment_date': instance.paymentDate.toIso8601String(),
      'value_date': instance.valueDate?.toIso8601String(),
      'reference_number': instance.referenceNumber,
      'bank_reference': instance.bankReference,
      'charges': instance.charges,
      'tax': instance.tax,
      'initiated_by': instance.initiatedBy,
      'approved_by': instance.approvedBy,
      'approval_date': instance.approvalDate?.toIso8601String(),
      'rejection_reason': instance.rejectionReason,
      'retry_count': instance.retryCount,
      'scheduled_date': instance.scheduledDate?.toIso8601String(),
      'is_recurring': instance.isRecurring,
    };
