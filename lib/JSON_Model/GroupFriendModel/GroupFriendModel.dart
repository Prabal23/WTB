import 'package:json_annotation/json_annotation.dart';

part 'GroupFriendModel.g.dart';

@JsonSerializable()
class GroupFriendModel {
  List<NonAdedFriends> nonAdedFriends;
  GroupFriendModel(this.nonAdedFriends);
  factory GroupFriendModel.fromJson(Map<String, dynamic> json) =>
      _$GroupFriendModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupFriendModelToJson(this);
}

@JsonSerializable()
class NonAdedFriends {
  var id;
  var user_id;
  var userName;
  var firstName;
  var lastName;
  var profilePic;

  NonAdedFriends(
      this.id,
      this.user_id,
      this.firstName,
      this.lastName,
      this.profilePic,
      this.userName);
  factory NonAdedFriends.fromJson(Map<String, dynamic> json) => _$NonAdedFriendsFromJson(json);
  Map<String, dynamic> toJson() => _$NonAdedFriendsToJson(this);
}