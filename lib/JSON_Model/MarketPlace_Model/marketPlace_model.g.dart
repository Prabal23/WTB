// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketPlace_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketPlaceModel _$MarketPlaceModelFromJson(Map<String, dynamic> json) {
  return MarketPlaceModel(
    (json['data'] as List)
        ?.map(
            (e) => e == null ? null : Data.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['lastPage'],
    json['page'],
    json['perPage'],
  )..total = json['total'];
}

Map<String, dynamic> _$MarketPlaceModelToJson(MarketPlaceModel instance) =>
    <String, dynamic>{
      'total': instance.total,
      'perPage': instance.perPage,
      'page': instance.page,
      'lastPage': instance.lastPage,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
    json['id'],
    json['productName'],
    json['lowerPrice'],
    json['productDesc'],
    json['status'],
    json['upperPrice'],
    json['shop_id'],
    json['country'],
    json['minimumOrderQuantity'],
    json['unit'],
    json['estimatedDeliveryDays'],
    json['created_at'],
    json['updated_at'],
    (json['images'] as List)
        ?.map((e) =>
            e == null ? null : Images.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['shop'] == null
        ? null
        : Shops.fromJson(json['shop'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'id': instance.id,
      'productName': instance.productName,
      'productDesc': instance.productDesc,
      'status': instance.status,
      'lowerPrice': instance.lowerPrice,
      'upperPrice': instance.upperPrice,
      'images': instance.images,
      'shop': instance.shop,
      'shop_id': instance.shopId,
      'country': instance.country,
      'unit': instance.unit,
      'minimumOrderQuantity': instance.minimumOrderQuantity,
      'estimatedDeliveryDays': instance.estimatedDeliveryDays,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
    };

Images _$ImagesFromJson(Map<String, dynamic> json) {
  return Images(
    json['id'],
    json['image'],
  );
}

Map<String, dynamic> _$ImagesToJson(Images instance) => <String, dynamic>{
      'id': instance.id,
      'image': instance.image,
    };

Shops _$ShopsFromJson(Map<String, dynamic> json) {
  return Shops(
    json['id'],
    json['shopName'],
  );
}

Map<String, dynamic> _$ShopsToJson(Shops instance) => <String, dynamic>{
      'id': instance.id,
      'shopName': instance.shopName,
    };
