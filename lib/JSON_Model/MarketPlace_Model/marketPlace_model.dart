import 'package:json_annotation/json_annotation.dart';

part 'marketPlace_model.g.dart';

@JsonSerializable()
class MarketPlaceModel {
  var total;
  var perPage;
  var page;
  var lastPage;
  List<Data> data;
  MarketPlaceModel(this.data, this.lastPage, this.page, this.perPage);
  factory MarketPlaceModel.fromJson(Map<String, dynamic> json) =>
      _$MarketPlaceModelFromJson(json);
  Map<String, dynamic> toJson() => _$MarketPlaceModelToJson(this);
}

@JsonSerializable()
class Data {
  var id;
  var productName;
  var productDesc;
  var status;
  var lowerPrice;
  var upperPrice;
  List<Images> images;
  Shops shop;
  //SingleImage singleImage;
  @JsonKey(name: "shop_id")
  dynamic shopId;
  var country;
  var unit;
  var minimumOrderQuantity;
  var estimatedDeliveryDays;
  var created_at;
  var updated_at;
  Data(
      this.id,
      this.productName,
      this.lowerPrice,
      this.productDesc,
      this.status,
      this.upperPrice,
      this.shopId,
      this.country,
      this.minimumOrderQuantity,
      this.unit,
      this.estimatedDeliveryDays,
      this.created_at,
      this.updated_at,
      this.images,
      this.shop);
  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Images {
  var id;
  var image;

  Images(
    this.id,
    this.image,
  );

  factory Images.fromJson(Map<String, dynamic> json) =>
      _$ImagesFromJson(json);
  Map<String, dynamic> toJson() => _$ImagesToJson(this);
}

@JsonSerializable()
class Shops {
  var id;
  var shopName;
  Shops(
    this.id,
    this.shopName,
  );
  factory Shops.fromJson(Map<String, dynamic> json) => _$ShopsFromJson(json);
  Map<String, dynamic> toJson() => _$ShopsToJson(this);
}
