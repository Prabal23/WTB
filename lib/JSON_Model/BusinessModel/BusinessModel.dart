import 'package:json_annotation/json_annotation.dart';

part 'BusinessModel.g.dart';

@JsonSerializable()
class BusinessModel {
  Res res;
  BusinessModel(this.res);
  factory BusinessModel.fromJson(Map<String, dynamic> json) =>
      _$BusinessModelFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessModelToJson(this);
}

@JsonSerializable()
class Res {
  var id;
  var name;
  var website;
  var address;
  var operatingAddress;
  var taxNumber;
  var yearEstablished;
  var totalEmployies;
  var businessOfferings;
  var businessCertifications;
  var directorName;
  var contactPerson;
  var contactNumber;
  var businessPortfolio;
  List<Files> files;

  Res(
      this.id,
      this.name,
      this.website,
      this.address,
      this.operatingAddress,
      this.taxNumber,
      this.yearEstablished,
      this.totalEmployies,
      this.businessOfferings,
      this.businessCertifications,
      this.directorName,
      this.contactPerson,
      this.contactNumber,
      this.businessPortfolio, this.files);

  factory Res.fromJson(Map<String, dynamic> json) => _$ResFromJson(json);
  Map<String, dynamic> toJson() => _$ResToJson(this);
}

@JsonSerializable()
class Files {
  var id;
  var bdetails_id;
  var portfolio;

  Files(
      this.id,
      this.bdetails_id,
      this.portfolio);

  factory Files.fromJson(Map<String, dynamic> json) => _$FilesFromJson(json);
  Map<String, dynamic> toJson() => _$FilesToJson(this);
}
