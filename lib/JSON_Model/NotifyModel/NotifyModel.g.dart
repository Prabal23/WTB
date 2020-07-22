// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NotifyModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotifyModel _$NotifyModelFromJson(Map<String, dynamic> json) {
  return NotifyModel(
    (json['allNotification'] as List)
        ?.map((e) => e == null
            ? null
            : AllNotification.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$NotifyModelToJson(NotifyModel instance) =>
    <String, dynamic>{
      'allNotification': instance.allNotification,
    };

AllNotification _$AllNotificationFromJson(Map<String, dynamic> json) {
  return AllNotification(
    json['id'],
    json['name'],
    json['url'],
    json['notiTxt'],
    json['seen'],
    json['created_at'],
  );
}

Map<String, dynamic> _$AllNotificationToJson(AllNotification instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'url': instance.url,
      'notiTxt': instance.notiTxt,
      'seen': instance.seen,
      'created_at': instance.created_at,
    };
