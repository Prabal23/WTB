// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GroupModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupModel _$GroupModelFromJson(Map<String, dynamic> json) {
  return GroupModel(
    json['id'],
    json['name'],
    json['about'],
    json['logo'],
    json['status'],
    json['category'],
    json['slug'],
    json['__meta__'] == null
        ? null
        : Meta.fromJson(json['__meta__'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$GroupModelToJson(GroupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'about': instance.about,
      'logo': instance.logo,
      'status': instance.status,
      'category': instance.category,
      'slug': instance.slug,
      '__meta__': instance.meta,
    };

Meta _$MetaFromJson(Map<String, dynamic> json) {
  return Meta(
    json['totalMembers_count'],
  );
}

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'totalMembers_count': instance.totalMembersCount,
    };
