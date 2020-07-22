// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GroupMemberModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupMemberModel _$GroupMemberModelFromJson(Map<String, dynamic> json) {
  return GroupMemberModel(
    (json['allMembers'] as List)
        ?.map((e) =>
            e == null ? null : AllMembers.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$GroupMemberModelToJson(GroupMemberModel instance) =>
    <String, dynamic>{
      'allMembers': instance.allMembers,
    };

AllMembers _$AllMembersFromJson(Map<String, dynamic> json) {
  return AllMembers(
    json['id'],
    json['isAdmin'],
    json['isCreator'],
    json['missedPosts'],
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    json['user_id'],
  );
}

Map<String, dynamic> _$AllMembersToJson(AllMembers instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'isAdmin': instance.isAdmin,
      'isCreator': instance.isCreator,
      'missedPosts': instance.missedPosts,
      'user': instance.user,
    };

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['id'],
    json['firstName'],
    json['lastName'],
    json['userName'],
    json['jobTitle'],
    json['profilePic'],
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'userName': instance.userName,
      'profilePic': instance.profilePic,
      'jobTitle': instance.jobTitle,
    };
