import 'package:json_annotation/json_annotation.dart';

part 'GroupPostModel.g.dart';

@JsonSerializable()
class GroupPostModel {
  List<CommunityPosts> communityPosts;
  GroupPostModel(this.communityPosts);
  factory GroupPostModel.fromJson(Map<String, dynamic> json) =>
      _$GroupPostModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupPostModelToJson(this);
}

@JsonSerializable()
class CommunityPosts {
  var id;
  var community_id;
  var user_id;
  var title;
  var status;
  var images;
  var interest;
  var link;
  var link_meta;
  var privacy;
  var type;
  var commentCount;
  var shareCount;
  var created_at;
  var updated_at;
  var isRead;
  var like;
  User user;
  @JsonKey(name: "__meta__")
  final Meta meta;

  CommunityPosts(
    this.id,
    this.status,
    this.images,
    this.privacy,
    this.user,
    this.meta,
    this.isRead,
    this.like,
    this.community_id,
    this.user_id,
    this.title,
    this.interest,
    this.link,
    this.link_meta,
    this.type,
    this.commentCount,
    this.shareCount,
    this.created_at,
    this.updated_at,
  );
  factory CommunityPosts.fromJson(Map<String, dynamic> json) =>
      _$CommunityPostsFromJson(json);
  Map<String, dynamic> toJson() => _$CommunityPostsToJson(this);
}

@JsonSerializable()
class User {
  var id;
  var firstName;
  var lastName;
  var userName;
  var profilePic;
  var jobTitle;

  User(this.id, this.firstName, this.lastName, this.userName, this.jobTitle,
      this.profilePic);
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Meta {
  @JsonKey(name: "totalComments_count")
  dynamic totalCommentsCount;
  @JsonKey(name: "totalLikes_count")
  dynamic totalLikesCount;
  @JsonKey(name: "totalFollow_count")
  dynamic totalFollowCount;

  Meta(
    this.totalCommentsCount,
    this.totalLikesCount,
    this.totalFollowCount,
  );
  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
  Map<String, dynamic> toJson() => _$MetaToJson(this);
}
