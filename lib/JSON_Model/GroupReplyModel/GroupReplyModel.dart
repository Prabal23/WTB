import 'package:json_annotation/json_annotation.dart';

part 'GroupReplyModel.g.dart';

@JsonSerializable()
class GroupReplyModel {
  List<AllReplies> allReplies;
  GroupReplyModel(this.allReplies);
  factory GroupReplyModel.fromJson(Map<String, dynamic> json) =>
      _$GroupReplyModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupReplyModelToJson(this);
}

@JsonSerializable()
class AllReplies {
  var id;
  var replyTxt;
  @JsonKey(name: "comment_id")
  dynamic commentId;
  @JsonKey(name: "user_id")
  dynamic userId;
  var like;
  var created_at;
  var updated_at;
  User user;
  @JsonKey(name: "__meta__")
  final Replay replay;
  AllReplies(this.replyTxt, this.id, this.commentId, this.user, this.userId,
      this.like, this.replay, this.created_at, this.updated_at);
  factory AllReplies.fromJson(Map<String, dynamic> json) =>
      _$AllRepliesFromJson(json);
  Map<String, dynamic> toJson() => _$AllRepliesToJson(this);
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
class Replay {
  @JsonKey(name: "totalLike_count")
  dynamic totalLikeCount;
  Replay(this.totalLikeCount);
  factory Replay.fromJson(Map<String, dynamic> json) => _$ReplayFromJson(json);
  Map<String, dynamic> toJson() => _$ReplayToJson(this);
}
