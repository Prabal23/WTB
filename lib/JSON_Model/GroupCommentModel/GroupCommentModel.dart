import 'package:json_annotation/json_annotation.dart';

part 'GroupCommentModel.g.dart';

@JsonSerializable()
class GroupCommentModel {
  List<AllComments> allComments;
  GroupCommentModel(this.allComments);
  factory GroupCommentModel.fromJson(Map<String, dynamic> json) =>
      _$GroupCommentModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupCommentModelToJson(this);
}

@JsonSerializable()
class AllComments {
  var id;
  var comment;
  @JsonKey(name: "compost_id")
  dynamic compostId;
  @JsonKey(name: "user_id")
  dynamic userId;
  var like;
  var created_at;
  var updated_at;
  User user;
  @JsonKey(name: "__meta__")
  final Reply reply;
  AllComments(this.comment, this.id, this.compostId, this.user,
      this.userId, this.like, this.reply, this.updated_at, this.created_at);
  factory AllComments.fromJson(Map<String, dynamic> json) =>
      _$AllCommentsFromJson(json);
  Map<String, dynamic> toJson() => _$AllCommentsToJson(this);
}

@JsonSerializable()
class User {
  var id;
  var userName;
  var firstName;
  var lastName;
  var profilePic;
  var jobTitle;
  User(this.jobTitle, this.profilePic, this.id, this.firstName, this.lastName,
      this.userName);
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class Reply {
   @JsonKey(name: "totalReply_count")
  dynamic totalReplyCount;
   @JsonKey(name: "totalLike_count")
  dynamic totalLikeCount;
  Reply(this.totalLikeCount, this.totalReplyCount);
  factory Reply.fromJson(Map<String, dynamic> json) =>
      _$ReplyFromJson(json);
  Map<String, dynamic> toJson() => _$ReplyToJson(this);
}