// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AllShopModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllShopModel _$AllShopModelFromJson(Map<String, dynamic> json) {
  return AllShopModel(
    json['shops'] == null
        ? null
        : Shops.fromJson(json['shops'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$AllShopModelToJson(AllShopModel instance) =>
    <String, dynamic>{
      'shops': instance.shops,
    };

Shops _$ShopsFromJson(Map<String, dynamic> json) {
  return Shops(
    (json['data'] as List)
        ?.map(
            (e) => e == null ? null : Data.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    json['lastPage'],
    json['page'],
    json['perPage'],
    json['total'],
  );
}

Map<String, dynamic> _$ShopsToJson(Shops instance) => <String, dynamic>{
      'total': instance.total,
      'perPage': instance.perPage,
      'page': instance.page,
      'lastPage': instance.lastPage,
      'data': instance.data,
    };

Data _$DataFromJson(Map<String, dynamic> json) {
  return Data(
    json['shopType'],
    json['location'],
    json['id'],
    json['about'],
    json['banner'],
    json['logo'],
    json['shopLink'],
    json['shopName'],
    json['shopTagLine'],
    json['verified'] == null
        ? null
        : Verified.fromJson(json['verified'] as Map<String, dynamic>),
    json['shopcategory_id'],
    json['seller_id'],
    json['status'],
    json['created_at'],
    json['updated_at'],
    json['__meta__'] == null
        ? null
        : Meta.fromJson(json['__meta__'] as Map<String, dynamic>),
    json['seller'] == null
        ? null
        : Seller.fromJson(json['seller'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'id': instance.id,
      'shopLink': instance.shopLink,
      'shopName': instance.shopName,
      'location': instance.location,
      'shopType': instance.shopType,
      'about': instance.about,
      'logo': instance.logo,
      'banner': instance.banner,
      'shopTagLine': instance.shopTagLine,
      'verified': instance.verified,
      'seller': instance.seller,
      '__meta__': instance.meta,
      'shopcategory_id': instance.shopcategoryId,
      'seller_id': instance.sellerId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'status': instance.status,
    };

Verified _$VerifiedFromJson(Map<String, dynamic> json) {
  return Verified(
    json['id'],
    json['status'],
  );
}

Map<String, dynamic> _$VerifiedToJson(Verified instance) => <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
    };

Seller _$SellerFromJson(Map<String, dynamic> json) {
  return Seller(
    json['id'],
    json['firstName'],
    json['lastName'],
    json['profilePic'],
  );
}

Map<String, dynamic> _$SellerToJson(Seller instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'profilePic': instance.profilePic,
    };

Meta _$MetaFromJson(Map<String, dynamic> json) {
  return Meta(
    json['products_count'],
  );
}

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'products_count': instance.productsCount,
    };
