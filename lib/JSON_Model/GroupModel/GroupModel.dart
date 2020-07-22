import 'package:json_annotation/json_annotation.dart';

part 'GroupModel.g.dart';

@JsonSerializable()
class GroupModel {
  var id;
  var name;
  var about;
  var logo;
  var status;
  var category;
  var slug;
  @JsonKey(name: "__meta__")
  final Meta meta;

  GroupModel(this.id, this.name, this.about, this.logo, this.status,
      this.category, this.slug, this.meta);
  factory GroupModel.fromJson(Map<String, dynamic> json) =>
      _$GroupModelFromJson(json);
  Map<String, dynamic> toJson() => _$GroupModelToJson(this);
}

@JsonSerializable()
class Meta {
  @JsonKey(name: "totalMembers_count")
  dynamic totalMembersCount;

  Meta(this.totalMembersCount);
  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
  Map<String, dynamic> toJson() => _$MetaToJson(this);
}
