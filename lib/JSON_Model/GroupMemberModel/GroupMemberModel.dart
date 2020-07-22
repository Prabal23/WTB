import 'package:json_annotation/json_annotation.dart';

part 'GroupMemberModel.g.dart';

@JsonSerializable()
class GroupMemberModel {
  List<AllMembers> allMembers;

  GroupMemberModel(this.allMembers);
  factory GroupMemberModel.fromJson(Map<String, dynamic> json) =>
      _$GroupMemberModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupMemberModelToJson(this);
}

@JsonSerializable()
class AllMembers {
  var id;
  var user_id;
  var isAdmin;
  var isCreator;
  var missedPosts;
  User user;

  AllMembers(this.id, this.isAdmin, this.isCreator, this.missedPosts, this.user, this.user_id);
  factory AllMembers.fromJson(Map<String, dynamic> json) => _$AllMembersFromJson(json);
  Map<String, dynamic> toJson() => _$AllMembersToJson(this);
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