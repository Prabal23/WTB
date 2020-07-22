// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GroupFriendModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupFriendModel _$GroupFriendModelFromJson(Map<String, dynamic> json) {
  return GroupFriendModel(
    (json['nonAdedFriends'] as List)
        ?.map((e) => e == null
            ? null
            : NonAdedFriends.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$GroupFriendModelToJson(GroupFriendModel instance) =>
    <String, dynamic>{
      'nonAdedFriends': instance.nonAdedFriends,
    };

NonAdedFriends _$NonAdedFriendsFromJson(Map<String, dynamic> json) {
  return NonAdedFriends(
    json['id'],
    json['user_id'],
    json['firstName'],
    json['lastName'],
    json['profilePic'],
    json['userName'],
  );
}

Map<String, dynamic> _$NonAdedFriendsToJson(NonAdedFriends instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'userName': instance.userName,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profilePic': instance.profilePic,
    };
