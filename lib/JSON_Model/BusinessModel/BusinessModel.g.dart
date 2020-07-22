// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BusinessModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessModel _$BusinessModelFromJson(Map<String, dynamic> json) {
  return BusinessModel(
    json['res'] == null
        ? null
        : Res.fromJson(json['res'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$BusinessModelToJson(BusinessModel instance) =>
    <String, dynamic>{
      'res': instance.res,
    };

Res _$ResFromJson(Map<String, dynamic> json) {
  return Res(
    json['id'],
    json['name'],
    json['website'],
    json['address'],
    json['operatingAddress'],
    json['taxNumber'],
    json['yearEstablished'],
    json['totalEmployies'],
    json['businessOfferings'],
    json['businessCertifications'],
    json['directorName'],
    json['contactPerson'],
    json['contactNumber'],
    json['businessPortfolio'],
    (json['files'] as List)
        ?.map(
            (e) => e == null ? null : Files.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ResToJson(Res instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'website': instance.website,
      'address': instance.address,
      'operatingAddress': instance.operatingAddress,
      'taxNumber': instance.taxNumber,
      'yearEstablished': instance.yearEstablished,
      'totalEmployies': instance.totalEmployies,
      'businessOfferings': instance.businessOfferings,
      'businessCertifications': instance.businessCertifications,
      'directorName': instance.directorName,
      'contactPerson': instance.contactPerson,
      'contactNumber': instance.contactNumber,
      'businessPortfolio': instance.businessPortfolio,
      'files': instance.files,
    };

Files _$FilesFromJson(Map<String, dynamic> json) {
  return Files(
    json['id'],
    json['bdetails_id'],
    json['portfolio'],
  );
}

Map<String, dynamic> _$FilesToJson(Files instance) => <String, dynamic>{
      'id': instance.id,
      'bdetails_id': instance.bdetails_id,
      'portfolio': instance.portfolio,
    };
