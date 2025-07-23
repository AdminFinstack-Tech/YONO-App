// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beneficiary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BeneficiaryModel _$BeneficiaryModelFromJson(Map<String, dynamic> json) =>
    BeneficiaryModel(
      beneficiaryId: json['beneficiary_id'] as String,
      beneficiaryName: json['beneficiary_name'] as String,
      accountNumber: json['account_number'] as String,
      ifscCode: json['ifsc_code'] as String,
      bankName: json['bank_name'] as String?,
      branchName: json['branch_name'] as String?,
      email: json['email'] as String?,
      mobileNumber: json['mobile_number'] as String?,
      beneficiaryType: json['beneficiary_type'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      addedDate: DateTime.parse(json['added_date'] as String),
      verifiedDate: json['verified_date'] == null
          ? null
          : DateTime.parse(json['verified_date'] as String),
      lastTransactionDate: json['last_transaction_date'] == null
          ? null
          : DateTime.parse(json['last_transaction_date'] as String),
      transactionCount: (json['transaction_count'] as num?)?.toInt(),
      totalAmount: (json['total_amount'] as num?)?.toDouble(),
      nickName: json['nick_name'] as String?,
      limitPerTransaction: (json['limit_per_transaction'] as num?)?.toDouble(),
      dailyLimit: (json['daily_limit'] as num?)?.toDouble(),
      monthlyLimit: (json['monthly_limit'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$BeneficiaryModelToJson(BeneficiaryModel instance) =>
    <String, dynamic>{
      'beneficiary_id': instance.beneficiaryId,
      'beneficiary_name': instance.beneficiaryName,
      'account_number': instance.accountNumber,
      'ifsc_code': instance.ifscCode,
      'bank_name': instance.bankName,
      'branch_name': instance.branchName,
      'email': instance.email,
      'mobile_number': instance.mobileNumber,
      'beneficiary_type': instance.beneficiaryType,
      'is_verified': instance.isVerified,
      'is_active': instance.isActive,
      'added_date': instance.addedDate.toIso8601String(),
      'verified_date': instance.verifiedDate?.toIso8601String(),
      'last_transaction_date': instance.lastTransactionDate?.toIso8601String(),
      'transaction_count': instance.transactionCount,
      'total_amount': instance.totalAmount,
      'nick_name': instance.nickName,
      'limit_per_transaction': instance.limitPerTransaction,
      'daily_limit': instance.dailyLimit,
      'monthly_limit': instance.monthlyLimit,
    };
