// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NewsFeedModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedPosts _$FeedPostsFromJson(Map<String, dynamic> json) {
  return FeedPosts(
    (json['feed'] as List)
        ?.map(
            (e) => e == null ? null : Feed.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['lcid'],
    json['llid'],
    json['lsid'],
    json['sid'],
  );
}

Map<String, dynamic> _$FeedPostsToJson(FeedPosts instance) => <String, dynamic>{
      'feed': instance.feed,
      'llid': instance.llid,
      'lcid': instance.lcid,
      'lsid': instance.lsid,
      'sid': instance.sid,
    };

Feed _$FeedFromJson(Map<String, dynamic> json) {
  return Feed(
    json['id'],
    json['feedType'],
    json['sourceId'],
    json['activitytext'],
    json['interests'],
    json['like'],
    json['privacy'],
    json['fuser'] == null
        ? null
        : Fuser.fromJson(json['fuser'] as Map<String, dynamic>),
    json['__meta__'] == null
        ? null
        : Meta.fromJson(json['__meta__'] as Map<String, dynamic>),
    json['user_id'],
    json['data'] == null
        ? null
        : Data.fromJson(json['data'] as Map<String, dynamic>),
    json['isRead'],
    json['created_at'],
    json['updated_at'],
  );
}

Map<String, dynamic> _$FeedToJson(Feed instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'sourceId': instance.sourceId,
      'feedType': instance.feedType,
      'activitytext': instance.activitytext,
      'interests': instance.interests,
      'privacy': instance.privacy,
      'like': instance.like,
      'isRead': instance.isRead,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'data': instance.data,
      'fuser': instance.fuser,
      '__meta__': instance.meta,
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
    json['status'],
    json['comName'],
    json['interest'],
    json['privacy'],
    json['link_meta'],
    json['isEdit'],
    json['link'],
    (json['images'] as List)
        ?.map((e) =>
            e == null ? null : Images.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['sharedTxt'],
    json['fuser'] == null
        ? null
        : Fuser.fromJson(json['fuser'] as Map<String, dynamic>),
    json['isRead'],
    json['feedType'],
  );
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'status': instance.status,
      'comName': instance.comName,
      'interest': instance.interest,
      'privacy': instance.privacy,
      'link_meta': instance.linkMeta,
      'link': instance.link,
      'isEdit': instance.isEdit,
      'isRead': instance.isRead,
      'sharedTxt': instance.sharedTxt,
      'feedType': instance.feedType,
      'fuser': instance.fuser,
      'images': instance.images,
    };

Images _$ImagesFromJson(Map<String, dynamic> json) {
  return Images(
    json['id'],
    json['user_id'],
    json['file'],
    json['thum'],
    json['type'],
    json['created_at'],
    json['updated_at'],
  );
}

Map<String, dynamic> _$ImagesToJson(Images instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.user_id,
      'file': instance.file,
      'thum': instance.thum,
      'type': instance.type,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };

Fuser _$FuserFromJson(Map<String, dynamic> json) {
  return Fuser(
    json['id'],
    json['firstName'],
    json['lastName'],
    json['userName'],
    json['jobTitle'],
    json['profilePic'],
  );
}

Map<String, dynamic> _$FuserToJson(Fuser instance) => <String, dynamic>{
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
    json['totalShares_count'],
  );
}

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'totalComments_count': instance.totalCommentsCount,
      'totalLikes_count': instance.totalLikesCount,
      'totalShares_count': instance.totalSharesCount,
    };
