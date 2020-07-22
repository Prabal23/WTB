import 'package:json_annotation/json_annotation.dart';

part 'AllShopModel.g.dart';

@JsonSerializable()
class AllShopModel {
  Shops shops;
  AllShopModel(this.shops);
  factory AllShopModel.fromJson(Map<String, dynamic> json) =>
      _$AllShopModelFromJson(json);
  Map<String, dynamic> toJson() => _$AllShopModelToJson(this);
}

@JsonSerializable()
class Shops {
  var total;
  var perPage;
  var page;
  var lastPage;
  List<Data> data;
  Shops(this.data, this.lastPage, this.page, this.perPage, this.total);
  factory Shops.fromJson(Map<String, dynamic> json) => _$ShopsFromJson(json);
  Map<String, dynamic> toJson() => _$ShopsToJson(this);
}

@JsonSerializable()
class Data {
  var id;
  var shopLink;
  var shopName;
  var location;
  var shopType;
  var about;
  var logo;
  var banner;
  var shopTagLine;
  Verified verified;
  Seller seller;
  @JsonKey(name: "__meta__")
  final Meta meta;
  @JsonKey(name: "shopcategory_id")
  dynamic shopcategoryId;
  @JsonKey(name: "seller_id")
  dynamic sellerId;
  @JsonKey(name: "created_at")
  dynamic createdAt;
  @JsonKey(name: "updated_at")
  dynamic updatedAt;
  var status;
  Data(
      this.shopType,
      this.location,
      this.id,
      this.about,
      this.banner,
      this.logo,
      this.shopLink,
      this.shopName,
      this.shopTagLine,
      this.verified,
      this.shopcategoryId,
      this.sellerId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.meta,
      this.seller);
  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Verified {
  var id;
  var status;

  Verified(this.id, this.status);
  factory Verified.fromJson(Map<String, dynamic> json) =>
      _$VerifiedFromJson(json);
  Map<String, dynamic> toJson() => _$VerifiedToJson(this);
}

@JsonSerializable()
class Seller {
  var id;
  var firstName;
  var lastName;
  var profilePic;

  Seller(this.id, this.firstName, this.lastName, this.profilePic);
  factory Seller.fromJson(Map<String, dynamic> json) => _$SellerFromJson(json);
  Map<String, dynamic> toJson() => _$SellerToJson(this);
}

@JsonSerializable()
class Meta {
  @JsonKey(name: "products_count")
  dynamic productsCount;

  Meta(this.productsCount);
  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
  Map<String, dynamic> toJson() => _$MetaToJson(this);
}
