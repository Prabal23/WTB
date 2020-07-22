// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GroupReplyModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupReplyModel _$GroupReplyModelFromJson(Map<String, dynamic> json) {
  return GroupReplyModel(
    (json['allReplies'] as List)
        ?.map((e) =>
            e == null ? null : AllReplies.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$GroupReplyModelToJson(GroupReplyModel instance) =>
    <String, dynamic>{
      'allReplies': instance.allReplies,
    };

AllReplies _$AllRepliesFromJson(Map<String, dynamic> json) {
  return AllReplies(
    json['replyTxt'],
    json['id'],
    json['comment_id'],
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    json['user_id'],
    json['like'],
    json['__meta__'] == null
        ? null
        : Replay.fromJson(json['__meta__'] as Map<String, dynamic>),
    json['created_at'],
    json['updated_at'],
  );
}

Map<String, dynamic> _$AllRepliesToJson(AllReplies instance) =>
    <String, dynamic>{
      'id': instance.id,
      'replyTxt': instance.replyTxt,
      'comment_id': instance.commentId,
      'user_id': instance.userId,
      'like': instance.like,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'user': instance.user,
      '__meta__': instance.replay,
    };

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['jobTitle'],
    json['profilePic'],
    json['id'],
    json['firstName'],
    json['lastName'],
    json['userName'],
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profilePic': instance.profilePic,
      'jobTitle': instance.jobTitle,
    };

Replay _$ReplayFromJson(Map<String, dynamic> json) {
  return Replay(
    json['totalLike_count'],
  );
}

Map<String, dynamic> _$ReplayToJson(Replay instance) => <String, dynamic>{
      'totalLike_count': instance.totalLikeCount,
    };
