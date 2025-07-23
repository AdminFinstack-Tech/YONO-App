// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessModel _$BusinessModelFromJson(Map<String, dynamic> json) =>
    BusinessModel(
      businessId: json['business_id'] as String,
      businessName: json['business_name'] as String,
      registrationNumber: json['registration_number'] as String,
      taxId: json['tax_id'] as String,
      businessType: json['business_type'] as String?,
      industry: json['industry'] as String?,
      establishedDate: json['established_date'] == null
          ? null
          : DateTime.parse(json['established_date'] as String),
      registeredAddress: json['registered_address'] == null
          ? null
          : Address.fromJson(
              json['registered_address'] as Map<String, dynamic>),
      communicationAddress: json['communication_address'] == null
          ? null
          : Address.fromJson(
              json['communication_address'] as Map<String, dynamic>),
      contactNumber: json['contact_number'] as String?,
      contactEmail: json['contact_email'] as String?,
      website: json['website'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      verificationStatus: json['verification_status'] as String?,
      authorizedSignatories: (json['authorized_signatories'] as List<dynamic>?)
          ?.map((e) => AuthorizedSignatory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BusinessModelToJson(BusinessModel instance) =>
    <String, dynamic>{
      'business_id': instance.businessId,
      'business_name': instance.businessName,
      'registration_number': instance.registrationNumber,
      'tax_id': instance.taxId,
      'business_type': instance.businessType,
      'industry': instance.industry,
      'established_date': instance.establishedDate?.toIso8601String(),
      'registered_address': instance.registeredAddress,
      'communication_address': instance.communicationAddress,
      'contact_number': instance.contactNumber,
      'contact_email': instance.contactEmail,
      'website': instance.website,
      'is_active': instance.isActive,
      'verification_status': instance.verificationStatus,
      'authorized_signatories': instance.authorizedSignatories,
    };

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      addressLine1: json['address_line1'] as String,
      addressLine2: json['address_line2'] as String?,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      postalCode: json['postal_code'] as String,
    );

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'address_line1': instance.addressLine1,
      'address_line2': instance.addressLine2,
      'city': instance.city,
      'state': instance.state,
      'country': instance.country,
      'postal_code': instance.postalCode,
    };

AuthorizedSignatory _$AuthorizedSignatoryFromJson(Map<String, dynamic> json) =>
    AuthorizedSignatory(
      signatoryId: json['signatory_id'] as String,
      signatoryName: json['signatory_name'] as String,
      designation: json['designation'] as String,
      mobileNumber: json['mobile_number'] as String,
      email: json['email'] as String,
      approvalLimit: (json['approval_limit'] as num?)?.toDouble(),
      isActive: json['is_active'] as bool? ?? true,
      addedDate: json['added_date'] == null
          ? null
          : DateTime.parse(json['added_date'] as String),
    );

Map<String, dynamic> _$AuthorizedSignatoryToJson(
        AuthorizedSignatory instance) =>
    <String, dynamic>{
      'signatory_id': instance.signatoryId,
      'signatory_name': instance.signatoryName,
      'designation': instance.designation,
      'mobile_number': instance.mobileNumber,
      'email': instance.email,
      'approval_limit': instance.approvalLimit,
      'is_active': instance.isActive,
      'added_date': instance.addedDate?.toIso8601String(),
    };
