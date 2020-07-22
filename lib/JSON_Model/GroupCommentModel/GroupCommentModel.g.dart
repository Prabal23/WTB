// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GroupCommentModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupCommentModel _$GroupCommentModelFromJson(Map<String, dynamic> json) {
  return GroupCommentModel(
    (json['allComments'] as List)
        ?.map((e) =>
            e == null ? null : AllComments.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$GroupCommentModelToJson(GroupCommentModel instance) =>
    <String, dynamic>{
      'allComments': instance.allComments,
    };

AllComments _$AllCommentsFromJson(Map<String, dynamic> json) {
  return AllComments(
    json['comment'],
    json['id'],
    json['compost_id'],
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    json['user_id'],
    json['like'],
    json['__meta__'] == null
        ? null
        : Reply.fromJson(json['__meta__'] as Map<String, dynamic>),
    json['updated_at'],
    json['created_at'],
  );
}

Map<String, dynamic> _$AllCommentsToJson(AllComments instance) =>
    <String, dynamic>{
      'id': instance.id,
      'comment': instance.comment,
      'compost_id': instance.compostId,
      'user_id': instance.userId,
      'like': instance.like,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'user': instance.user,
      '__meta__': instance.reply,
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

Reply _$ReplyFromJson(Map<String, dynamic> json) {
  return Reply(
    json['totalLike_count'],
    json['totalReply_count'],
  );
}

Map<String, dynamic> _$ReplyToJson(Reply instance) => <String, dynamic>{
      'totalReply_count': instance.totalReplyCount,
      'totalLike_count': instance.totalLikeCount,
    };
