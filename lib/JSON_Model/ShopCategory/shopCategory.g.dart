// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopCategory.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopCategory _$ShopCategoryFromJson(Map<String, dynamic> json) {
  return ShopCategory(
    (json['cat'] as List)
        ?.map((e) => e == null ? null : Cat.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ShopCategoryToJson(ShopCategory instance) =>
    <String, dynamic>{
      'cat': instance.cat,
    };

Cat _$CatFromJson(Map<String, dynamic> json) {
  return Cat(
    json['id'],
    json['name'],
  );
}

Map<String, dynamic> _$CatToJson(Cat instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
