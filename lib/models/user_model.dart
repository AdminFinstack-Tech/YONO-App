import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: 'user_id')
  final String userId;
  
  @JsonKey(name: 'user_name')
  final String userName;
  
  @JsonKey(name: 'first_name')
  final String? firstName;
  
  @JsonKey(name: 'last_name')
  final String? lastName;
  
  final String email;
  
  @JsonKey(name: 'mobile_number')
  final String mobileNumber;
  
  @JsonKey(name: 'profile_image')
  final String? profileImage;
  
  @JsonKey(name: 'is_active')
  final bool isActive;
  
  @JsonKey(name: 'is_verified')
  final bool isVerified;
  
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  
  @JsonKey(name: 'last_login')
  final DateTime? lastLogin;
  
  final UserRole? role;
  
  final List<String>? permissions;

  UserModel({
    required this.userId,
    required this.userName,
    this.firstName,
    this.lastName,
    required this.email,
    required this.mobileNumber,
    this.profileImage,
    this.isActive = true,
    this.isVerified = false,
    this.createdAt,
    this.lastLogin,
    this.role,
    this.permissions,
  });

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class UserRole {
  @JsonKey(name: 'role_id')
  final String roleId;
  
  @JsonKey(name: 'role_name')
  final String roleName;
  
  @JsonKey(name: 'role_type')
  final String roleType;
  
  final String? description;
  
  @JsonKey(name: 'approval_limit')
  final double? approvalLimit;

  UserRole({
    required this.roleId,
    required this.roleName,
    required this.roleType,
    this.description,
    this.approvalLimit,
  });

  factory UserRole.fromJson(Map<String, dynamic> json) => _$UserRoleFromJson(json);
  Map<String, dynamic> toJson() => _$UserRoleToJson(this);
}