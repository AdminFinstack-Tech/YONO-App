// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
      accountId: json['account_id'] as String,
      accountNumber: json['account_number'] as String,
      accountName: json['account_name'] as String,
      accountType: json['account_type'] as String,
      currency: json['currency'] as String,
      currentBalance: (json['current_balance'] as num).toDouble(),
      availableBalance: (json['available_balance'] as num).toDouble(),
      blockedAmount: (json['blocked_amount'] as num?)?.toDouble() ?? 0.0,
      overdraftLimit: (json['overdraft_limit'] as num?)?.toDouble(),
      interestRate: (json['interest_rate'] as num?)?.toDouble(),
      branchCode: json['branch_code'] as String?,
      branchName: json['branch_name'] as String?,
      ifscCode: json['ifsc_code'] as String?,
      isPrimary: json['is_primary'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      openedDate: json['opened_date'] == null
          ? null
          : DateTime.parse(json['opened_date'] as String),
      lastTransactionDate: json['last_transaction_date'] == null
          ? null
          : DateTime.parse(json['last_transaction_date'] as String),
    );

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'account_id': instance.accountId,
      'account_number': instance.accountNumber,
      'account_name': instance.accountName,
      'account_type': instance.accountType,
      'currency': instance.currency,
      'current_balance': instance.currentBalance,
      'available_balance': instance.availableBalance,
      'blocked_amount': instance.blockedAmount,
      'overdraft_limit': instance.overdraftLimit,
      'interest_rate': instance.interestRate,
      'branch_code': instance.branchCode,
      'branch_name': instance.branchName,
      'ifsc_code': instance.ifscCode,
      'is_primary': instance.isPrimary,
      'is_active': instance.isActive,
      'opened_date': instance.openedDate?.toIso8601String(),
      'last_transaction_date': instance.lastTransactionDate?.toIso8601String(),
    };
