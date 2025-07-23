// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      email: json['email'] as String,
      mobileNumber: json['mobile_number'] as String,
      profileImage: json['profile_image'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      isVerified: json['is_verified'] as bool? ?? false,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      lastLogin: json['last_login'] == null
          ? null
          : DateTime.parse(json['last_login'] as String),
      role: json['role'] == null
          ? null
          : UserRole.fromJson(json['role'] as Map<String, dynamic>),
      permissions: (json['permissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'user_id': instance.userId,
      'user_name': instance.userName,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'mobile_number': instance.mobileNumber,
      'profile_image': instance.profileImage,
      'is_active': instance.isActive,
      'is_verified': instance.isVerified,
      'created_at': instance.createdAt?.toIso8601String(),
      'last_login': instance.lastLogin?.toIso8601String(),
      'role': instance.role,
      'permissions': instance.permissions,
    };

UserRole _$UserRoleFromJson(Map<String, dynamic> json) => UserRole(
      roleId: json['role_id'] as String,
      roleName: json['role_name'] as String,
      roleType: json['role_type'] as String,
      description: json['description'] as String?,
      approvalLimit: (json['approval_limit'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UserRoleToJson(UserRole instance) => <String, dynamic>{
      'role_id': instance.roleId,
      'role_name': instance.roleName,
      'role_type': instance.roleType,
      'description': instance.description,
      'approval_limit': instance.approvalLimit,
    };
