import 'package:json_annotation/json_annotation.dart';

part 'business_model.g.dart';

@JsonSerializable()
class BusinessModel {
  @JsonKey(name: 'business_id')
  final String businessId;
  
  @JsonKey(name: 'business_name')
  final String businessName;
  
  @JsonKey(name: 'registration_number')
  final String registrationNumber;
  
  @JsonKey(name: 'tax_id')
  final String taxId;
  
  @JsonKey(name: 'business_type')
  final String? businessType;
  
  final String? industry;
  
  @JsonKey(name: 'established_date')
  final DateTime? establishedDate;
  
  @JsonKey(name: 'registered_address')
  final Address? registeredAddress;
  
  @JsonKey(name: 'communication_address')
  final Address? communicationAddress;
  
  @JsonKey(name: 'contact_number')
  final String? contactNumber;
  
  @JsonKey(name: 'contact_email')
  final String? contactEmail;
  
  final String? website;
  
  @JsonKey(name: 'is_active')
  final bool isActive;
  
  @JsonKey(name: 'verification_status')
  final String? verificationStatus;
  
  @JsonKey(name: 'authorized_signatories')
  final List<AuthorizedSignatory>? authorizedSignatories;

  BusinessModel({
    required this.businessId,
    required this.businessName,
    required this.registrationNumber,
    required this.taxId,
    this.businessType,
    this.industry,
    this.establishedDate,
    this.registeredAddress,
    this.communicationAddress,
    this.contactNumber,
    this.contactEmail,
    this.website,
    this.isActive = true,
    this.verificationStatus,
    this.authorizedSignatories,
  });

  factory BusinessModel.fromJson(Map<String, dynamic> json) => _$BusinessModelFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessModelToJson(this);
}

@JsonSerializable()
class Address {
  @JsonKey(name: 'address_line1')
  final String addressLine1;
  
  @JsonKey(name: 'address_line2')
  final String? addressLine2;
  
  final String city;
  
  final String state;
  
  final String country;
  
  @JsonKey(name: 'postal_code')
  final String postalCode;

  Address({
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
  });

  String get fullAddress {
    final parts = [
      addressLine1,
      if (addressLine2 != null && addressLine2!.isNotEmpty) addressLine2,
      city,
      state,
      country,
      postalCode,
    ];
    return parts.join(', ');
  }

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

@JsonSerializable()
class AuthorizedSignatory {
  @JsonKey(name: 'signatory_id')
  final String signatoryId;
  
  @JsonKey(name: 'signatory_name')
  final String signatoryName;
  
  final String designation;
  
  @JsonKey(name: 'mobile_number')
  final String mobileNumber;
  
  final String email;
  
  @JsonKey(name: 'approval_limit')
  final double? approvalLimit;
  
  @JsonKey(name: 'is_active')
  final bool isActive;
  
  @JsonKey(name: 'added_date')
  final DateTime? addedDate;

  AuthorizedSignatory({
    required this.signatoryId,
    required this.signatoryName,
    required this.designation,
    required this.mobileNumber,
    required this.email,
    this.approvalLimit,
    this.isActive = true,
    this.addedDate,
  });

  factory AuthorizedSignatory.fromJson(Map<String, dynamic> json) => _$AuthorizedSignatoryFromJson(json);
  Map<String, dynamic> toJson() => _$AuthorizedSignatoryToJson(this);
}