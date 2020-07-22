import 'package:json_annotation/json_annotation.dart';

part 'NotifyModel.g.dart';

@JsonSerializable()
class NotifyModel {
  List<AllNotification> allNotification;
  NotifyModel(this.allNotification);
  factory NotifyModel.fromJson(Map<String, dynamic> json) => _$NotifyModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotifyModelToJson(this);
}

@JsonSerializable()
class AllNotification {
  var id;
  var name;
  var url;
  var notiTxt;
  var seen;
  var created_at;

  AllNotification(this.id, this.name, this.url, this.notiTxt, this.seen,
      this.created_at);
  factory AllNotification.fromJson(Map<String, dynamic> json) => _$AllNotificationFromJson(json);
  Map<String, dynamic> toJson() => _$AllNotificationToJson(this);
}