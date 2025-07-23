// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      transactionId: json['transaction_id'] as String,
      referenceNumber: json['reference_number'] as String,
      transactionType: json['transaction_type'] as String,
      transactionMode: json['transaction_mode'] as String?,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      transactionDate: DateTime.parse(json['transaction_date'] as String),
      valueDate: json['value_date'] == null
          ? null
          : DateTime.parse(json['value_date'] as String),
      status: json['status'] as String,
      description: json['description'] as String?,
      remarks: json['remarks'] as String?,
      fromAccount: json['from_account'] == null
          ? null
          : AccountInfo.fromJson(json['from_account'] as Map<String, dynamic>),
      toAccount: json['to_account'] == null
          ? null
          : AccountInfo.fromJson(json['to_account'] as Map<String, dynamic>),
      beneficiaryName: json['beneficiary_name'] as String?,
      beneficiaryAccount: json['beneficiary_account'] as String?,
      beneficiaryBank: json['beneficiary_bank'] as String?,
      beneficiaryIfsc: json['beneficiary_ifsc'] as String?,
      runningBalance: (json['running_balance'] as num?)?.toDouble(),
      charges: (json['charges'] as num?)?.toDouble(),
      tax: (json['tax'] as num?)?.toDouble(),
      exchangeRate: (json['exchange_rate'] as num?)?.toDouble(),
      initiatedBy: json['initiated_by'] as String?,
      approvedBy: json['approved_by'] as String?,
      approvalDate: json['approval_date'] == null
          ? null
          : DateTime.parse(json['approval_date'] as String),
      rejectionReason: json['rejection_reason'] as String?,
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'transaction_id': instance.transactionId,
      'reference_number': instance.referenceNumber,
      'transaction_type': instance.transactionType,
      'transaction_mode': instance.transactionMode,
      'amount': instance.amount,
      'currency': instance.currency,
      'transaction_date': instance.transactionDate.toIso8601String(),
      'value_date': instance.valueDate?.toIso8601String(),
      'status': instance.status,
      'description': instance.description,
      'remarks': instance.remarks,
      'from_account': instance.fromAccount,
      'to_account': instance.toAccount,
      'beneficiary_name': instance.beneficiaryName,
      'beneficiary_account': instance.beneficiaryAccount,
      'beneficiary_bank': instance.beneficiaryBank,
      'beneficiary_ifsc': instance.beneficiaryIfsc,
      'running_balance': instance.runningBalance,
      'charges': instance.charges,
      'tax': instance.tax,
      'exchange_rate': instance.exchangeRate,
      'initiated_by': instance.initiatedBy,
      'approved_by': instance.approvedBy,
      'approval_date': instance.approvalDate?.toIso8601String(),
      'rejection_reason': instance.rejectionReason,
    };

AccountInfo _$AccountInfoFromJson(Map<String, dynamic> json) => AccountInfo(
      accountNumber: json['account_number'] as String,
      accountName: json['account_name'] as String?,
      bankName: json['bank_name'] as String?,
      ifscCode: json['ifsc_code'] as String?,
    );

Map<String, dynamic> _$AccountInfoToJson(AccountInfo instance) =>
    <String, dynamic>{
      'account_number': instance.accountNumber,
      'account_name': instance.accountName,
      'bank_name': instance.bankName,
      'ifsc_code': instance.ifscCode,
    };
