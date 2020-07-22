// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GroupPostModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupPostModel _$GroupPostModelFromJson(Map<String, dynamic> json) {
  return GroupPostModel(
    (json['communityPosts'] as List)
        ?.map((e) => e == null
            ? null
            : CommunityPosts.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$GroupPostModelToJson(GroupPostModel instance) =>
    <String, dynamic>{
      'communityPosts': instance.communityPosts,
    };

CommunityPosts _$CommunityPostsFromJson(Map<String, dynamic> json) {
  return CommunityPosts(
    json['id'],
    json['status'],
    json['images'],
    json['privacy'],
    json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    json['__meta__'] == null
        ? null
        : Meta.fromJson(json['__meta__'] as Map<String, dynamic>),
    json['isRead'],
    json['like'],
    json['community_id'],
    json['user_id'],
    json['title'],
    json['interest'],
    json['link'],
    json['link_meta'],
    json['type'],
    json['commentCount'],
    json['shareCount'],
    json['created_at'],
    json['updated_at'],
  );
}

Map<String, dynamic> _$CommunityPostsToJson(CommunityPosts instance) =>
    <String, dynamic>{
      'id': instance.id,
      'community_id': instance.community_id,
      'user_id': instance.user_id,
      'title': instance.title,
      'status': instance.status,
      'images': instance.images,
      'interest': instance.interest,
      'link': instance.link,
      'link_meta': instance.link_meta,
      'privacy': instance.privacy,
      'type': instance.type,
      'commentCount': instance.commentCount,
      'shareCount': instance.shareCount,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'isRead': instance.isRead,
      'like': instance.like,
      'user': instance.user,
      '__meta__': instance.meta,
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

Meta _$MetaFromJson(Map<String, dynamic> json) {
  return Meta(
    json['totalComments_count'],
    json['totalLikes_count'],
    json['totalFollow_count'],
  );
}

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'totalComments_count': instance.totalCommentsCount,
      'totalLikes_count': instance.totalLikesCount,
      'totalFollow_count': instance.totalFollowCount,
    };
