// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_Model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Connection _$ConnectionFromJson(Map<String, dynamic> json) {
  return Connection(
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    (json['res'] as List)
        ?.map((e) => e == null ? null : Res.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ConnectionToJson(Connection instance) =>
    <String, dynamic>{
      'user': instance.user,
      'res': instance.res,
    };

Res _$ResFromJson(Map<String, dynamic> json) {
  return Res(
    json['id'],
    json['firstName'],
    json['lastName'],
    json['profilePic'],
    json['jobTitle'],
    json['dayJob'],
    json['userName'],
    json['tag'],
    json['friendStatus'],
  );
}

Map<String, dynamic> _$ResToJson(Res instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profilePic': instance.profilePic,
      'jobTitle': instance.jobTitle,
      'dayJob': instance.dayJob,
      'userName': instance.userName,
      'tag': instance.tag,
      'friendStatus': instance.friendStatus,
    };

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['id'],
    json['firstName'],
    json['lastName'],
    json['isOnline'],
    json['profilePic'],
    json['jobTitle'],
    json['dayJob'],
    json['userName'],
    json['country'],
    json['shop_id'],
    json['avgReview'],
    json['isFriend'] == null
        ? null
        : IsFriend.fromJson(json['isFriend'] as Map<String, dynamic>),
    json['isRequestSent'] == null
        ? null
        : IsRequestSent.fromJson(json['isRequestSent'] as Map<String, dynamic>),
    json['email'],
    json['gender'],
    json['userType'],
    json['verified'] == null
        ? null
        : Verified.fromJson(json['verified'] as Map<String, dynamic>),
    (json['interestLists'] as List)
        ?.map((e) => e == null
            ? null
            : InterestLists.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'isOnline': instance.isOnline,
      'profilePic': instance.profilePic,
      'jobTitle': instance.jobTitle,
      'dayJob': instance.dayJob,
      'userName': instance.userName,
      'country': instance.country,
      'shop_id': instance.shop_id,
      'avgReview': instance.avgReview,
      'email': instance.email,
      'gender': instance.gender,
      'userType': instance.userType,
      'verified': instance.verified,
      'isRequestSent': instance.isRequestSent,
      'isFriend': instance.isFriend,
      'interestLists': instance.interestLists,
    };

IsFriend _$IsFriendFromJson(Map<String, dynamic> json) {
  return IsFriend(
    json['id'],
    json['reason'],
  );
}

Map<String, dynamic> _$IsFriendToJson(IsFriend instance) => <String, dynamic>{
      'id': instance.id,
      'reason': instance.reason,
    };

Verified _$VerifiedFromJson(Map<String, dynamic> json) {
  return Verified(
    json['id'],
    json['status'],
  );
}

Map<String, dynamic> _$VerifiedToJson(Verified instance) => <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
    };

IsRequestSent _$IsRequestSentFromJson(Map<String, dynamic> json) {
  return IsRequestSent(
    json['id'],
    json['status'],
    json['following_id'],
  );
}

Map<String, dynamic> _$IsRequestSentToJson(IsRequestSent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'following_id': instance.following_id,
    };

InterestLists _$InterestListsFromJson(Map<String, dynamic> json) {
  return InterestLists(
    json['id'],
    json['tag'],
  );
}

Map<String, dynamic> _$InterestListsToJson(InterestLists instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tag': instance.tag,
    };
